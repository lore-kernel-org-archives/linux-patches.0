Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266D18D630;
	Thu, 15 Aug 2024 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729314; cv=none; b=hT03H5PtRtZIJKfdhzwozx6R6dfPcSv+8TStDlxAgZdKt05fxa+5bFHDmhx4tH6V7dztPyNbuxF6oDAmsmxq3idSNn4epnykFfnYgzSfCZKmw60d3p5pAqOWwEi+ku03SnG4aZXnz0T1iKgGvrTooifXnW+SJPWoIgPNhDwtA24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729314; c=relaxed/simple;
	bh=+Q0TdTIpIQ5O6hSiHFr7iPLL5aGHrX/Lkvs1sS8N7NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwTaj2VaNSRaRr3ZNR97Bn90Wn/ZR+nWzwIg0UNi2StAeCnwMBRxOAQ8F4Bfb9nkOfPuK4U5ojXYPNCPXlSdWnTVh2c3XaeZygbTU76ep/Yh2xXm5WKsiTnFv/G0b2sWZEK/pKwiX+7O8zUddFYfjmOm9hrIyU/7H0hq7nHN/K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wepQ71Aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wepQ71Aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F1EC32786;
	Thu, 15 Aug 2024 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729313;
	bh=+Q0TdTIpIQ5O6hSiHFr7iPLL5aGHrX/Lkvs1sS8N7NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wepQ71AaweWO4BfuoR/NqJ8hRZlXl7hDnBV8WGyJvZqHRaWDkkyYJ+vOdQY8KXNtq
	 um7i45vqm/giQIBgHVw8ivDfbRoLdyeAsrC7tUCJr55eaAj6RHwe++NH8mLra0IfBb
	 eD63WIXWV1ty3KI+8Xf/PqVJSyCuinocl7c4Z56U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/484] mlxsw: spectrum_acl_bloom_filter: Make mlxsw_sp_acl_bf_key_encode() more flexible
Date: Thu, 15 Aug 2024 15:18:35 +0200
Message-ID: <20240815131943.486456362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 5d5c3ba9e4121b7738d10be3825f4d9a5a1d80ef ]

Spectrum-4 will calculate hash function for bloom filter differently from
the existing ASICs.

One of the changes is related to the way that the chunks will be build -
without padding.

As preparation for support of Spectrum-4 bloom filter, make
mlxsw_sp_acl_bf_key_encode() more flexible, so it will be able to use it
for Spectrum-4 as well.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 75d8d7a63065 ("mlxsw: spectrum_acl: Fix ACL scale regression and firmware errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mlxsw/spectrum_acl_bloom_filter.c         | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index 2e8b17e3b9358..2d2e29c202770 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -116,9 +116,10 @@ static u16 mlxsw_sp_acl_bf_crc(const u8 *buffer, size_t len)
 }
 
 static void
-mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
-			   struct mlxsw_sp_acl_atcam_entry *aentry,
-			   char *output, u8 *len)
+__mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
+			     struct mlxsw_sp_acl_atcam_entry *aentry,
+			     char *output, u8 *len, u8 max_chunks, u8 pad_bytes,
+			     u8 key_offset, u8 chunk_key_len, u8 chunk_len)
 {
 	struct mlxsw_afk_key_info *key_info = aregion->region->key_info;
 	u8 chunk_index, chunk_count, block_count;
@@ -129,17 +130,30 @@ mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
 	chunk_count = 1 + ((block_count - 1) >> 2);
 	erp_region_id = cpu_to_be16(aentry->ht_key.erp_id |
 				   (aregion->region->id << 4));
-	for (chunk_index = MLXSW_BLOOM_KEY_CHUNKS - chunk_count;
-	     chunk_index < MLXSW_BLOOM_KEY_CHUNKS; chunk_index++) {
-		memset(chunk, 0, MLXSW_BLOOM_CHUNK_PAD_BYTES);
-		memcpy(chunk + MLXSW_BLOOM_CHUNK_PAD_BYTES, &erp_region_id,
+	for (chunk_index = max_chunks - chunk_count; chunk_index < max_chunks;
+	     chunk_index++) {
+		memset(chunk, 0, pad_bytes);
+		memcpy(chunk + pad_bytes, &erp_region_id,
 		       sizeof(erp_region_id));
-		memcpy(chunk + MLXSW_BLOOM_CHUNK_KEY_OFFSET,
+		memcpy(chunk + key_offset,
 		       &aentry->enc_key[chunk_key_offsets[chunk_index]],
-		       MLXSW_BLOOM_CHUNK_KEY_BYTES);
-		chunk += MLXSW_BLOOM_KEY_CHUNK_BYTES;
+		       chunk_key_len);
+		chunk += chunk_len;
 	}
-	*len = chunk_count * MLXSW_BLOOM_KEY_CHUNK_BYTES;
+	*len = chunk_count * chunk_len;
+}
+
+static void
+mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
+			   struct mlxsw_sp_acl_atcam_entry *aentry,
+			   char *output, u8 *len)
+{
+	__mlxsw_sp_acl_bf_key_encode(aregion, aentry, output, len,
+				     MLXSW_BLOOM_KEY_CHUNKS,
+				     MLXSW_BLOOM_CHUNK_PAD_BYTES,
+				     MLXSW_BLOOM_CHUNK_KEY_OFFSET,
+				     MLXSW_BLOOM_CHUNK_KEY_BYTES,
+				     MLXSW_BLOOM_KEY_CHUNK_BYTES);
 }
 
 static unsigned int
-- 
2.43.0



