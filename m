Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4E824BBEC;
	Fri, 31 Oct 2025 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919571; cv=none; b=i0YoLUrElooN2cTiCWwzE7XslQRKQuDbxV6HEAtHfkvcm/bYRxD4yZNJsBQm3xjL/ZgCAF7jJBd4Yfj/Z9l5RJ3BExyI+cRdHgmUHAcA9Wwl+XfEipsPHVoKyrTMH+uU1EWpCkfwEkHXV6A7NA43s/8fpRC48sevL4SKCCznHWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919571; c=relaxed/simple;
	bh=EIaGQ4Ryg1VgXOGYzcvslw2EpdG0Q/75eNRExWTkl9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pq6BlRje6EnENTji9nK6nsuFRqjV/LCZqVh1qB0YN+AZFw3rK84p0n5EqjlexsY6uir4MnHnDmy8mH9UkH0Q0NPAIBMiPzpVEsIJa1zwh3PZO6qFLuProaKIQ2ePwqVa6/7pZnUf3bk6l+8FEViG86EV7XsfymlAkwILg2caRUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9jj3Ywu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9jj3Ywu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B65EC4CEF8;
	Fri, 31 Oct 2025 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919570;
	bh=EIaGQ4Ryg1VgXOGYzcvslw2EpdG0Q/75eNRExWTkl9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9jj3Ywu6OIvBiN8+uQ2Uy91dHucvZbB0DNtrbdPliLEP+oQkWZ3Zqf/uQ8/q+2d4
	 6xBhImbXTb81gNjrJxPgXEudRaBFzrzJ1/vY/7mPvbufVjLa9LBnHHu2uMCJiQ+ir1
	 nRX2cZni/kKtfqIiyIyp21OHs4MRkiDOD0KjdpTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 22/35] EDAC/mc_sysfs: Increase legacy channel support to 16
Date: Fri, 31 Oct 2025 15:01:30 +0100
Message-ID: <20251031140044.099100370@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0f338adf7d937..8689631f19053 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -305,6 +305,14 @@ DEVICE_CHANNEL(ch10_dimm_label, S_IRUGO | S_IWUSR,
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
@@ -320,6 +328,10 @@ static struct attribute *dynamic_csrow_dimm_attr[] = {
 	&dev_attr_legacy_ch9_dimm_label.attr.attr,
 	&dev_attr_legacy_ch10_dimm_label.attr.attr,
 	&dev_attr_legacy_ch11_dimm_label.attr.attr,
+	&dev_attr_legacy_ch12_dimm_label.attr.attr,
+	&dev_attr_legacy_ch13_dimm_label.attr.attr,
+	&dev_attr_legacy_ch14_dimm_label.attr.attr,
+	&dev_attr_legacy_ch15_dimm_label.attr.attr,
 	NULL
 };
 
@@ -348,6 +360,14 @@ DEVICE_CHANNEL(ch10_ce_count, S_IRUGO,
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
@@ -363,6 +383,10 @@ static struct attribute *dynamic_csrow_ce_count_attr[] = {
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



