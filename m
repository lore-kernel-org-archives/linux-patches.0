Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820B1264A76;
	Tue,  8 Apr 2025 11:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110919; cv=none; b=PAdqh1Y+2kJGfaicY2F/KsN6siSgLK54iY7zZ1pJA4ZAHA7sKoCD73K4u/DjIaypTGlahGN5kwbjTU3ZR/IHzDhRo5Hq4Wt57as748peJjtgoXAp4UOyf05WXRzI0Z0IK1XEHLBQyU3KKWR1XcBgGyDq/Sffvce4TUHSbg90InU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110919; c=relaxed/simple;
	bh=84yfkGkSWrWKTiTULpEEy3JAs3SLNryYcVaqjZ58VuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t04iWO6w9fksX6fdJ51I1joWFkUhL5D0EUMPDYkFks1tJ2QIHqhRsjDJZofLpmjvMYxQSdmTVO6BTv28dSuJRPfKPLXor8nIHqYdvbhlTxkxiC5Pn7PaNec31HhMi0DCMvCpbhxPJVz4KxBKaIAXbI7xrZEAVPLnldQTSL9rM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPeESNG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPeESNG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F045C4CEE5;
	Tue,  8 Apr 2025 11:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110919;
	bh=84yfkGkSWrWKTiTULpEEy3JAs3SLNryYcVaqjZ58VuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPeESNG4o6JlXg7vRLnJc/V3sNkkBMSk1XLHACREfx1RwU/aYwzDuaanXfoWWO5UV
	 P7rAOpYm/d4elUDCjXZerRmSJTuLX7DPrypFxU+HdVURgNWS0oHQfllDLSh0LquCRu
	 jWjVmJ5XCp/gLFRBzBqTBMX0Xkbb7g/vPG1jStjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Chen <czj2441@163.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	WangYuli <wangyuli@uniontech.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 242/731] mlxsw: spectrum_acl_bloom_filter: Workaround for some LLVM versions
Date: Tue,  8 Apr 2025 12:42:19 +0200
Message-ID: <20250408104919.912633307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 4af9939a4977e05ccaaa645848f6208e82e06c61 ]

This is a workaround to mitigate a compiler anomaly.

During LLVM toolchain compilation of this driver on s390x architecture, an
unreasonable __write_overflow_field warning occurs.

Contextually, chunk_index is restricted to 0, 1 or 2. By expanding these
possibilities, the compile warning is suppressed.

Fix follow error with clang-19 when -Werror:
  In file included from drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c:5:
  In file included from ./include/linux/gfp.h:7:
  In file included from ./include/linux/mmzone.h:8:
  In file included from ./include/linux/spinlock.h:63:
  In file included from ./include/linux/lockdep.h:14:
  In file included from ./include/linux/smp.h:13:
  In file included from ./include/linux/cpumask.h:12:
  In file included from ./include/linux/bitmap.h:13:
  In file included from ./include/linux/string.h:392:
  ./include/linux/fortify-string.h:571:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
    571 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  1 error generated.

According to the testing, we can be fairly certain that this is a clang
compiler bug, impacting only clang-19 and below. Clang versions 20 and
21 do not exhibit this behavior.

Link: https://lore.kernel.org/all/484364B641C901CD+20250311141025.1624528-1-wangyuli@uniontech.com/
Fixes: 7585cacdb978 ("mlxsw: spectrum_acl: Add Bloom filter handling")
Co-developed-by: Zijian Chen <czj2441@163.com>
Signed-off-by: Zijian Chen <czj2441@163.com>
Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://patch.msgid.link/A1858F1D36E653E0+20250318103654.708077-1-wangyuli@uniontech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mlxsw/spectrum_acl_bloom_filter.c         | 27 +++++++++++++++----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index a54eedb69a3f5..067f0055a55af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -212,7 +212,22 @@ static const u8 mlxsw_sp4_acl_bf_crc6_tab[256] = {
  * This array defines key offsets for easy access when copying key blocks from
  * entry key to Bloom filter chunk.
  */
-static const u8 chunk_key_offsets[MLXSW_BLOOM_KEY_CHUNKS] = {2, 20, 38};
+static char *
+mlxsw_sp_acl_bf_enc_key_get(struct mlxsw_sp_acl_atcam_entry *aentry,
+			    u8 chunk_index)
+{
+	switch (chunk_index) {
+	case 0:
+		return &aentry->ht_key.enc_key[2];
+	case 1:
+		return &aentry->ht_key.enc_key[20];
+	case 2:
+		return &aentry->ht_key.enc_key[38];
+	default:
+		WARN_ON_ONCE(1);
+		return &aentry->ht_key.enc_key[0];
+	}
+}
 
 static u16 mlxsw_sp2_acl_bf_crc16_byte(u16 crc, u8 c)
 {
@@ -235,9 +250,10 @@ __mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
 			     u8 key_offset, u8 chunk_key_len, u8 chunk_len)
 {
 	struct mlxsw_afk_key_info *key_info = aregion->region->key_info;
-	u8 chunk_index, chunk_count, block_count;
+	u8 chunk_index, chunk_count;
 	char *chunk = output;
 	__be16 erp_region_id;
+	u32 block_count;
 
 	block_count = mlxsw_afk_key_info_blocks_count_get(key_info);
 	chunk_count = 1 + ((block_count - 1) >> 2);
@@ -245,12 +261,13 @@ __mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
 				   (aregion->region->id << 4));
 	for (chunk_index = max_chunks - chunk_count; chunk_index < max_chunks;
 	     chunk_index++) {
+		char *enc_key;
+
 		memset(chunk, 0, pad_bytes);
 		memcpy(chunk + pad_bytes, &erp_region_id,
 		       sizeof(erp_region_id));
-		memcpy(chunk + key_offset,
-		       &aentry->ht_key.enc_key[chunk_key_offsets[chunk_index]],
-		       chunk_key_len);
+		enc_key = mlxsw_sp_acl_bf_enc_key_get(aentry, chunk_index);
+		memcpy(chunk + key_offset, enc_key, chunk_key_len);
 		chunk += chunk_len;
 	}
 	*len = chunk_count * chunk_len;
-- 
2.39.5



