Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B299537C902;
	Sat, 12 Sep 2026 07:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199513; cv=none; b=X79DdG9SLoAF8IScWPdqyRNhONHhmj4/usXAAbvynbUMyCl0iLwTv5bbOwDMwDcJ6T+yFgI5Zj33I85FGcARj5tbf7t5nM3MuRjh0icuLbPHnq2KzwzB/1XYauuDZE63hHzdZQM2lXDHNRz/rOwtlKZtbMs1bOB5POz4oFcvtAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199513; c=relaxed/simple;
	bh=Ut8zS5HyfV0bqJSro8qcb1MPeSyw6PgeuMGVzkrUJOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsTbWO04i8d19xtl80ckILwf0ncWWqFbeRBlwBEGPBiqKWUoWV7PsFZNVFQjMqdfNjuFKRXfiz8VKtkHRDIhL4ywVxIJQO8rnpCbCSanaJY2smz8/lHc51QpyYRVbSf2s57dK2Sp6XZSO6C8uR03Jcd2MoSjz2lP+r9DLKTp71o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlTTbrBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlTTbrBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D261F000FF;
	Sat, 12 Sep 2026 07:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199512;
	bh=b397CvZAkqNaXl1eE+6g1ppls4HQ72M7xEhJtW7xo/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlTTbrBY90tqe3CS5SAIyOXq0tr12Gez3ghFHMfMO2VYGhFXU7dfw5kp2hbIrl4Uv
	 uXxObfgZeOxA+EK/BQpuRzRJtlOvgpo9Pkzi+LRiRotBuZarkxOrfbLUpe8yycOCDY
	 p1+u8bif/XZZ+67DJR+Qk3xSbKn8U4jGjNWd20pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0601/1815] wifi: ath12k: fix ML-STA authentication timeout on QCC2072
Date: Sat, 12 Sep 2026 08:39:11 +0200
Message-ID: <20260912065702.993386136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit ff651212f2e237d790a5b36deef9d332360dc272 ]

QCC2072 firmware interprets the MLO_LINK_ADD and MLO_START_AS_ACTIVE
flags to control the link state during MLO vdev start. MLO_LINK_ADD
indicates that a link is being added, while MLO_START_AS_ACTIVE specifies
that the link should become active during the start.

When an association link is added without setting MLO_START_AS_ACTIVE,
the firmware may transition the link into a suspended state. In this
case, authentication frames transmitted by the host can be dropped,
leading to repeated authentication retries and eventual timeout,
for example:
  wlp1s0: send auth to <AP> (try 1/3)
  wlp1s0: send auth to <AP> (try 2/3)
  wlp1s0: send auth to <AP> (try 3/3)
  wlp1s0: authentication with <AP> timed out

Avoid triggering this behavior by setting the MLO_START_AS_ACTIVE flag
when MLO_ASSOC_LINK is set, which tells the firmware that the current
vdev must not enter suspend mode

Note that this change relies on firmware behavior observed on the QCC2072
platform. The firmware on WCN7850 and QCN9274 does not use the
MLO_START_AS_ACTIVE flag, so this change is effectively a no-op on those
platforms

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: d8e1f4a19310 ("wifi: ath12k: enable QCC2072 support")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260704073000.3300099-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 2 ++
 drivers/net/wireless/ath/ath12k/wmi.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 06ec236d20960..4d048bba679d6 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -1229,6 +1229,8 @@ int ath12k_wmi_vdev_start(struct ath12k *ar, struct wmi_vdev_start_req_arg *arg,
 						    ATH12K_WMI_FLAG_MLO_MCAST_VDEV) |
 				   le32_encode_bits(arg->ml.link_add,
 						    ATH12K_WMI_FLAG_MLO_LINK_ADD) |
+				   le32_encode_bits(arg->ml.assoc_link,
+						    ATH12K_WMI_FLAG_MLO_START_AS_ACTIVE) |
 				   cpu_to_le32(ATH12K_WMI_FLAG_MLO_IEEE_LINK_IDX_VALID);
 
 		ml_params->ieee_link_id = cpu_to_le32(arg->ml.ieee_link_id);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 51f3426e1fcd9..20e3939e8820b 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -2954,6 +2954,7 @@ struct wmi_vdev_create_mlo_params {
 #define ATH12K_WMI_FLAG_MLO_EMLSR_SUPPORT		BIT(6)
 #define ATH12K_WMI_FLAG_MLO_FORCED_INACTIVE		BIT(7)
 #define ATH12K_WMI_FLAG_MLO_LINK_ADD			BIT(8)
+#define ATH12K_WMI_FLAG_MLO_START_AS_ACTIVE		BIT(17)
 #define ATH12K_WMI_FLAG_MLO_IEEE_LINK_IDX_VALID		BIT(18)
 #define ATH12K_WMI_FLAG_MLO_IEEE_LINK_IDX_VALID_PARTNER	BIT(19)
 
-- 
2.53.0



