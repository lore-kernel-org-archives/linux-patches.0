Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035920;
	b=F7J0cgsTg2bSmgCW73TpDV/qQEZd83NvHqVc0Q/hiXnN/Ruy7ss4vxI7IVXT4w1sQgCh
	 BDEkx1OYYqf750Ufcj4sJT6NVROz5RLJ1U6H6WyIvqaYs9QdqbohAzsR0//pf5+DNtLGp
	 wbsQPnMJo2NvO53BmAnLsym32m6OCdmZ5az4E9KXaOu6q+xRF3iU5AW0lbLvjynB6WtGP
	 hiMWpVzr9gqCwnXhmHTBkaQmyBZvst3WIqxT4S3VhCKRkwKO4M/E5d6N2QZBw7DOLUCTJ
	 +vl2Ccko/Y62jfmavw4J/VrfsOve/d5cPbRMCT5p8zO8TqXXBytz6IZqPEiROhrHQ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w39ltdlG6cKUYtD5G2qesNmrZoZEBzqm1/KAqDb6R6w=;
	b=AN6LjzOOv+/32xQpK2h+0+BpGkvRR7WXbzu/rEkxX2sjxepmwK/3KIAS4s1h9YWe212i
	 QWHkbaukXX06Pp2y/OO1inLh0FtfTSrhQk+L25qhHz5iv5/BYMzsOgkXc/jKA5DjzxEq/
	 m2JkdW2XFSlVRicgwIHZ6GLbBd5vAc9cC2hZpqL6Spk6aUsfQad8N2vnYa2qh6oIo8u4d
	 1GfGrDoJBI3CqdIfOIqt+Amf3msUuEFx6hbdfc5HRDs/pIlmiG5/FTj4wpp7X83EDaFuJ
	 EKuSoNHxt6h1DoC0vBT46jDWg9bbQlfnB+r1OC5sg4fMvoR+ognEFuUqun2+fNTZafQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xmui1arM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351F3606A338;
	Wed, 18 Nov 2026 21:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xmui1arM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F661F000C4;
	Wed, 18 Nov 2026 21:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035920;
	bh=w39ltdlG6cKUYtD5G2qesNmrZoZEBzqm1/KAqDb6R6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xmui1arM/O5U1h83Vo/7ekfgCgsVYgZeXKnjiCiP/gvY4SXUhFJjeXEstTv2W0bQH
	 SQLeS27z60QsjWI+ZZUVo//osej3iZI7R6PhbB8A3ercL7eYzYQHf0PvV8GgYgA9Rh
	 09DnW8jXBczyxu72LJpLDct0KDQRZE/Os3DxtQb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0872/3318] affs: validate blocks before freeing them
Date: Wed, 18 Nov 2026 15:24:54 +0100
Message-ID: <20261118150345.460896049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 78ea2058abf3ee053c0bd9c1b9a77304cb4ae58b ]

affs_free_block() accepts block numbers from on-disk file block tables
when truncating or unlinking files. The function currently rejects only
block numbers greater than s_partition_size before subtracting
s_reserved and using the result to index the in-memory bitmap descriptor
array.

That check still accepts reserved blocks and the one-past-end block at
s_partition_size. A crafted image can therefore make the subtraction
underflow or make the computed bitmap index equal to s_bmap_count,
leading to an out-of-bounds access on s_bitmap before the bitmap block is
read and updated.

Use the existing AFFS block validity helper so freeing uses the same
range as block reads and writes: s_reserved <= block < s_partition_size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 5ba9ef2742f6e..f400b28eea28d 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -46,7 +46,7 @@ affs_free_block(struct super_block *sb, u32 block)
 
 	pr_debug("%s(%u)\n", __func__, block);
 
-	if (block > sbi->s_partition_size)
+	if (!affs_validblock(sb, block))
 		goto err_range;
 
 	blk     = block - sbi->s_reserved;
-- 
2.53.0



