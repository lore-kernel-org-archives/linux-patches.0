Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B058341837A;
	Fri,  7 Aug 2026 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115095; cv=none; b=Uly/VX3OX1a4SjhoL8sv23y90SvUoDfdfWvQQrOFm9eqBqGxKNIaB4aWWmWCbz3MqbPmv63WZgIlBG/RXguljhWTAKFkQQNvpf1LZFCwqRsqDXQdildKpjXq2v/DxdlUJoEyfc6mcpkQN3WAnpb+T4v4rrK9m36WstD5VMpyJ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115095; c=relaxed/simple;
	bh=YHGjZVhxrLujJEFnKRs9rbozMaqbHfNKDNBD/NmKCWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjC6FIKmhsZBAJMm3AFmy9qJP83HLLH6+wej7f3NE3aqtCUGhicScQm3C3u5Gn5MAl+iUc55pPjLxrMVpxYo16yRHxtkwKNuLwzHDwMcvz12kY2D4cEgJ2R0zALESXPklsE55xxIgyuQh0tmGO8q8AlUQXfVFVYDb5x/bpGHztc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWMYqLoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWMYqLoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116261F00A3D;
	Fri,  7 Aug 2026 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115090;
	bh=1wZ8c53WHB1fQhRP3lFJGwd1DdIZx1uV6Tw9C7F6Hlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWMYqLoq1fDblWnR+KsntpCs2dt+A/VNYhjjzmMQqv3AOtj4CGrVoQL1eiqG7p9WS
	 +OylDANepKySbeMNa7xs7FMJZZdRBh7bYQ+KZlJDHuN9bJPbLbqiBfzApMm/lgOGez
	 O770sOvoDIKL3r6cxCzbFt99H7JO6cnI61Cgxpsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/396] iomap: add a separate bio_set for iomap_split_ioend
Date: Fri,  7 Aug 2026 16:35:15 +0200
Message-ID: <20260807143427.654145620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6c75fbf4d5af4..2a86b05c88efc 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -11,6 +11,7 @@
 
 struct bio_set iomap_ioend_bioset;
 EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
+static struct bio_set iomap_ioend_split_bioset;
 
 struct iomap_ioend *iomap_init_ioend(struct inode *inode,
 		struct bio *bio, loff_t file_offset, u16 ioend_flags)
@@ -409,7 +410,8 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 	sector_offset = ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
 			i_blocksize(ioend->io_inode)) >> SECTOR_SHIFT;
 
-	split = bio_split(bio, sector_offset, GFP_NOFS, &iomap_ioend_bioset);
+	split = bio_split(bio, sector_offset, GFP_NOFS,
+			&iomap_ioend_split_bioset);
 	if (IS_ERR(split))
 		return ERR_CAST(split);
 	split->bi_private = bio->bi_private;
@@ -432,8 +434,23 @@ EXPORT_SYMBOL_GPL(iomap_split_ioend);
 
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



