Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59BD14831F;
	Tue, 30 Jul 2024 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357771; cv=none; b=W/UF+ZPSfL7ga0tv5EBbhm4p9o5JesDtVcPJaoJNPmi2Kwmrf4L1gvEYC9rAdUIJnb30st28gJM4F3BY4hf5WU7DNYRX3hBn2sEZD8ScIHEbhPk/BbOTxj4WoVzg1c8DeJ3NmnHKySEbpSBO/d4VG33zuzxJ7l0CkzqlODP8nwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357771; c=relaxed/simple;
	bh=FqFedBiGIGyRTSMEDNMLlX7QiRdduY98FELYWLyYQfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/AA7cjvB8Rt/cn4hUhOaDnSPjHObHgD0bTg1xEXHjjMlF51qNqHuuIE3xMrR2TqMWNWKmfAfo0AnB0nOkXG1iK5wJ+PZO9BgcZgeBK81AUxyHJtIGAlwnmnrt2B5fIBU8WNCfZBeC8g3k0hZUb3N+7sbu4Gt2zkxiU/kq6vtTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbZHEtfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbZHEtfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452B5C32782;
	Tue, 30 Jul 2024 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357771;
	bh=FqFedBiGIGyRTSMEDNMLlX7QiRdduY98FELYWLyYQfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbZHEtfAnNK1a5HORLtC4ndMfPz9p97Bk2kJ/Kze29QHQvYaE78qK3RwzzgUn9pwz
	 DcMjKX9wDlniuToHcu5H5mbzhCk5LAql36M/mZ/wQFlM6sB7YLq8EkTKDraSV51bKn
	 rXsaPMwoWWlojp9WLYPNg3uIDOVD3AGSqh/BXGCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/568] crypto: qat - extend scope of lock in adf_cfg_add_key_value_param()
Date: Tue, 30 Jul 2024 17:46:37 +0200
Message-ID: <20240730151651.208283014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>

[ Upstream commit 6424da7d8b938fe66e7e771eaa949bc7b6c29c00 ]

The function adf_cfg_add_key_value_param() attempts to access and modify
the key value store of the driver without locking.

Extend the scope of cfg->lock to avoid a potential race condition.

Fixes: 92bf269fbfe9 ("crypto: qat - change behaviour of adf_cfg_add_key_value_param()")
Signed-off-by: Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 8836f015c39c4..2cf102ad4ca82 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -290,17 +290,19 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 	 * 3. if the key exists with the same value, then return without doing
 	 *    anything (the newly created key_val is freed).
 	 */
+	down_write(&cfg->lock);
 	if (!adf_cfg_key_val_get(accel_dev, section_name, key, temp_val)) {
 		if (strncmp(temp_val, key_val->val, sizeof(temp_val))) {
 			adf_cfg_keyval_remove(key, section);
 		} else {
 			kfree(key_val);
-			return 0;
+			goto out;
 		}
 	}
 
-	down_write(&cfg->lock);
 	adf_cfg_keyval_add(key_val, section);
+
+out:
 	up_write(&cfg->lock);
 	return 0;
 }
-- 
2.43.0



