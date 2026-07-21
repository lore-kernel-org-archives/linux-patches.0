Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5993B994F;
	Tue, 21 Jul 2026 21:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669797; cv=none; b=mtUMe8AKvVVqKLk9LDEpV0Pvu6JuoRY/ajparCeBoXqNp8YolRH0iYFhL4ogHSPAFuFsyw5idNua3ojProOUkkUhD9x+f5i87gHwjbVOCq/+Gy3Hv3BzpKnDjl60Q6D9FmuJUsuhOxKaRPcyMFCnUC2DTjtl/42/Ipl3/Gx4c44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669797; c=relaxed/simple;
	bh=d4mepunJ9LNPzzZ52BCVi9NtnFgdbCqD9dEcnztx9ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+hnVMsu+bqUSs8jiQ22djNNl4SLoJ0cX1Ne815dWhSPxI0WqN3k46mK2coTtDQES7jpX8xAfIDRUXdRih2uhlb9F9ZzcCs6nCHyn260uBa6xzf9nhLhFB6xDqVQ5VKSvNos9r30M2QZ9nf95HWDFTKEdzTHikygmHWQEgIS/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ8SqJS5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ8SqJS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98F71F000E9;
	Tue, 21 Jul 2026 21:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669796;
	bh=6RjskrkN7ceOh69F1VffODnFWEtvDnzMQvYrKexmESw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZ8SqJS5WUzXWCGaf1FPJAuWrKPw6PA49OaCbZUOQQ1Zw9ljDmr1Fm5BqNgL6iZlW
	 U5CuwU5HBfAC6VFptXs0jztWOmQ4NRtRm/SIF1rXJ9T67E9VnAXk9XCqpijn5JcHpE
	 lE8oyzZfcF55GuYPwRALt9bBgZwE+mSSydeig6RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0689/1067] qede: fix off-by-one in BD ring consumption on build_skb failure
Date: Tue, 21 Jul 2026 17:21:30 +0200
Message-ID: <20260721152440.010467851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit a0a558ca7e75b49e71f8c545c30e8c005e6e4e2f ]

qede_rx_build_skb() and qede_tpa_rx_build_skb() do not check for a
NULL return from qede_build_skb(). When it returns NULL under memory
pressure, the functions still consume a BD from the ring before
returning NULL. The callers then recycle additional BDs, resulting in
one extra BD being consumed (off-by-one). This desynchronizes the BD
ring, which can corrupt DMA page reference counts and lead to SLUB
freelist corruption.

Commit 4e910dbe3650 ("qede: confirm skb is allocated before using")
added a NULL check inside qede_build_skb() to prevent a NULL pointer
dereference, but did not address the missing NULL checks in the
callers, making this off-by-one reachable.

Fix this by adding NULL checks for the return value of
qede_build_skb() in both qede_rx_build_skb() and
qede_tpa_rx_build_skb(), returning NULL immediately before any BD ring
manipulation.

Fixes: 8a8633978b84 ("qede: Add build_skb() support.")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Link: https://patch.msgid.link/20260630164623.3152625-1-syoshida@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 1de8611a27f238..51affa97aab401 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -765,6 +765,9 @@ qede_tpa_rx_build_skb(struct qede_dev *edev,
 	struct sk_buff *skb;
 
 	skb = qede_build_skb(rxq, bd, len, pad);
+	if (unlikely(!skb))
+		return NULL;
+
 	bd->page_offset += rxq->rx_buf_seg_size;
 
 	if (bd->page_offset == PAGE_SIZE) {
@@ -812,6 +815,8 @@ qede_rx_build_skb(struct qede_dev *edev,
 	}
 
 	skb = qede_build_skb(rxq, bd, len, pad);
+	if (unlikely(!skb))
+		return NULL;
 
 	if (unlikely(qede_realloc_rx_buffer(rxq, bd))) {
 		/* Incr page ref count to reuse on allocation failure so
-- 
2.53.0



