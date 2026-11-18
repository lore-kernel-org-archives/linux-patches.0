Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058183;
	b=yjXre/ATNm7l0t7WD3gR6Uf/wtNDKyUmpeEjqrfr0ziif//GQGIOOJ8bhXYzT8J36d9P
	 VdkiadyLxTxujjcmrziJYLZ69+tQkX+srajjqIETqW3LVkdigpOJWbVkRm6eoYaMG1XFC
	 LGaUBhrCRYM6c2OYPm2Tba0J+qKeDES97iRWSC8XDm+qxvyUsiT+zkO+VGOFu/mZgDb5O
	 lz6tx5Coa7HX1F+V64E6q0n4ZoA+RQZlGjC2vrDHsu+RE196olfTW37dow7GKLhIcpGKK
	 zoSlaSvRMxUVctZH5YKOXSeZTLHQAOOQGUMSB7QTz0nYXNp5BP+RT0BDoSxHwx/0jIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NjTUxEBjyAypCP5VrkYXWsq3WsvrO1jvsvrKspXfWX0=;
	b=okoZHiTnrIrm7gjiiOgX/uRXxTyO6cpMJfEKdGzeSCy8kZRFyeODLONf/kjFCA3bez45
	 Xxo3JedfVSFK2MXTmr1XAME1/SDaI2YDnSCj+kHis4OqINiwE5EbUEWhzKoBbjTy/6qwi
	 OC856Wh2Juf9yCAcd0evNCwCSuThelkcxa+iUFD4+bBIf+9XuebldzPo7uoKdGWICuouG
	 pWDuEqJ24TcYIumYRVptLgxoRHl7SWv7h+/CEaq2e5w/bmPUNgjFlLeiEf/IjxxK8lMOB
	 tOTDDibdAPK/ogwb0Wb36oar8R9ZyobRT5+qpop450eDdy63R+N4kd1hRBEBgFgnYVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGAChOgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAA1606A31C;
	Thu, 19 Nov 2026 03:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGAChOgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63D81F000C4;
	Thu, 19 Nov 2026 03:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058183;
	bh=NjTUxEBjyAypCP5VrkYXWsq3WsvrO1jvsvrKspXfWX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGAChOggrtwUrgTOUAq4q2plS1SbgMD7/u8XV10BVtrJBQb/zU/vJD2JX+fC/YpIy
	 /TbYMdBw42hS/EZiPgVvNrmzl4LPK3VDmsvFoZtfk1lRY5iazBmanUS0xAJRU5rR1N
	 Ikjy9CCDUASn4K11oJdP2vGwvuQN6lGvTtttEQu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0393/1848] affs: validate blocks before freeing them
Date: Wed, 18 Nov 2026 15:40:31 +0100
Message-ID: <20261118145930.184091065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



