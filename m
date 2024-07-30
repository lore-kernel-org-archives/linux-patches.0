Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09E18B494;
	Tue, 30 Jul 2024 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356622; cv=none; b=Tk53IsUib5YoVgNGSWZUClBCynqdc8fM8u2qoWCqKG2NJa/5Ivj1NHLXnLgo9oG6JHizQJUiftWjlMG4JyMGygTb3HvpBQnl+WakRD54cvWELMrgbuOw6bJUN3LM75rJQMI/fGbFQvHp2n6ac7cn6Tn68yDZZLQZPZdOo25fsvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356622; c=relaxed/simple;
	bh=yUCeb863krhjEBAlMWakyfYWutlfSqVAR0SjhDI8pc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaeUh/2cGyx9ZO1TFTV1I6A+aHHfsCmtPCuSH+htStdRkEzDF5H+z/jqYS8sOQmg0x/B25mIkq4YcStk/bmQbCDBQj5BW+9tx8kWwTDRiz81NvhEzAvvtGdBK+ja8VU+CYkcGfSUQCdKbodTNtVlEl+SwuTalh3Tfa2hv/DrMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKJxBApK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKJxBApK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DBDC4AF10;
	Tue, 30 Jul 2024 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356622;
	bh=yUCeb863krhjEBAlMWakyfYWutlfSqVAR0SjhDI8pc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKJxBApKouUcKYGgVHgHQqB4cjqO1uD0IYLru4ZHhS4gaPV7qZ67K0SnFSF/cNjR2
	 hU3JasALz2ZWGozNwogLxVR3fuMJiEGi5dxkwe0tUO31vB+EPIY0VoyUwcySaMD1Xw
	 a+V+/NNIXaI+yb+5Gb4Hh1sL2WoEHXJ3PQvTsrW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/440] crypto: qat - extend scope of lock in adf_cfg_add_key_value_param()
Date: Tue, 30 Jul 2024 17:47:26 +0200
Message-ID: <20240730151624.183381879@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/qat/qat_common/adf_cfg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index 1931e5b37f2bd..368d14d81503c 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -276,17 +276,19 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
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



