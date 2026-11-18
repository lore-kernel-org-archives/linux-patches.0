Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056079;
	b=0v/0E2HeKsad0BV0uMdNc2psBOLiPVAs6skPy4PXbNsezZLrMrpucvrzxkaQmq/RQcAz
	 A3qoaRPzcPyNbIMUf/oLdRSZGMBmCsCIEf8dHEAtvgJpjoOaP1ECBsxMWrAKBsRUMXccu
	 G/Nq2lAFQmSDyIFkTElj5VMWmgMtp37ToyJnjfBq0nQBfoBNvy8hIHTMeDTTxKJKo3MC/
	 SMSSC/hJTx2j9iR3GwYBYyfxNj7/k1HaFLhyylYfLxdGTNHygOsHVgkifMzov450KFq/0
	 EesyhuQNKcutvSTL6dKxoax6D/FwGscJEm6zetCubaFIspK1NFLsThBxvqqLJ0W6CHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v7WFiKUF2KMo4PQnZCLChlG5atGwuoLYh8bXf+qLetc=;
	b=uqRlYol1jkAsm0+IbN3QgFO4CDRDCqUt6PHcUS0eJat0OTOnK6JIRrVo5z2w9gdKwLeB
	 xloAgikgsSbrxXrnC87/zoaUNN8SPAQQmp/4MbBYgJF3hcKPaoqn+kL9xoTrjxfswbcjv
	 RxyILwLe0vSk7rVjcOGouc8x16Zsho950bMrovBztrvL4/DJXpDcb5y8ZeV15wvQZE3o4
	 SWKHcIxYUlX214VYh68Yh75Ny7cpbBjHorzPn4kMwCYgwuwsOwIyGIFBdOcFx0o5V5vkG
	 uD6eW8dp63eT04WOj9Myl/s9nyUaoox0Qo4nmSZNf7VQmqQ13dC9Kv5nb3ciHU3lAQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNELDdRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3965606A320;
	Thu, 19 Nov 2026 02:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNELDdRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116A11F000C4;
	Thu, 19 Nov 2026 02:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056079;
	bh=v7WFiKUF2KMo4PQnZCLChlG5atGwuoLYh8bXf+qLetc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNELDdRGKHZUSyNhrdvfJIOJTj8TXvJKHqFL3O/OiZ/wzMdpCVZL0UiW5it9rj1Rx
	 iDTEbJh0ryZD7U9FDxnOgEQJTNzyxRs2jraKUBVdWzGfePKG7swlz5K+va08dR2YjP
	 wPG1+gs2pnQNKQrEcnhe83k8tRswoaT5XqhQadrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1819/2214] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:58:15 +0100
Message-ID: <20261118150124.232331271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jake Labelle <southampton.jake.labelle@gmail.com>

[ Upstream commit ef2ccb1554df254eb4066171ce93e6d5fb1af2e3 ]

During roll-forward recovery, nilfs_recover_dsync_blocks() obtains the
inode designated by fi_ino of a dsync log without checking its type.
If a corrupted image designates a special inode (e.g. a device node)
there, the inode's embedded bmap was never initialized:
__nilfs_read_inode() calls nilfs_bmap_read() only for regular files,
directories and symlinks.  The subsequent nilfs_get_block() then
dereferences the uninitialized bmap->b_ops and jumps through it,
crashing the kernel or worse.

Regular files, directories, and symlinks are the only inode types
with data blocks to recover; reject anything else before touching
its block mapping.

[ryusuke: conformed AI tag to guidelines]

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Assisted-by: Claude:claude-mythos-5
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 0f5161df0709b..304f31dd697b7 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -510,6 +510,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 			goto failed_inode;
 		}
 
+		/*
+		 * Regular files, directories, and symlinks are the only
+		 * inode types with data blocks and an initialized bmap;
+		 * a crafted image can reference some other inode type
+		 * here, whose i_bmap_data was never set up by
+		 * __nilfs_read_inode().
+		 */
+		if (!likely(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+			    S_ISLNK(inode->i_mode))) {
+			nilfs_warn(sb,
+				   "%s: invalid inode type (ino=%lu, mode=0%o)",
+				   __func__, (unsigned long)rb->ino,
+				   inode->i_mode);
+			err = -EINVAL;
+			goto failed_inode;
+		}
+
 		pos = rb->blkoff << inode->i_blkbits;
 		err = block_write_begin(inode->i_mapping, pos, blocksize,
 					0, &page, nilfs_get_block);
-- 
2.53.0



