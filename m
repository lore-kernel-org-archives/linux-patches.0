Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021477;
	b=B51fDE5o6HaNyHIZ6CDaq/O7bNnGPaKEXzRdm73w/iwnC/alBnj9RaD5/VLNGiUokpa4
	 neQAOuCa+5qW2WLRuKtwYzdyPdJtjth77LAC0P0h8oTi/IAKHxBKygt/3reCeYEZrTea0
	 ksTeIJgaHTG8UZ7HHiSyfuzKcHUuH7p4QuQFcDeQ8cxlbgyfFo0W5lykj/zRbfZqImkAn
	 dDrcurIRnI09i08DkSGkziHjCjy1k6r1Q/q7G/3Q1CF7earDj7mNkCMhhdJGi292y92qH
	 BcS65ONZ+BrJ6yl8XVFzRo8yT8xJIt6h4hLdrEys7bd9lvF1ODxwKMuWVB6oOR00DNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H8vKXOQmPQfJF9xxJCzy/cixnqimpotYiIN3oGCRWmY=;
	b=D4vK3GGtwuYJ1xyo6ekn5+5cInWLUb7u1l3H+v2oROr/opUQTEyjO16m80587m9+lXeM
	 EHpe2ME1djRorraINo+d0eC53lI0eyHjwwESByA++qCX7YaWuBboQsHYe9N7IvMD90C8i
	 T74SF7F/u7/vlFvmWIx0pKqyZ/J0r5SOIgJc9+I3fJf4WXIOthSmKRCQ7F+P/pxFjXHS7
	 Rr4i+69VCKsk5zutlqYwNozgl2khCNAs+fzz9iO4bXfpLDydBCiYHjejuV17llnNPn43G
	 edE2YLG4ZuJLQy614Ryo4Gz+gGUQYDuj0mlUbSZ+becdS4ejZMuOuGNpd3mT63x3BmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yjn8h5Sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA93F606A335;
	Wed, 18 Nov 2026 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yjn8h5Sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A611F000C4;
	Wed, 18 Nov 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021477;
	bh=H8vKXOQmPQfJF9xxJCzy/cixnqimpotYiIN3oGCRWmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yjn8h5SmUFyZsZ9QVHPhw77el1RmVilFQMCR2/12w/YqKOR7oqchWkRRPHcF3rxBW
	 sL4Tko4q28dPFwIYhE9LaEcqPJSSfmThA7zNMlqJAJr8bwHh8yr8BZ8GLG9MNY2ZJi
	 FYQzQTnCHpR+8Csqgx8UI3JqrAmZmOC0h+yBYXSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Nicolas Falesy <nicolas@nicolasfalesy.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2280/2651] exfat: clean stale bdev buffers of newly allocated clusters
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150407.396845027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Falesy <nicolas@nicolasfalesy.com>

[ Upstream commit 0550ac7f5f577e34e5fcf2bd7a51965f5c1b0194 ]

Directory entries are read and written through buffer_heads of the
block device. Removing the entries of a directory dirties such a
buffer. If the directory is then removed and its cluster is reused for
file data before writeback, the stale buffer stays dirty in the block
device mapping, and the next flush of the block device (fsync, syncfs
or umount) writes it over the new file data. The file silently reads
back with one sector replaced by the deleted directory entries.

This was harmless while file data went through exfat_get_block(), as
__block_write_begin_int() and do_direct_IO() call clean_bdev_aliases()
for newly allocated blocks. Since data I/O moved to iomap, nothing
drops these buffers any more.

Clean the aliases in exfat_alloc_cluster(), once per contiguous run of
allocated clusters. Doing it at allocation time covers every path that
allocates clusters: buffered and direct writes, and also fallocate()
and an extending truncate(), which allocate clusters before the data is
written, so the later iomap mapping does not see them as new.

Tested on the exfat dev branch in a KVM guest with a reproducer that
removes the entries of a directory, removes the directory and writes a
file over its freed cluster: buffered with and without fsync, O_DIRECT,
after fallocate(), after an extending ftruncate(), and with the freed
cluster in the middle of a fragmented allocation. Without this patch
every run corrupted the file (55/55); with it, none did (0/55). A churn
test that creates, removes, preallocates and truncates directories and
files, then runs fsck.exfat, is clean with and without the patch.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Link: https://lore.kernel.org/all/010001a1222f66ba-0c745f29-d4fe-4862-93ff-1db2055b05fc-000000@email.amazonses.com/
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Assisted-by: Claude-Opus-5.5
Signed-off-by: Nicolas Falesy <nicolas@nicolasfalesy.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 3c8bdc131f6f3..9f4607fced7ff 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -418,12 +418,28 @@ int exfat_zeroed_cluster(struct inode *dir, unsigned int clu)
 	return 0;
 }
 
+/*
+ * Newly allocated clusters may still have dirty buffer_heads in the block
+ * device mapping, e.g. the dentries of a directory that was just removed.
+ * File data does not go through those buffers, so drop them; otherwise a
+ * later flush of the block device writes them over the new data.
+ */
+static void exfat_clean_bdev_aliases(struct super_block *sb,
+				     unsigned int clu, unsigned int count)
+{
+	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+
+	clean_bdev_aliases(sb->s_bdev, exfat_cluster_to_sector(sbi, clu),
+			   (sector_t)count << sbi->sect_per_clus_bits);
+}
+
 int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 		struct exfat_chain *p_chain, bool sync_bmap, bool contig)
 {
 	int ret = -ENOSPC;
 	unsigned int total_cnt;
 	unsigned int hint_clu, new_clu, last_clu = EXFAT_EOF_CLUSTER;
+	unsigned int run_clu = EXFAT_EOF_CLUSTER, run_len = 0;
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
@@ -514,10 +530,21 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 		p_chain->size++;
 		sbi->used_clusters++;
 
+		/* clean stale buffers once per contiguous run of clusters */
+		if (run_len && new_clu == run_clu + run_len) {
+			run_len++;
+		} else {
+			if (run_len)
+				exfat_clean_bdev_aliases(sb, run_clu, run_len);
+			run_clu = new_clu;
+			run_len = 1;
+		}
+
 		last_clu = new_clu;
 
 		if (p_chain->size == num_alloc) {
 done:
+			exfat_clean_bdev_aliases(sb, run_clu, run_len);
 			sbi->clu_srch_ptr = hint_clu;
 			ret = 0;
 			goto unlock;
-- 
2.53.0



