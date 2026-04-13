Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2303626CE32;
	Mon, 13 Apr 2026 16:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098205; cv=none; b=p0sklGVgrKSg/yCwwGKITqsybCbjuvZ+aASJZcnCpg+SFolncpiMNFf/2JOkS1jdQgr8PtvALJV2PLagpzLAIwR3oZfZcngwv4I1AfyK5OTpDcFyC7kZzsuhA5pi9LDszoncRf5kex2iLG/YvxtXNE8ITAPtRZYEt4aCHJDNrCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098205; c=relaxed/simple;
	bh=5+KEYrj0zA5CKmcJGDDdRo/GsInHDphUqiWvyAP71NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYQxRxuCdgaQu4fq8A20/C/GwxuYMoZZlOUzRBSS4Hi+oS2h7Y2RAaJsKzMCMsa07zcALsqIie25k3XYVVqeKkVnArtdkNYDd4UaKNIhXaol0dLtrefVDvJtHTkjfjI/AQg2SOeySXpFgl2ctpUj7VwYV9aJsMfnfjJBptlzh1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbDni+TZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbDni+TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4A5C2BCAF;
	Mon, 13 Apr 2026 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098205;
	bh=5+KEYrj0zA5CKmcJGDDdRo/GsInHDphUqiWvyAP71NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbDni+TZey8B0Ynlghd4zzkTmpG9KjnENIOAdUI2YDviblzqdpK97oRmfE7e0hqH9
	 qcncqM1VgeLy90LijQs8B6mSCjz0wum4fEJeKqsjKtx/+tM3Yz+yT/zw4NztAbB2y4
	 J2r5cRJDTHlcnXXhHv/7kPKGM2Sxkl28FS+/RAVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/570] net/x25: Fix overflow when accumulating packets
Date: Mon, 13 Apr 2026 17:59:24 +0200
Message-ID: <20260413155846.694122551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit a1822cb524e89b4cd2cf0b82e484a2335496a6d9 ]

Add a check to ensure that `x25_sock.fraglen` does not overflow.

The `fraglen` also needs to be resetted when purging `fragment_queue` in
`x25_clear_queues()`.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20260331-x25_fraglen-v4-2-3e69f18464b4@dev.tdt.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/x25_in.c   | 4 ++++
 net/x25/x25_subr.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index 77ad186507f64..956e056803079 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -34,6 +34,10 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 	struct sk_buff *skbo, *skbn = skb;
 	struct x25_sock *x25 = x25_sk(sk);
 
+	/* make sure we don't overflow */
+	if (x25->fraglen + skb->len > USHRT_MAX)
+		return 1;
+
 	if (more) {
 		x25->fraglen += skb->len;
 		skb_queue_tail(&x25->fragment_queue, skb);
diff --git a/net/x25/x25_subr.c b/net/x25/x25_subr.c
index 0285aaa1e93c1..159708d9ad20c 100644
--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -40,6 +40,7 @@ void x25_clear_queues(struct sock *sk)
 	skb_queue_purge(&x25->interrupt_in_queue);
 	skb_queue_purge(&x25->interrupt_out_queue);
 	skb_queue_purge(&x25->fragment_queue);
+	x25->fraglen = 0;
 }
 
 
-- 
2.53.0



