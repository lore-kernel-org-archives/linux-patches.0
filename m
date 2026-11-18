Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049380;
	b=dH41n3/xqqr8PPB9l7MBcP2afbiJWmHHEAh9bUOJUk+jhRbrU8e3A4RDi+E6uIqM5qbA
	 JjUcrtlPuKRKjSiRh05mnPnp96ZGovhkxN7BjORPaJPOPuL8wETEQVTS/VwDRT45X/cmV
	 ReMZ/9jKCutcfyCXqomjrEW6lxDl6uMeIB2EdInMJ6CHviUEiZ7eyd+G656TsZTuE7Jkd
	 mdw72Bq8wWfr0siWTDasaXQET1LFHJ/JynGbq6Iz8TtqLm+VdxY8ZEjUZp/PYB0Se+j46
	 igPKE6aGdD1PQ7c6Ugp+eip/iBZMaH/OMRn9mAyjBUo4SF0Pak8vdVKbkNe/R37nXAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDrssRGvVxEihIrkLyPxw6ehj8vSRV5cImLH3FSKAr8=;
	b=Bl6xpOc48hY99MhyWDZE98IuGrhfbjs8xPDJi/YQ27ctztbSkekt3wJdfkCtTWcWeS1e
	 IfW2beMHA4KpDkAjotDXS4PMdmgRBV4fMdIaVIufilToHIP7gMebX6DexXUj3CkhWFAaE
	 q+POtWj5x0NWzycpa2xO98RQraX2hLGPx9++QaY/Ajd042fej88o7/XSm0Kpp5Ozw1lst
	 Fe8zz2pfHFpL1NzrYazU+JZjjh/OTCDcbFxjbmX3lROE1SUjIUYzJSo5TCbuRysn1CQvg
	 bt7GRQYu8ws7ebUJBvE1pW/ppr/4X6/YA/lyVrbkmRKIv8MmEtEaVSdUtv2uaz68YXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKzva3So;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACCC606A325;
	Thu, 19 Nov 2026 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKzva3So
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1676E1F000C4;
	Thu, 19 Nov 2026 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049380;
	bh=sDrssRGvVxEihIrkLyPxw6ehj8vSRV5cImLH3FSKAr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKzva3So2xdO4nHGIcHRLUPY+acNrQvskDZO80uENpjYbZDEaY8UXQEHIUlASBpt+
	 nKME50M/7oo9Edz/mOOiJI/geIZdAbbiSFOoBZt6l/nEk6mWY5ulVPdB4Vp1M8YvQc
	 hzxU6Zcm9cHZipxn8AGIJgtjeLGuw5et/2UuW4MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2332/2857] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:56:06 +0100
Message-ID: <20261118150325.499518173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index af1b2a6a93db7..5f648b3219893 100644
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
 					&page, nilfs_get_block);
-- 
2.53.0



