Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1BFBF0;
	Tue, 26 Aug 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213644; cv=none; b=NMcRzUGcv5VaettZ9OQXoTOwiOorEcgG9Ih6rStltJoIGgFQyYxnwUKBx9FjdpzCEBicihkZukflgJ9CvXvSQRVUefF8rbVQMLtdJDL9jwg8dxfd7yOz1RFccIx2NKFwUgdMzjlNDeK8hfnki/iVUgbgnFPjHcJbLAsZOTrkm1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213644; c=relaxed/simple;
	bh=FlCJYPn/6/JvlK7+6LYnqV+BPpUEmpt1RonR6GOD1II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q427T+romNnMl9QviYJac/NtPjsuG21sssKP0tm/zddioBIrOtvuxe6ucCplDwhLHAEHwZUXfU3/Buem2aJWNJ8aAnJuHWWZBZTuiKXHgclYEhapnUTZI1fgXVJRtnQa0paLHbOk5xF0FJwZIRW2mpP1Be/kw0EfkXZOAOrGAA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUH2QJBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUH2QJBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C180BC4CEF4;
	Tue, 26 Aug 2025 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213644;
	bh=FlCJYPn/6/JvlK7+6LYnqV+BPpUEmpt1RonR6GOD1II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUH2QJBrtFAgkBXPnwy28W26YM9wjTZ2zm+K7yvOY8CbA4qz/eWv4MCrjWpvjU/Au
	 e38885SSEClkUeCX+aUMxEgsAulYinqwz3l/3R7nBjdjvUsOuR1FU/LidrF/x+p8X+
	 fuFKk/V/WrMDmLgS/REV7IGLOZ4lyeE5qIyf52u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 426/587] mptcp: drop skb if MPTCP skb extension allocation fails
Date: Tue, 26 Aug 2025 13:09:35 +0200
Message-ID: <20250826111003.777923602@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


