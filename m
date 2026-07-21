Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2363D1CCA;
	Tue, 21 Jul 2026 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653751; cv=none; b=AZ9PqtlZIAYgcWJNzNjVRhz2l7znGZwRqI3XQhiAZ4TuyiSak/gZPphJ/KNriqm6aaW3LwYQussEKtqaHXvmaxRNV9mpVTWiJWP8rllrfZ1Syci9pBc6b4XH2ptsIXeJYBsr6Chlr5hXISKgQht1p10Aem+9dyn/OWU141gV2Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653751; c=relaxed/simple;
	bh=rFcZOr8gZBNP4g5SStZeIbvCNm4aJr4XBMc2Jg0xiPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbgwuRO+5VHHcxNz3tTjW+yhVLZTOFlrZDbzASpRe0zweoaT3+CpDh0soLZQFoaqRc3F+gteEkIj1tzVkE/CFoLaPyokfjIjqix+9XwQscg9f2FFEgdA9ayLVuqkLJbnhvqCvbDFfwAURVbOhN5DilDpWicnbKTmCWmV1gv1+mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaTubVvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaTubVvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBD01F000E9;
	Tue, 21 Jul 2026 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653750;
	bh=fj2NnKhyCMOIhvzgFpKZrX9pPUE0bvfhsg3XpYAtFrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaTubVvNxdSOJiAB51quVRUA4afDos5lAa9i/k6emz12KM5MlmOzj1Hm5NRmLNo7L
	 oNOyNVZ1bzMqliTE84QOE/ewmDbIYuihvO006Mo2lhnjArV9tCdhYvot4I1Ye5uOGM
	 LVkKulm8rnWaL1Q0raOQi2j3gn24VhIVlEEhWLqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1446/2077] qede: fix off-by-one in BD ring consumption on build_skb failure
Date: Tue, 21 Jul 2026 17:18:39 +0200
Message-ID: <20260721152626.908865259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 33e18bb6977401..c11e0d8f98aa5c 100644
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



