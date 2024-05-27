Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A50168C4;
	Mon, 27 May 2024 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837793; cv=none; b=Nmr8vlb9KgeOLKEyGlcYhpUP6wVtMt0EYLKuENLoc5iRCwCIiaN/BVnO2yWo3Ib3Ww2yQDR+esyCJ86X2AmXi7PqzOnHk3jLMJESvd8bcDk2KPjPGh45z2yZ7ByVB5nUkz77xEJDB50gmkxKl5sL/ZaF2x+yZKJOkUCeZHWYUzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837793; c=relaxed/simple;
	bh=8sQibg7ngBLiZgpROLEZlZN9WGh4EZ9yBc0Q65B7UmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us9IEbpBtLnqzi2Ddggm6DK2sz45HqFjOfUSL6bLYvPvjAqW46XbJiS9qefUWLvwjPKeCHCFOel+mfAznzJbH3a9XRfMzqyNd3VENdY+NS1cpLN2uQTmno6C0IXLLGGRWK5EyyOSGjFWmutpdqxd2+LQgWWHf5GdrWfoPukhh3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqzcbVPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqzcbVPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCE1C2BBFC;
	Mon, 27 May 2024 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837793;
	bh=8sQibg7ngBLiZgpROLEZlZN9WGh4EZ9yBc0Q65B7UmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqzcbVPNHGuyNBPVLqH1mto6Xcq4jG6gb5oocHUk5ZjLLaD7vd5EVGjUFaqa/Yf41
	 Q9mHOKGeSy1CTExS0Tc8Vr158iYDuC/mjG26834GQcbH9Ap/LQFH/hKLIeRSmyvUUS
	 zHYuOtBw9AzX8Eqw6PiUpo8VuwlofjyNwa/0XafY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 147/493] crypto: qat - validate slices count returned by FW
Date: Mon, 27 May 2024 20:52:29 +0200
Message-ID: <20240527185635.249119605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>

[ Upstream commit 483fd65ce29317044d1d00757e3fd23503b6b04c ]

The function adf_send_admin_tl_start() enables the telemetry (TL)
feature on a QAT device by sending the ICP_QAT_FW_TL_START message to
the firmware. This triggers the FW to start writing TL data to a DMA
buffer in memory and returns an array containing the number of
accelerators of each type (slices) supported by this HW.
The pointer to this array is stored in the adf_tl_hw_data data
structure called slice_cnt.

The array slice_cnt is then used in the function tl_print_dev_data()
to report in debugfs only statistics about the supported accelerators.
An incorrect value of the elements in slice_cnt might lead to an out
of bounds memory read.
At the moment, there isn't an implementation of FW that returns a wrong
value, but for robustness validate the slice count array returned by FW.

Fixes: 69e7649f7cc2 ("crypto: qat - add support for device telemetry")
Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/intel/qat/qat_common/adf_gen4_tl.c |  1 +
 .../intel/qat/qat_common/adf_telemetry.c      | 21 +++++++++++++++++++
 .../intel/qat/qat_common/adf_telemetry.h      |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
index 7fc7a77f6aed9..c7ad8cf07863b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
@@ -149,5 +149,6 @@ void adf_gen4_init_tl_data(struct adf_tl_hw_data *tl_data)
 	tl_data->sl_exec_counters = sl_exec_counters;
 	tl_data->rp_counters = rp_counters;
 	tl_data->num_rp_counters = ARRAY_SIZE(rp_counters);
+	tl_data->max_sl_cnt = ADF_GEN4_TL_MAX_SLICES_PER_TYPE;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_tl_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
index 2ff714d11bd2f..74fb0c2ed2412 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
@@ -41,6 +41,20 @@ static int validate_tl_data(struct adf_tl_hw_data *tl_data)
 	return 0;
 }
 
+static int validate_tl_slice_counters(struct icp_qat_fw_init_admin_slice_cnt *slice_count,
+				      u8 max_slices_per_type)
+{
+	u8 *sl_counter = (u8 *)slice_count;
+	int i;
+
+	for (i = 0; i < ADF_TL_SL_CNT_COUNT; i++) {
+		if (sl_counter[i] > max_slices_per_type)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int adf_tl_alloc_mem(struct adf_accel_dev *accel_dev)
 {
 	struct adf_tl_hw_data *tl_data = &GET_TL_DATA(accel_dev);
@@ -214,6 +228,13 @@ int adf_tl_run(struct adf_accel_dev *accel_dev, int state)
 		return ret;
 	}
 
+	ret = validate_tl_slice_counters(&telemetry->slice_cnt, tl_data->max_sl_cnt);
+	if (ret) {
+		dev_err(dev, "invalid value returned by FW\n");
+		adf_send_admin_tl_stop(accel_dev);
+		return ret;
+	}
+
 	telemetry->hbuffs = state;
 	atomic_set(&telemetry->state, state);
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
index 9be81cd3b8860..e54a406cc1b4a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
@@ -40,6 +40,7 @@ struct adf_tl_hw_data {
 	u8 num_dev_counters;
 	u8 num_rp_counters;
 	u8 max_rp;
+	u8 max_sl_cnt;
 };
 
 struct adf_telemetry {
-- 
2.43.0



