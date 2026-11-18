Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021166;
	b=JfVIALYaKQDlCeKrkm9AGnEtaZB3egoFLRBXAJOsDWRgU3qF1pGDHT00pJWYM+DtaTkj
	 2HxhnIoPFjT1jzZgG+wO9fAWrPVwEDews5AfVBn7ZKNueRE7gYN6ELCriFzMwzZCFRYk2
	 cTMNx0MBV2JFQDZENGsNPhT5l9R+MhmrzQsT/FmQgOV1ashO/2fyarXoYuKau1EPwCF3f
	 dKi93+fkk0pvApdk7NTtZgUU2oui4sdLWLbMAN1Q8k6ljxLXLmesve393Tzjt3mwPcMgZ
	 w2uOXo4WFaDCs6rDKbD3nWsfIwFcqfSBsF4NR83ILnzv4zmdbGTDU+FEPbcNK/JahKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qiVsI1JklzFbb9crDPEEA6Ns12HfEBxBuxOQ6R31dU=;
	b=nk1WLWcikUzsCM0q3kgo/qOcWzZEU/KGqqb7USWaOJn/vM5PlY/18tDYjicMHZ8yTVJZ
	 gjcyphDXFx9XGKoyLbO/JGRJ5HJGGQwo2Ty3SbbMeoszBEvg532egqj12ZqePXX/TH1CS
	 WXRurT0jzBwUV3poQTcoJAhhZleAjDcVw0DhpmXZSTIVYbB3/FSmLnkGuPjIKtDj/lCw9
	 h0m95/ynIXPXU9216TZ2+EUx+efrAUJi1U8dg4VWKSN+mKRZ2GVfdk+0lTASSksIAOvHK
	 zpKEgcg/82ov07u7pbyflQa3qvxOeUQ95XOm6GS3xNvNzwKDFnKQduf2HcLh1Me7lrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rhKGwaC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28199606A337;
	Wed, 18 Nov 2026 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rhKGwaC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1841F000C5;
	Wed, 18 Nov 2026 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021165;
	bh=/qiVsI1JklzFbb9crDPEEA6Ns12HfEBxBuxOQ6R31dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rhKGwaC9nXWPxrZdedMJ/qIe4atbCVaNawW0UBQKLJ5Zfavq3I2EUdtpcJBBenP/x
	 xtlCw8cD3NK1ADKDI3FNra9WzMB3v2jtkmG43io/LQv+7hPe5MplYK904cYzSB5PWa
	 PvGithesnmaAVZ1HMt/6+lIZ7u9uWrdIoh9yWr7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2210/2651] ntfs: wait for the bitmap scan before MFT bitmap extension
Date: Wed, 18 Nov 2026 15:57:30 +0100
Message-ID: <20261118150405.213572674@linuxfoundation.org>
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

From: Xuewen Wang <wangxuewen@kylinos.cn>

[ Upstream commit 0c3f2944e9060c31a221f32906267b827659b0c7 ]

If MFT bitmap extension fails before the initial $Bitmap scan completes,
rollback calls ntfs_bitmap_clear_bit(), which holds a folio lock while
ntfs_set_lcn_empty_bits() waits for the scan. The scanner deadlocks if it
still needs that folio.

Wait for the initial scan before taking the runlist or bitmap folio locks
and attempting allocation.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 482a216ade2cb..3192c018653b3 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1352,6 +1352,10 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(struct ntfs_volume *vol)
 	size_t new_rl_count;
 
 	ntfs_debug("Extending mft bitmap allocation.");
+	/* The initial bitmap scan must finish before we lock or change a folio. */
+	if (!NVolFreeClusterKnown(vol))
+		wait_event(vol->free_waitq, NVolFreeClusterKnown(vol));
+
 	mft_ni = NTFS_I(vol->mft_ino);
 	mftbmp_ni = NTFS_I(vol->mftbmp_ino);
 	/*
-- 
2.53.0



