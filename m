Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C2D3563D0;
	Wed,  3 Dec 2025 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778695; cv=none; b=oCBIKVZ9YGRgE9n760Q3clRrLeX9C7acM/6SrGUztMNLmxJjrXri+9onPWBFofiVkXYeKEAn/2cgNZdSutGMXhYhUZ/YR62S4zN0Vf4wzINsQJ7KJZGLpJW297m7TArt+/7CuGd43gwW5wKEZ74LrkZDD4bNpojSEXyktZxqJUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778695; c=relaxed/simple;
	bh=2CN5ixrYm5PR6fafwEVcELawZZkZ7qeIuJZZI5xvLlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPNxKuOlwXbKFEbwYaKXrCEyk7/LBb/TuChUSLRW7IWnKO3rajTOPE2Ju93+1ctjFDPdaQ24bqC2jkWesFtcE8TPGV2uBvh4Xr3PEArcrDMV3kwtm2C5ff06ZwQpfp6Jtne0gmk9oan8vxoKSRhVffNV1Ra44qxdz2GE+vbOWBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yE9N8rui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yE9N8rui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C00C4CEF5;
	Wed,  3 Dec 2025 16:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778695;
	bh=2CN5ixrYm5PR6fafwEVcELawZZkZ7qeIuJZZI5xvLlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE9N8ruiho/aUcqf0w2p1Enf9/Zdlfi0lO3SfcI+tvsc2FRJYBcntL3Cuh4V3EOLy
	 vZLszoimBjInk8beDQD8C0AGIKmc9TAAuXKrjMZzd1QHlPfOCFcTtpQKZG+iq4ULex
	 YItDh+s+NRDg5WwmvKy6F8nN12OUUl7aWVo3+mrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/568] EDAC/mc_sysfs: Increase legacy channel support to 16
Date: Wed,  3 Dec 2025 16:20:06 +0100
Message-ID: <20251203152440.817451816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avadhut Naik <avadhut.naik@amd.com>

[ Upstream commit 6e1c2c6c2c40ce99e0d2633b212f43c702c1a002 ]

Newer AMD systems can support up to 16 channels per EDAC "mc" device.
These are detected by the EDAC module running on the device, and the
current EDAC interface is appropriately enumerated.

The legacy EDAC sysfs interface however, provides device attributes for
channels 0 through 11 only. Consequently, the last four channels, 12
through 15, will not be enumerated and will not be visible through the
legacy sysfs interface.

Add additional device attributes to ensure that all 16 channels, if
present, are enumerated by and visible through the legacy EDAC sysfs
interface.

Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250916203242.1281036-1-avadhut.naik@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc_sysfs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 15f63452a9bec..b01436d9ddaed 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -306,6 +306,14 @@ DEVICE_CHANNEL(ch10_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 10);
 DEVICE_CHANNEL(ch11_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 11);
+DEVICE_CHANNEL(ch12_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 12);
+DEVICE_CHANNEL(ch13_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 13);
+DEVICE_CHANNEL(ch14_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 14);
+DEVICE_CHANNEL(ch15_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 15);
 
 /* Total possible dynamic DIMM Label attribute file table */
 static struct attribute *dynamic_csrow_dimm_attr[] = {
@@ -321,6 +329,10 @@ static struct attribute *dynamic_csrow_dimm_attr[] = {
 	&dev_attr_legacy_ch9_dimm_label.attr.attr,
 	&dev_attr_legacy_ch10_dimm_label.attr.attr,
 	&dev_attr_legacy_ch11_dimm_label.attr.attr,
+	&dev_attr_legacy_ch12_dimm_label.attr.attr,
+	&dev_attr_legacy_ch13_dimm_label.attr.attr,
+	&dev_attr_legacy_ch14_dimm_label.attr.attr,
+	&dev_attr_legacy_ch15_dimm_label.attr.attr,
 	NULL
 };
 
@@ -349,6 +361,14 @@ DEVICE_CHANNEL(ch10_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 10);
 DEVICE_CHANNEL(ch11_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 11);
+DEVICE_CHANNEL(ch12_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 12);
+DEVICE_CHANNEL(ch13_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 13);
+DEVICE_CHANNEL(ch14_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 14);
+DEVICE_CHANNEL(ch15_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 15);
 
 /* Total possible dynamic ce_count attribute file table */
 static struct attribute *dynamic_csrow_ce_count_attr[] = {
@@ -364,6 +384,10 @@ static struct attribute *dynamic_csrow_ce_count_attr[] = {
 	&dev_attr_legacy_ch9_ce_count.attr.attr,
 	&dev_attr_legacy_ch10_ce_count.attr.attr,
 	&dev_attr_legacy_ch11_ce_count.attr.attr,
+	&dev_attr_legacy_ch12_ce_count.attr.attr,
+	&dev_attr_legacy_ch13_ce_count.attr.attr,
+	&dev_attr_legacy_ch14_ce_count.attr.attr,
+	&dev_attr_legacy_ch15_ce_count.attr.attr,
 	NULL
 };
 
-- 
2.51.0



