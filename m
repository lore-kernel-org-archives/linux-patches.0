Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F864E73DF;
	Thu, 17 Sep 2026 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658916; cv=none; b=t1uOP+/mLr6uFBZU4yTXaCsNroaov4HEzR5n9kds9nRt1EjhJuFmHD5TU4Ih4cctt9hKVWkW+OSd8+pWtc6iYvKvxgYr8PvFzXWfF5gruE2+CelxtUkTE1M3+jRFubV+tvu755HYy1EB2Td0l1/MmYoxfA90b4L4G8VxLy2gOdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658916; c=relaxed/simple;
	bh=7ZgRRe3+eJzk1rxbpL+iAsAg0zRuUCGbLP9ttGzqthI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snrzBlAaF7bXrQl5QlbHyncvvM1S3R5ZdxCi4y+G16TqmdsDNnuaFD7fekEpsyM8N8fIdpm+LsyeNyWegdXCupBkKmQcnC26d17/wSqFLVhxHmRLZiNfkG8je2YgZkxaF+5i2yY39h3JibMS0v56z2uhbP9asTT3LXAc4yqzdGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aECVHx3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aECVHx3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C652F1F000FF;
	Thu, 17 Sep 2026 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658910;
	bh=9jSI0dyosUTMaVzZEVhaUbEquEOpbvlDMzw6AY3U7eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aECVHx3xGw+XrVLU+csRJFED/uY0hzEol3xTYyddRMTLU2e0QtqFbZ3BlQxknJMbP
	 EzyJqbe4ilkXpMStjrizZMB8flPo9+abWiva7NRP9WLpemXPCuELo9o5YvIsWPzBz2
	 iduqaoS1KMbTmB5Nb+OU/4105Axgi3Z2CJBw3IMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 042/733] ntfs: fix kmap_local leak in write_mft_record_nolock() error paths
Date: Thu, 17 Sep 2026 16:05:50 +0100
Message-ID: <20260917151351.808841454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit cf06dcd572845723821b54a608fc2da995c3c8e2 ]

write_mft_record_nolock() maps the MFT record folio with
kmap_local_folio(), but the pre_write_mst_fixup() and
bio_add_folio() failure paths jump to the error label without
unmapping it. kmap_local mappings are stack-ordered per task, so
leaking one corrupts the nesting for any outer mapping.

Unmap the folio on those error paths too.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 271a265491280..3ad739179c7a1 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -580,7 +580,7 @@ int write_mft_record_nolock(struct ntfs_inode *ni, struct mft_record *m, int syn
 	err = pre_write_mst_fixup((struct ntfs_record *)fixup_m, vol->mft_record_size);
 	if (err) {
 		ntfs_error(vol->sb, "Failed to apply mst fixups!");
-		goto err_out;
+		goto unmap_err_out;
 	}
 
 	folio_size = vol->mft_record_size / ni->mft_lcn_count;
@@ -645,6 +645,8 @@ int write_mft_record_nolock(struct ntfs_inode *ni, struct mft_record *m, int syn
 	return 0;
 put_bio_out:
 	bio_put(bio);
+unmap_err_out:
+	kunmap_local(kaddr);
 err_out:
 	/*
 	 * The caller should mark the base inode as bad so no more I/O
-- 
2.53.0



