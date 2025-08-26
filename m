Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B0134F484;
	Tue, 26 Aug 2025 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216695; cv=none; b=X4JsIh2TmUkpJlzumX+Ol0X+agxvhi94ik4Y/i+t0+wa5piY01TLtFCm5tUrdMRjRkhHZSY03zexRLAcFKfq/SafyWrUeYHQAQ+2iLVhgezC3MsA327LKFhs/+AZB5nItzIHMB8FdW5jOJAGD4FAkz/T6idTUBwyHgsbwL+nniM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216695; c=relaxed/simple;
	bh=BQLe7ZBP/lujoJPGaPOqsAtYGXA7iqxuWzUMEcO1Gk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivdkHIKDCj8HqC7idYu2QQkmA5DvMCJVxVHXMc9onSzNDpBaWPMR+eGDkI0VtKf6cDrFDrOT97ViSByBVyp4YnQABhbzdfX7nNsW3Dc9qjsPtDNrU0Z0sqq5Dl4NXL8+D0RpOPZB+3UuaqZQBzXleEZFO6IxD0Fymy1UM8kwDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjnBAwYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjnBAwYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D12DC4CEF1;
	Tue, 26 Aug 2025 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216695;
	bh=BQLe7ZBP/lujoJPGaPOqsAtYGXA7iqxuWzUMEcO1Gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjnBAwYIDtXapEdMNxqVsmknGqlVPIgCgvkZoT5ecn+cvGUr+w0/Jf5OE2JZ0WFnT
	 Vo8ZMgTXSR2ccIdvETlcqU7w0w6jLPJEdcFmhiZG0nDlCYOQ23Eok8ruUjFcJRTVby
	 3ayEK/NbIbd3QSsnc2LtSnDKYLMFhvZaqGjIWNzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 501/644] mptcp: drop skb if MPTCP skb extension allocation fails
Date: Tue, 26 Aug 2025 13:09:52 +0200
Message-ID: <20250826110958.911108772@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1074,7 +1074,9 @@ static bool add_addr_hmac_valid(struct m
 	return hmac == mp_opt->ahmac;
 }
 
-/* Return false if a subflow has been reset, else return true */
+/* Return false in case of error (or subflow has been reset),
+ * else return true.
+ */
 bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -1170,7 +1172,7 @@ bool mptcp_incoming_options(struct sock
 
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (!mpext)
-		return true;
+		return false;
 
 	memset(mpext, 0, sizeof(*mpext));
 


