Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CF513DDDD;
	Thu, 11 Apr 2024 09:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829531; cv=none; b=A8vqgle3lrQ+rzUEBhwgbtFeU8GVnozofm/HS+VEgoX0l5I3dICg4WzVs5SizN73Ju8eNqTe2lPqZdZgdqSkYFxVQ6NF5avhLq7SEDK/XNGINO8UMN37yZ+Ykrv9lGgZHaMP18HkOVorrP4PzGYtpPTxZHC6hCzG0SWGAYAl+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829531; c=relaxed/simple;
	bh=HRy/ye7dCgr8qMnQE0yzzx4ksBloZKc9LLbvnBeUHis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdE3U86jN/rt1P7YlOGd/gVTr41N9TysTDdjhNwZLbYJ0rwIkcCj/Wy5N1Pdd92S23gt2ocboAfsexStu8WQtjeVMTCTR+ETM0OWUfblWhiQCo5F2BdQ4yo0zwRzakqNlVoooq8ZMhZGql+OmWn7I1c1TEGE7nl/QZrC/lE4G84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNVOPPBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNVOPPBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B621FC433C7;
	Thu, 11 Apr 2024 09:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829531;
	bh=HRy/ye7dCgr8qMnQE0yzzx4ksBloZKc9LLbvnBeUHis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNVOPPBJwECYXBpZBb0I0YFVF0LElRqeGsKjRhm1uxVxfeWPBNnfVHM5aE7p/ysMa
	 6DMlBDdPw1ITIm0uKecEC5jz2T7JnlwCpLHTgHI6uIbPkGBFmBbIvgfRZH/5zpLqN9
	 3Wl69HCIhGhImKhlHc10OZ0ozpFN3fVdHcfPNDS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/175] crypto: qat - fix double free during reset
Date: Thu, 11 Apr 2024 11:54:02 +0200
Message-ID: <20240411095420.127972396@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

[ Upstream commit 01aed663e6c421aeafc9c330bda630976b50a764 ]

There is no need to free the reset_data structure if the recovery is
unsuccessful and the reset is synchronous. The function
adf_dev_aer_schedule_reset() handles the cleanup properly. Only
asynchronous resets require such structure to be freed inside the reset
worker.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 9225d060e18f4..44b91cb73dd19 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -139,7 +139,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		kfree(reset_data);
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
 	}
-- 
2.43.0



