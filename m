Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062908;
	b=i8NtVGapMY/6Gw7FVCqcsvMXKPaihrHOrCNVKWfiqIHBFlLhLypZ7RxuHbcUHeXayzV9
	 gdu9LmNWeTVfx1VBjJtWyNYGlIl/LZqi4B/HqhfHTk3T1PMJMzeHaoLqhTlsHv5ITEj3c
	 6c53Ifx3i1a2+Hce25egIRSuBsz7fdd7ieY3WMJY5o0OFUeMP1eG/ef53BfEXOf6aaIV1
	 y7H4GSJygIMByOUwCaVnGp4Xv/fDOvv34Acf3yoKJGnT59ZkrE6s2h8A4xe8+HCGc4Cf0
	 HekEKa+PI9cSVvcayWxNfCwGUBEu7RJwGiAOxAwVcb6v29rQ2HBXeJ9KaV3G+SuO+lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2XbZnZ15y72FXFKQ9zIbTL/Z2qIOGveIpGg9XGbc+A=;
	b=4xpYXNXH0XujjICV+znc37C/AUSOhoB2osQgqDpl3d81+lsWFXB2ohss4qYgr1VbuXUh
	 aUFwc44rLwAoA3ADIJ+b3pkpUFNWEDzyFNfaw3XjNMHVwlrRU13/R3Tildj6uuLwP5hfN
	 HVwdGnadABGgGROmfZsWaDOWN/pU8UA4MhirbDJzjJYGihxncVDnEcFSuEcaiEioi+lKS
	 EAlSOEjM6Er6OnxxnMj69V7MuiSAA+ACwDokaBze+fcxZsfl2lZ081vFfa5pQKGjrF++s
	 vi0ls0RoUVcFzBFZp4jhVo/TR3QrSH9Mb/61exk9wTttwl2OnXopVGKNMwW87Cenp/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gc9VQLc4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDA8606A326;
	Sat,  7 Nov 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gc9VQLc4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA231F008A1;
	Sat,  7 Nov 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062907;
	bh=M2XbZnZ15y72FXFKQ9zIbTL/Z2qIOGveIpGg9XGbc+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gc9VQLc4RlYdcoYM/RsGWkHiLA/sEUGy2fXeDmLUUKtPj/Gzjud+O6XjCqcGtYZdD
	 VlfNIPmC/3T8nNUWcj9a40qNreW/oDpsZeq6XU9rbH+8emL10lw1NsAm4OwdLT7Xyo
	 B3YGiJkWz98eWoMqmuucdBQw0vd3rTxYC2Jnt2tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/869] affs: validate blocks before freeing them
Date: Sat,  7 Nov 2026 08:46:54 -0500
Message-ID: <20261107134856.927334547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



