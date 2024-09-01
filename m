Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D861E87B;
	Sun,  1 Sep 2024 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208462; cv=none; b=PD2JhinFSDYjDpNHjF5BW7YNLy4B0arnn3FqVMcAFwzGepan0yh/ZDepytPn/SLDYJbXdOohA6Whq2yCbR8hSJPUMDGzBXWCLRMgUem0kFzUt1kj1NrmAizNmF+TuPz5OxRLb8gpOlCJnGfI3ZO3XtUk9bEHcS3UnzEncrR1wtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208462; c=relaxed/simple;
	bh=VQBUEP1HTo6GNB2PK0P4RF7sTYIWZoG0gzyNgzCMbnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4ujrc17h+L6NdwVdjySsODuKkqlqBG1FqGjT2DRCBPQmlk57OGgSvPgsbz4wPkhm/SxLxiOSUrCPeedvuAVmT1x2tlrGIYiGbsKxueFbrZ0ANd/U9En3zi2Qe21eZtO78ShCtysvF+rRC8qQdgKSVO0tVt0M098/OapJ/N/wt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSI2PPA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSI2PPA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925A1C4CEC4;
	Sun,  1 Sep 2024 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208462;
	bh=VQBUEP1HTo6GNB2PK0P4RF7sTYIWZoG0gzyNgzCMbnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSI2PPA9GWnucH0eXZDfHH3fdttTEpVoh00xk5DaHLO4lXNmvvh2tqnYgWcXlJAme
	 bA2nUA4EL1thL2PFm5d/n4pPagx9usbwUGfE+NUYKFx7fxsbsIC62M3ziCD+/ViKJn
	 zXSZXB132lzFduiZeb9w8GJMq8hl5rQJSNJeEQh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 058/149] ASoC: cs-amp-lib: Ignore empty UEFI calibration entries
Date: Sun,  1 Sep 2024 18:16:09 +0200
Message-ID: <20240901160819.650972860@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit bb4485562f5907708f1c218b5d70dce04165d1e1 ]

If the timestamp of a calibration entry is 0 it is an unused entry and
must be ignored.

Some end-products reserve EFI space for calibration entries by shipping
with a zero-filled EFI file. When searching the file for calibration
data the driver must skip the empty entries. The timestamp of a valid
entry is always non-zero.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 1cad8725f2b9 ("ASoC: cs-amp-lib: Add helpers for factory calibration data")
Link: https://patch.msgid.link/20240822133544.304421-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs-amp-lib.c b/sound/soc/codecs/cs-amp-lib.c
index 605964af8afad..51b128c806718 100644
--- a/sound/soc/codecs/cs-amp-lib.c
+++ b/sound/soc/codecs/cs-amp-lib.c
@@ -182,6 +182,10 @@ static int _cs_amp_get_efi_calibration_data(struct device *dev, u64 target_uid,
 		for (i = 0; i < efi_data->count; ++i) {
 			u64 cal_target = cs_amp_cal_target_u64(&efi_data->data[i]);
 
+			/* Skip empty entries */
+			if (!efi_data->data[i].calTime[0] && !efi_data->data[i].calTime[1])
+				continue;
+
 			/* Skip entries with unpopulated silicon ID */
 			if (cal_target == 0)
 				continue;
@@ -193,7 +197,8 @@ static int _cs_amp_get_efi_calibration_data(struct device *dev, u64 target_uid,
 		}
 	}
 
-	if (!cal && (amp_index >= 0) && (amp_index < efi_data->count)) {
+	if (!cal && (amp_index >= 0) && (amp_index < efi_data->count) &&
+	    (efi_data->data[amp_index].calTime[0] || efi_data->data[amp_index].calTime[1])) {
 		u64 cal_target = cs_amp_cal_target_u64(&efi_data->data[amp_index]);
 
 		/*
-- 
2.43.0



