Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B3C70805;
	Thu, 13 Feb 2025 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460623; cv=none; b=p/UMN3x2NshIYUVBhvFrSFe1/tpGexONiSdCwg+fdK/BgkIW19V/iZD/143jGjZNTOOXku9gZZX/LoMLT27Qzf6mvzvCJrdE7vs9OKBTRzXpw3vLjg4Zh8q4TZIBjHzxU4jSVfsJ6AdSVQgjeIAdHv94b32WwOKrbiXZirSABaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460623; c=relaxed/simple;
	bh=dUHuv0oMt0oDVZN3tzlUmkWjz71irm425O+ZTF5DjPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjyqY/BSCf3r/CyQXSkkNSn0BvmeOKsY75ZHBTWY2R7lzDiEOEWlb+SkqJzNal/j7MX7YzjD47JOU15ubDeCHXe/cZVaBmstJ81cxh6h3yl5q1nrQcgotjI57VVPz07qBkF2d95yTIPCxmdeNp1/C1ncORZfR34j9k11h8ORhm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayALFfUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayALFfUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A54C4CED1;
	Thu, 13 Feb 2025 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460622;
	bh=dUHuv0oMt0oDVZN3tzlUmkWjz71irm425O+ZTF5DjPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayALFfUZOulcTF1QofSYJ0I85oQGwcG4yzuCjPjZi0qUHBTfb6jeqRZvaBK3Fk/jC
	 M5I512VxN+cu1fUmmLD6yWI31Fg8HicFK1NWDrlqRMNVLLiJD82/Be3WulW2uJorBn
	 CjfXvrasYTjw0kf09pnS2+JuAPQNEK7PjDq95CeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Eric Biggers <ebiggers@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 164/273] scsi: ufs: qcom: Fix crypto key eviction
Date: Thu, 13 Feb 2025 15:28:56 +0100
Message-ID: <20250213142413.814274286@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 7a0905caf5665be41094a6ceb5e9d2524de4627a upstream.

Commit 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
introduced an incorrect check of the algorithm ID into the key eviction
path, and thus qcom_ice_evict_key() is no longer ever called.  Fix it.

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20241210030839.1118805-1-ebiggers@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -158,8 +158,9 @@ static int ufs_qcom_ice_program_key(stru
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	union ufs_crypto_cap_entry cap;
-	bool config_enable =
-		cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE;
+
+	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
+		return qcom_ice_evict_key(host->ice, slot);
 
 	/* Only AES-256-XTS has been tested so far. */
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
@@ -167,14 +168,11 @@ static int ufs_qcom_ice_program_key(stru
 	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
 		return -EOPNOTSUPP;
 
-	if (config_enable)
-		return qcom_ice_program_key(host->ice,
-					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
-					    cfg->data_unit_size, slot);
-	else
-		return qcom_ice_evict_key(host->ice, slot);
+	return qcom_ice_program_key(host->ice,
+				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
+				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
+				    cfg->crypto_key,
+				    cfg->data_unit_size, slot);
 }
 
 #else


