Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560D37F8C2;
	Fri,  7 Aug 2026 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117072; cv=none; b=K7tK5IqwsMKprRJ/8+EZL6U/uAM+DMKagci510Ui3IvLgvaACFLTrcae4GmmpMDCoRJCPolnss2CvXhNJa8ogI5zn6Xpj0Q8NK/U/8SNpZTUQQBg66WHvKEG11jroDGxwoiL33L1IS7YmVSLDjG2lQRDqIRql9iUYUDaFj5Glto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117072; c=relaxed/simple;
	bh=86DXr+Ns71dE5ZpF2Dy/jG0aYOn0ZISjBpcBCHlG2Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz8hueSKz9ZJptl8fjuovcKjiUFmvBgG9PFX09yNhUhZL/G/92fFG68LjJnzO92UxOs5CKGRx2Y0aN/yJ9DdO0LcaKoQsGb17Fqof5Xzry0k4+mwb3vHoG9+iW4XtntGDn4rUY2BdeWEkCq7L5qgSMUqZD9OMSwhqwf8lsYC6SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJMDKujN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJMDKujN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99AF1F000E9;
	Fri,  7 Aug 2026 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117071;
	bh=VyKr4GpNpxK73PFbJX/ORMt/20/ns/yYNvDa/obsrI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJMDKujNg1zM9k3vaja4nLs/6hE0BU6txn5/7JZtL7eJzkNlLTLYuDZ37XBtfdgP0
	 XEzF9WCFQJn8B+odqWNgwNL92mSE4SVN03DPpWkQnztQRf69qlys7fOd7Lsq/XTSRw
	 k1yeTgpn+vHUy66aKv5RQFdrbaLERrDErCaX4tGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 190/438] iomap: add a separate bio_set for iomap_split_ioend
Date: Fri,  7 Aug 2026 16:36:26 +0200
Message-ID: <20260807143432.082141000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c679ce3be6cb63763d68ab9b5d9d73ddc0a40762 ]

iomap_split_ioend can split bios that already come from
iomap_ioend_bioset and thus deadlock when the bioset is exhausted.

Add a separate bio_set to avoid this deadlock.

Christian Brauner <brauner@kernel.org> says:
Mark iomap_ioend_split_bioset static as it is only used in ioend.c,
fixing the sparse warning reported by the kernel test robot.

Fixes: 5fcbd555d483 ("iomap: split bios to zone append limits in the submission handlers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260629125229.3400726-1-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/ioend.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 2d5611f6cc57d..9fe0aea8e8d9b 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -13,6 +13,7 @@
 
 struct bio_set iomap_ioend_bioset;
 EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
+static struct bio_set iomap_ioend_split_bioset;
 
 struct iomap_ioend *iomap_init_ioend(struct inode *inode,
 		struct bio *bio, loff_t file_offset, u16 ioend_flags)
@@ -485,7 +486,8 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 	sector_offset = ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
 			i_blocksize(ioend->io_inode)) >> SECTOR_SHIFT;
 
-	split = bio_split(bio, sector_offset, GFP_NOFS, &iomap_ioend_bioset);
+	split = bio_split(bio, sector_offset, GFP_NOFS,
+			&iomap_ioend_split_bioset);
 	if (IS_ERR(split))
 		return ERR_CAST(split);
 	split->bi_private = bio->bi_private;
@@ -508,8 +510,23 @@ EXPORT_SYMBOL_GPL(iomap_split_ioend);
 
 static int __init iomap_ioend_init(void)
 {
-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
+	int error;
+
+	error = bioset_init(&iomap_ioend_bioset, nr_mempool_entries,
 			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
+	if (error)
+		return error;
+	error = bioset_init(&iomap_ioend_split_bioset, nr_mempool_entries,
+			   offsetof(struct iomap_ioend, io_bio),
+			   BIOSET_NEED_BVECS);
+	if (error)
+		goto out_exit_ioend_bioset;
+	return 0;
+
+out_exit_ioend_bioset:
+	bioset_exit(&iomap_ioend_bioset);
+	return error;
 }
 fs_initcall(iomap_ioend_init);
-- 
2.53.0



