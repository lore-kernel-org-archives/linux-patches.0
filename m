Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38902239573;
	Tue, 26 Aug 2025 11:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207497; cv=none; b=lr8GRuyZo2kio7FM2ZDmkNjlh6rV+rwb5IbXlAu5kJNd0sPoUUmB3xggU1Kmr7u221cVBM/aqWs2OCkWjDQ+wbY6nvn352wGw9YT50D2r9c7q8cw3UxycMCG80r8dJ5sO0YcZyw1lQVxMsY3o4z9vRMA/crkhhp0ntFvJGT+72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207497; c=relaxed/simple;
	bh=u7wMnGejLZTWLTqgSfGUpxNT2X0+RMp9zxq5shM0+ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApOB8liutdktcNChdIH7czWZn2AeCReNe4UGCTgTaWOZOmKJrs+BGR+LaAL7bSPLUoIQJ6+lVqQvRPEt7IeUBZYhM5avYWexSCwlTjLQAIY8j3LD42OF9IjNEkVrdeFCG4vKGT5mpg+sh7RX8Jbmsd0MZTUti1vwq7njveOD93g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPpeo4Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPpeo4Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC01FC116D0;
	Tue, 26 Aug 2025 11:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207497;
	bh=u7wMnGejLZTWLTqgSfGUpxNT2X0+RMp9zxq5shM0+ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPpeo4DkZjKmJsmGE4HEHxrhHkkHyLo/RUvTwRVGuxSQom9WHHI5ymlgNWtFWS+Nc
	 2J5ynTLWIqnpWfEvm2yWXWQeXvks4WINea7P65e6ofS2aSqo415mPonTDgOzLpsB8e
	 hbn12L1uA50tVIAMXogvn50XPtP0Ow9lfc+5mfs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 204/457] mptcp: drop skb if MPTCP skb extension allocation fails
Date: Tue, 26 Aug 2025 13:08:08 +0200
Message-ID: <20250826110942.408066789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <cpaasch@openai.com>

commit ccab044697980c6c01ab51f43f48f13b8a3e5c33 upstream.

When skb_ext_add(skb, SKB_EXT_MPTCP) fails in mptcp_incoming_options(),
we used to return true, letting the segment proceed through the TCP
receive path without a DSS mapping. Such segments can leave inconsistent
mapping state and trigger a mid-stream fallback to TCP, which in testing
collapsed (by artificially forcing failures in skb_ext_add) throughput
to zero.

Return false instead so the TCP input path drops the skb (see
tcp_data_queue() and step-7 processing). This is the safer choice
under memory pressure: it preserves MPTCP correctness and provides
backpressure to the sender.

Control packets remain unaffected: ACK updates and DATA_FIN handling
happen before attempting the extension allocation, and tcp_reset()
continues to ignore the return value.

With this change, MPTCP continues to work at high throughput if we
artificially inject failures into skb_ext_add.

Fixes: 6787b7e350d3 ("mptcp: avoid processing packet if a subflow reset")
Cc: stable@vger.kernel.org
Signed-off-by: Christoph Paasch <cpaasch@openai.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-1-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1117,7 +1117,9 @@ static bool add_addr_hmac_valid(struct m
 	return hmac == mp_opt->ahmac;
 }
 
-/* Return false if a subflow has been reset, else return true */
+/* Return false in case of error (or subflow has been reset),
+ * else return true.
+ */
 bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -1221,7 +1223,7 @@ bool mptcp_incoming_options(struct sock
 
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (!mpext)
-		return true;
+		return false;
 
 	memset(mpext, 0, sizeof(*mpext));
 


