Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704135;
	b=2tDGZFcRxnnBnXOYXGQsdR3S9cjU2NO0DN6W2wEfrPeEqoXA7/FWA1KiU4sRAznoXgsA
	 w3gt+Nu3+pAerWEaUCKt/AO2Uh/VzLph1z05OdOEkX6gJXs3iMbTwwly2ljFAt945Pzgh
	 +wQTWXqkskosOeXjwfD6GqDiCjFsE8GBMrztwwS/He+0+Ddp183KHS/SypVnMQExc76nd
	 AneJLNVTaO5am8embtJp92Wt0ARorpCWx3CLlqOPAhc3yoZDpP1uHeNaWDa9DOa5QEqyv
	 dYLGI6d/UOubE4lYk+Y7YltN4PQzqsBjp7aO6aQ7cnxo1GmvUJVL+XwxqvySk1IaFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8RScDn2d12QPOpw0wC1Pl6Q6PNJ3Odhv+Y8FucQ7yz8=;
	b=mLIbs1tSq3WtXDcWGWNyNOnMAJvQWH7kgOUxB21PDphpTN5AmoJ5fHKKmzOA4PwO+g5D
	 pTVHAmnwzBOscp5ZAzgXYn3WftHfx2Sh8Eb/LS4gdIeiaU2bzTsNn0I/LZGl9vvtq2WI2
	 KVi1Zd+y3HhNaULXn3rwiQx5BFBblnE+fVsMoW6mbkwspE0WwiguFAHBM9yxuHIzUmq9F
	 9lcRE//vtTPfs7rFBbIiWf7TCZTvOgkF1dsDgOTp1fH3F/lnUSs0KLIo8oVQ0zb2xuhsc
	 QQP08nDDAjBcf66eiExanQtisEjj5TTvW+md8ROCeYAYJQrtMrJHT8rp0ihN4JjIKww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhtAlSQo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4641C606A31C;
	Thu, 26 Nov 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhtAlSQo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BEA1F000C6;
	Thu, 26 Nov 2026 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704134;
	bh=8RScDn2d12QPOpw0wC1Pl6Q6PNJ3Odhv+Y8FucQ7yz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhtAlSQo5lZX3iXaDJIUloZGvkjTMvmsabsnpAIdJAtTQYRjkP5swpwaKPIAtmWx/
	 2OD+oifIQlBYKcSpn9/uCs4Qh5B8vS3h/AAcQvIAb4cZB1x92gcAAxhTPg7AdnkExu
	 aAs8IJw7zyyLbjDIh2t+LbaR/hb5m6T94OSSuXFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/265] udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()
Date: Thu, 26 Nov 2026 15:35:49 +0100
Message-ID: <20261126143606.404181263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 49f771d14578733a350c45e34e1bc6ad14f56952 ]

In udf_load_vat() (fs/udf/super.c), validate that vat20->lengthHeader is
at least sizeof(struct virtualAllocationTable20) and does not exceed the
mapped buffer or VAT inode size so computing the VAT table pointer and
entry count cannot underflow or read out of bounds.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20260919222600.3793513-1-benquike@gmail.com
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index fa49793ad5fb2..d3c8846d8ebfa 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1225,6 +1225,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 			(sbi->s_vat_inode->i_size - 36) >> 2;
 	} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
 		vati = UDF_I(sbi->s_vat_inode);
+		if (sbi->s_vat_inode->i_size <
+		    sizeof(struct virtualAllocationTable20)) {
+			udf_err(sb, "Too short VAT inode size %lld\n",
+				sbi->s_vat_inode->i_size);
+			return -EFSCORRUPTED;
+		}
 		if (vati->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 			pos = udf_block_map(sbi->s_vat_inode, 0);
 			bh = sb_bread(sb, pos);
@@ -1238,8 +1244,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
 		map->s_type_specific.s_virtual.s_start_offset =
 			le16_to_cpu(vat20->lengthHeader);
-		if (map->s_type_specific.s_virtual.s_start_offset
-		    > sbi->s_vat_inode->i_size) {
+		if (map->s_type_specific.s_virtual.s_start_offset <
+				sizeof(struct virtualAllocationTable20) ||
+		    map->s_type_specific.s_virtual.s_start_offset >
+				sb->s_blocksize ||
+		    map->s_type_specific.s_virtual.s_start_offset >
+				sbi->s_vat_inode->i_size) {
 			udf_err(sb, "Corrupted VAT header length %u (VAT inode size %lld)\n",
 				map->s_type_specific.s_virtual.s_start_offset,
 				sbi->s_vat_inode->i_size);
-- 
2.53.0



