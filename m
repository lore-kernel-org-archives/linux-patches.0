Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061988;
	b=TJUEZ1stTugfanghJD2UDcHmvb/4Po8UCU6edyqFUS+be80gPfdYiIt6Bn16rn0PsQd0
	 t0A2MlkVJczL6CqIKDJPWfxDJAeynZJwLLaA0gCYyNlPN/zlb+ytMX9QzBpA3T2cBfX/c
	 591HUYwWLr3zB0RZwRqQFPTYvR9CemEZP7U+BuiY09tSclKNtlRMTg36vbBiv8se/UjHd
	 LwnCkBC/gTxPuMjURarOpuNW+bExEY9zUVXBkpxtCrgGpUFjvghRCvltDF0O6PBoCBXYo
	 DNo/DSqAnKSS5BtDf107xa6YAiaZ5JcyH1gkqP9ARU3CMMSBNQdxCSMM+iPMBkPADHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGmmdGw0fcK1G1FxqIx5bmQzwBJzqsGQJw/6+CRxktM=;
	b=PC4E7yRgspbhBUnkdF8RfqQLZ4LMIPp8xLha9I5C1uPaTKcwUiyi2kX8mu61KDpqBKIb
	 8QbBs7JPv9pVnTyUWxM1+vJkUYxHX7KwW9okRBScYPEKOoAIZqvQb6kHag0cdbhoJLYbj
	 ov7H+pttRSTFHOj5pxh0nlDh6msmhROubVnQpUlE3PqUMA6jpYOHcT8z4kwTXEhDj53nB
	 zswoNCXbfQiIuqNZ1gJKKfm5okMNitIRsHkmt+aBhOK3YgoCwLB0spimb4UrxRnEjOalw
	 1jXyRzicSrjZAIVwpnvIVFM3zcRK/XRkU+a5qYsVx3cxS+mTl5eSjmuFL9sGTXR9c+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aSUS/7l8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7720606A332;
	Sat,  7 Nov 2026 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSUS/7l8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936AB1F0089F;
	Sat,  7 Nov 2026 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061987;
	bh=CGmmdGw0fcK1G1FxqIx5bmQzwBJzqsGQJw/6+CRxktM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSUS/7l8wuh+S1IPyuwsd9Jb7MGmCnl9Ga5v8BxZhvx6oqDbYi4QGP8b7e0PgT44l
	 +9rxdZLtBLjClvauRQrGTukDL4kMwOMii49x7ngKidRPOWUqv5Vi3GsKrgO4MoneXq
	 3rTUycRtpMKgpsCB2KIloPVBwwWeWuozqhC+TNSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0979/1536] affs: validate blocks before freeing them
Date: Sat,  7 Nov 2026 08:49:55 -0500
Message-ID: <20261107135025.148389500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



