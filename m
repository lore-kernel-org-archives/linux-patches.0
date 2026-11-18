Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037978;
	b=QrFfln6pCVYlvp/u2yWAJ7B0u0+kvi27JAJYnA8jF8d5CuhTt+1q7cO6q71iTN0oALtZ
	 KMqMYQnAnzZGFH/0E+vbkhm6SYRMexwrezcDlvun9IrTvNCWPCw194GY5mVOMWppMjkNl
	 FS08pBLT/jEbScZvywVd5jImNDow6e6feK5M0Xyont42R7JWVFOsQFblMesiv1pgIVgaB
	 lcGSrTeQep3/qDIRnmMXLj/TqWVrxaCoZWIn0pxMEApBIKaWLT6+lp5nBY4ump8CXcUdf
	 pg9UWA6kUyridR7XTxLI4LFwhoTpxYV4svyacxD2rziQLdZuZBkbCekbFjU3IpB+Z2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gvhZEq9vRQVbNXl12Zk1QPOEE/EIvKvPiH+aBCkEwFc=;
	b=x18fSUbWFcr3eocMwSAkNBMlBZQbfyVFNGneR5/aVxIDySQoEM6HHdvwEET5BFJP3xNf
	 rUrl5aG7htGF90L1VUTZSdE+oj3j0GUx0O1LmZJh4xV/ar8EpOfhu8x+ElJScxQfOE6td
	 Q1v8D52eonl5qqcvYMbgyE5znlmRRLQ0bWGXc2ppWc+QSLPPuI/or3gP4TSAVaFWy3yOQ
	 ytWsCzApudyV7hrV732XOL/u577WzIv6hicdntDrUedhYdcjfhQomwQ/pnFj9TByj+vil
	 Nz/fdI2JopPKIJ1njtDuNjCPbBrzN54Kb3It3uDQkZbmhKvwCW7+N2TUWTb73clnAdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lAkv+ek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35CC606A31C;
	Wed, 18 Nov 2026 21:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lAkv+ek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA671F000C4;
	Wed, 18 Nov 2026 21:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037978;
	bh=gvhZEq9vRQVbNXl12Zk1QPOEE/EIvKvPiH+aBCkEwFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lAkv+ekU5iex1jQH1cb5zun03eF292GZnFfihUetrTfhZDnEXJPvM6JgDQVrvOLl
	 lIiZE7BxXgB/vjiTPVhi13I8nJn6Q4GMkMeZjUOZygIxsPAevzVAZ1ryB19NV0rJUK
	 X2820sGJunGFPTVKAjPoCAw7khkd1jaIPoSlRKto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1584/3318] udf: Avoid invalid LVID used on mount
Date: Wed, 18 Nov 2026 15:36:46 +0100
Message-ID: <20261118150408.649687311@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit c8f1140cb82dc843e72697dc6f8c7ee1acce5d28 ]

udf_load_logicalvolint() loads logical volume integrity descriptors.
Since there can be multiple blocks with LVIDs, we verify the contents of
only the last (prevailing) LVID found. However if we fail to load the
last LVID (either due to IO error or because it's checksum fails to
match), we never perform the verification of validity of the LVID we are
going to use. If such LVID contains invalid data, we can hit
out-of-bounds access or similar issues. Fix the problem by verifying
each LVID we are potentially going to accept.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: a61fb39759d7 ("udf: Make sure there's enough space for LVID implementation use field")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8da1e24ed599d..67c9111624d84 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1650,6 +1650,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	return ret;
 }
 
+static bool udf_lvid_valid(struct super_block *sb,
+			   struct logicalVolIntegrityDesc *lvid)
+{
+	u32 parts, impuselen;
+
+	parts = le32_to_cpu(lvid->numOfPartitions);
+	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
+	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
+	    2 * parts * sizeof(u32) > sb->s_blocksize)
+		return false;
+	return true;
+}
+
 /*
  * Find the prevailing Logical Volume Integrity Descriptor.
  */
@@ -1660,7 +1674,6 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDesc *lvid;
 	int indirections = 0;
-	u32 parts, impuselen;
 
 	while (++indirections <= UDF_MAX_LVID_NESTING) {
 		final_bh = NULL;
@@ -1682,32 +1695,27 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 		if (!final_bh)
 			return;
 
-		brelse(sbi->s_lvid_bh);
-		sbi->s_lvid_bh = final_bh;
-
 		lvid = (struct logicalVolIntegrityDesc *)final_bh->b_data;
+		if (udf_lvid_valid(sb, lvid)) {
+			brelse(sbi->s_lvid_bh);
+			sbi->s_lvid_bh = final_bh;
+		} else {
+			udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
+				 "ignoring.\n",
+				 le32_to_cpu(lvid->numOfPartitions),
+				 le32_to_cpu(lvid->lengthOfImpUse));
+		}
+
 		if (lvid->nextIntegrityExt.extLength == 0)
-			goto check;
+			return;
 
 		loc = leea_to_cpu(lvid->nextIntegrityExt);
 	}
 
 	udf_warn(sb, "Too many LVID indirections (max %u), ignoring.\n",
 		UDF_MAX_LVID_NESTING);
-out_err:
 	brelse(sbi->s_lvid_bh);
 	sbi->s_lvid_bh = NULL;
-	return;
-check:
-	parts = le32_to_cpu(lvid->numOfPartitions);
-	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
-	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
-	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
-	    2 * parts * sizeof(u32) > sb->s_blocksize) {
-		udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
-			 "ignoring.\n", parts, impuselen);
-		goto out_err;
-	}
 }
 
 /*
-- 
2.53.0



