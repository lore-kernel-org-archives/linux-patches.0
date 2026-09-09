Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB68568FDD;
	Wed,  9 Sep 2026 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962664; cv=none; b=I2Idh4DoaqZ3+wfac5f9pP+5jSLWhMbbv41FaXjo3tSP8Neg5CJAgm7i2etYBSegg43K4Cejhq9axJ4eoQjIp7lTuAiTl+69Jz+Hj1uem+KL5V15MK5sHV+WKjWOOlVlgv3BzU54AeOGdnhzBFDbMdw0MaxbVrBOGVlR8ieAz0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962664; c=relaxed/simple;
	bh=1NNtqoHRJoXtMVf4hDdCLgFbvt9xHoPbxsRE7/okUXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7qlMVXwxytiD2E2UhuVFQMKAbniPsWEQA6YFNfv/obbaiqbHeYfLt6fDcTcctF3BMO3eMzaTlyj6iwMWDaNSOCAI9BVA15X+OkDUAIFPTLE/ujiTpRYfRQzb6jWhhVdpP66iAiPSHecHAuRvHnAb9BdIMso70OD8Vx4zBxDAvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEhrvtsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEhrvtsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAD91F00ACA;
	Wed,  9 Sep 2026 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962662;
	bh=dB1e+J2an+gftsTJVebHnuDl8dfamrC8nD/O+QZma+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEhrvtsXxV0KgkzJOy3NvYl1330faBlEcFSfjwrou1Qsk8wuxn9m8qViQsTtmH40L
	 TqTOWLt2SU8/pf9GBI/pAlNHBNrKegCW1ew4J70n0u9N2ihX72eM34g3aoQp1tso1K
	 o/y/wok3GArg7PRmyx+YdaXmNKllSpTzBQXsxq5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 368/556] media: i2c: vd55g1: Fix manual digital gain on color variant
Date: Wed,  9 Sep 2026 15:40:48 +0200
Message-ID: <20260909134243.627978378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Benjamin Mugnier <benjamin.mugnier@foss.st.com>

commit 113a84d6ba739d333eef2a595e3ccd4f97a306c2 upstream.

Apply digital gain to all channels, each channel representing a color.

Cc: stable@vger.kernel.org
Fixes: e138e7f00042 ("media: i2c: vd55g1: Add support for vd65g4 RGB variant")
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/vd55g1.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/vd55g1.c
+++ b/drivers/media/i2c/vd55g1.c
@@ -60,7 +60,10 @@
 #define VD55G1_PATGEN_ENABLE				BIT(0)
 #define VD55G1_REG_MANUAL_ANALOG_GAIN			CCI_REG8(0x0501)
 #define VD55G1_REG_MANUAL_COARSE_EXPOSURE		CCI_REG16_LE(0x0502)
-#define VD55G1_REG_MANUAL_DIGITAL_GAIN			CCI_REG16_LE(0x0504)
+#define VD55G1_REG_MANUAL_DIGITAL_GAIN_CH0		CCI_REG16_LE(0x0504)
+#define VD55G1_REG_MANUAL_DIGITAL_GAIN_CH1		CCI_REG16_LE(0x0506)
+#define VD55G1_REG_MANUAL_DIGITAL_GAIN_CH2		CCI_REG16_LE(0x0508)
+#define VD55G1_REG_MANUAL_DIGITAL_GAIN_CH3		CCI_REG16_LE(0x050a)
 #define VD55G1_REG_APPLIED_COARSE_EXPOSURE		CCI_REG16_LE(0x00e8)
 #define VD55G1_REG_APPLIED_ANALOG_GAIN			CCI_REG16_LE(0x00ea)
 #define VD55G1_REG_APPLIED_DIGITAL_GAIN			CCI_REG16_LE(0x00ec)
@@ -850,9 +853,16 @@ static int vd55g1_update_expo_cluster(st
 		vd55g1_write(sensor, VD55G1_REG_MANUAL_ANALOG_GAIN,
 			     sensor->again_ctrl->val, &ret);
 
-	if (!is_auto && sensor->dgain_ctrl->is_new)
-		vd55g1_write(sensor, VD55G1_REG_MANUAL_DIGITAL_GAIN,
+	if (!is_auto && sensor->dgain_ctrl->is_new) {
+		vd55g1_write(sensor, VD55G1_REG_MANUAL_DIGITAL_GAIN_CH0,
 			     sensor->dgain_ctrl->val, &ret);
+		vd55g1_write(sensor, VD55G1_REG_MANUAL_DIGITAL_GAIN_CH1,
+			     sensor->dgain_ctrl->val, &ret);
+		vd55g1_write(sensor, VD55G1_REG_MANUAL_DIGITAL_GAIN_CH2,
+			     sensor->dgain_ctrl->val, &ret);
+		vd55g1_write(sensor, VD55G1_REG_MANUAL_DIGITAL_GAIN_CH3,
+			     sensor->dgain_ctrl->val, &ret);
+	}
 
 	return ret;
 }


