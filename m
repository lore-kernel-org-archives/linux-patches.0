Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215068;
	b=FdqQ2uEJs38PE5DpcAzNwvJKnocRem+gdNn/Lkoz7jHJT3oRtX2z4B2452w6HS2KvNCG
	 fCbMnwxbxLSg/cRcCaeze8x3yirRaGQIRt4adcVtIBSRpg/KvpU+RUV6WfxzX8906TJbY
	 3bAKT2v8gYStkB37xnQsJZhMQJAeb+n+ZSlxb2t3D5juGzGmVjJ7YUnnZHLb00dYtnmpM
	 KoZGUaqVarkrNtosT9abxZLZmxPYH7K2vl3ih7fVZ1s/uVgVjZxwfet0uer90RpTJIsYr
	 dmhxWC5uLBbySSbaHwhoGkqUaJFOoZ6jLeU9GQTM9CIu91uPgoxrRs5S0Szz/UnfDpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQB4fG0HTLp33GC5wIyqSKexBpXLshabIszxpg0tFxw=;
	b=rASJs0sk4uON6H7Z2XkwmZiJi3/ESCDc7hhgjeo8stHyLcGjXuof3Y31JzrQrM2QTJ6r
	 wy34rBn3/VqiCpNwlk2zsoQOwdMSF31B8jaKXueotzSAkkzStG7PMIpMWghggqBAIfC6U
	 WDVkNlJRbrdkQjUsx1Yylza4/X9QdpXdDKXsGndkf5EDqAoWyoCJzJdxXYPp04kFbrTOs
	 uqc5008PqnVobnDhyNG4kMiuTkuyAeI/nHY4VqXCbH2yiloqbLdfZk7+EIxdGnqNDR3RD
	 wTzns0jDM4yboAkzvsY6/W++1VangTD9IPo3vqCiXpoomUYv+BHjkNNLUnwuaoZiQ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCG0tYsX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B9606A31A;
	Wed, 28 Oct 2026 19:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCG0tYsX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D891F01825;
	Wed, 28 Oct 2026 19:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215068;
	bh=dQB4fG0HTLp33GC5wIyqSKexBpXLshabIszxpg0tFxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCG0tYsXVhaHOD2w/CiclCrhIUALp63nZhy8l4x6qteSbeEHeOR/4lNTc1FgA9j+7
	 D46FanCyRDpiptre57gFHBz9Q5s9397U9iElMkMhJAEr8Xt9AdyCns4zdtgMZJ3seb
	 3stiT6hpfn8ipAgDZf8Qx2EybG0ycIkA65d+WNos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1079/1887] f2fs: fix data loss caused by incorrect use of nat_entry flag
Date: Wed, 28 Oct 2026 17:52:55 +0100
Message-ID: <20261028170523.958831707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 238e14eb7226f883b72caccd2d37bf5707df066b ]

Data loss can occur when fsync is performed on a newly created file
(before any checkpoint has been written) concurrently with a checkpoint
operation. The scenario is as follows:

create & write & fsync 'file A'                 write checkpoint
- f2fs_do_sync_file // inline inode
 - f2fs_write_inode // inode folio is dirty
                                                - f2fs_write_checkpoint
                                                 - f2fs_flush_merged_writes
                                                 - f2fs_sync_node_pages
                                                 - f2fs_flush_nat_entries
 - f2fs_fsync_node_pages // no dirty node
 - f2fs_need_inode_block_update // return false
 SPO and lost 'file A'

f2fs_flush_nat_entries() sets the IS_CHECKPOINTED and HAS_LAST_FSYNC
flags for the nat_entry, but this does not mean that the checkpoint has
actually completed successfully. However, f2fs_need_inode_block_update()
checks these flags and incorrectly assumes that the checkpoint has
finished.

The root cause is that the semantics of IS_CHECKPOINTED and
HAS_LAST_FSYNC are only guaranteed after the checkpoint write fully
completes.

This patch modifies f2fs_need_inode_block_update() to acquire the
sbi->node_write lock before reading the nat_entry flags, ensuring that
once IS_CHECKPOINTED and HAS_LAST_FSYNC are observed to be set, the
checkpoint operation has already completed.

Fixes: e05df3b115e7 ("f2fs: add node operations")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e69791dd74354..d384c56c72b3e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -417,6 +417,7 @@ bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 	struct nat_entry *e;
 	bool need_update = true;
 
+	f2fs_down_read(&sbi->node_write);
 	f2fs_down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ino);
 	if (e && get_nat_flag(e, HAS_LAST_FSYNC) &&
@@ -424,6 +425,7 @@ bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 			 get_nat_flag(e, HAS_FSYNCED_INODE)))
 		need_update = false;
 	f2fs_up_read(&nm_i->nat_tree_lock);
+	f2fs_up_read(&sbi->node_write);
 	return need_update;
 }
 
-- 
2.53.0



