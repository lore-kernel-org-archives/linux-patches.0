Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FBB18A6A5;
	Mon, 27 Oct 2025 19:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593478; cv=none; b=WMcFfbNghkD7z0ZO/VNW7tiQN+m4dCND7ml/2MrwXIYEeAzI0BFJ9j5WQ4Mol+qxLab7xK7nAkRM70D9MOp1W7MtBdjfy2xySbdrSPQCve4NMVwXPvKfcHzdvZ1t3npvwO90H92ImfGKX8j9bV9hkBM5Kl99/fbKJpRayaOArnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593478; c=relaxed/simple;
	bh=jUF8LeVFwI9iMfzdyZyqZThNjt1WPuLyu2WzNFQrt7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rm1PF2csOnqXASh6GOzamAmRfPv9GG9gqzqcJCWXIgPzGxNRoivuoNFRbqgxxgfyJQHK5pbvqWGbPh8wcLHkEWGuVk1Mm4wmHIsmI0tNh1dgTDLlsG3/o7DFRLFOHgAaP2XmMc8jdKdY81+oPPOKuJlfpG5Obn4nwv2PCNK6Fd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpQ652No; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpQ652No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7390EC4CEF1;
	Mon, 27 Oct 2025 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593477;
	bh=jUF8LeVFwI9iMfzdyZyqZThNjt1WPuLyu2WzNFQrt7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpQ652NoPf5BXj++3Flj/fwJCQVMDrTt0kZE4Myzanio7E0/ajA638qxHIET60ru5
	 HL9jJEu9sCifiibbGOOsZQa0+7oOyrSbbVVIEbzf/KtTGCMjRi4xFb5A4qqtx+xpVR
	 KSuPkzWSD5W1nFlCfbYdAazkVVp6l8pCufmuKuXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 145/184] block: require LBA dma_alignment when using PI
Date: Mon, 27 Oct 2025 19:37:07 +0100
Message-ID: <20251027183518.844914462@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4c8cf6bd28d6fea23819f082ddc8063fd6fa963a ]

The block layer PI generation / verification code expects the bio_vecs
to have at least LBA size (or more correctly integrity internal)
granularity.  With the direct I/O alignment relaxation in 2022, user
space can now feed bios with less alignment than that, leading to
scribbling outside the PI buffers.  Apparently this wasn't noticed so far
because none of the tests generate such buffers, but since 851c4c96db00
("xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr"), xfstests
generic/013 by default generates such I/O now that the relaxed alignment
is advertised by the XFS_IOC_DIOINFO ioctl.

Fix this by increasing the required alignment when using PI, although
handling arbitrary alignment in the long run would be even nicer.

Fixes: bf8d08532bc1 ("iomap: add support for dma aligned direct-io")
Fixes: b1a000d3b8ec ("block: relax direct io memory alignment")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8fa52914e16b0..c3e131f4f9083 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -184,6 +184,16 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 	if (!bi->interval_exp)
 		bi->interval_exp = ilog2(lim->logical_block_size);
 
+	/*
+	 * The PI generation / validation helpers do not expect intervals to
+	 * straddle multiple bio_vecs.  Enforce alignment so that those are
+	 * never generated, and that each buffer is aligned as expected.
+	 */
+	if (bi->csum_type) {
+		lim->dma_alignment = max(lim->dma_alignment,
+					(1U << bi->interval_exp) - 1);
+	}
+
 	return 0;
 }
 
-- 
2.51.0



