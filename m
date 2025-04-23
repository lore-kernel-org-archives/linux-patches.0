Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B80F27FD49;
	Wed, 23 Apr 2025 14:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419671; cv=none; b=mA8lDwyrgtMntLQQK3yL4cIcc94NjQQMI2LPaOTFL0j4Do+vzC3nHYXQ6jJ5nBJOVyq46Ud5KIe5tKiSNIAcuWeq332429sbHgG3GWojI7NQ80HvpX3zOEvr0t8gHBRC40amz1TQiaQSwLQ572KE7nCpVeZLvyyFq5LeAE9mSxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419671; c=relaxed/simple;
	bh=VCp18VQOxF+4MjmKg2WnX8A8JuvmjYx4mA5vY1tnHcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dK8eRnJ7R36kIUB9GQshew5CObTykdIp7Zvqd2vZ1j3cS0YBL31r3uaMzl8R+T9UEKI+YHLSveCRE4dE0vmaVibRusGcaQJPCgsw/Uoid49XlagWkvsUeRBGSSdzvm3omAyhxJZSJYXCuYROLICv26W984Fcgr+kW1Dqa1Lfp2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNEo+Gn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNEo+Gn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C93CC4CEE3;
	Wed, 23 Apr 2025 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419671;
	bh=VCp18VQOxF+4MjmKg2WnX8A8JuvmjYx4mA5vY1tnHcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNEo+Gn0yTIpTigkcoGaaJJmH31ypKdK4G0+RccEGWX101JI05IBqeerQqHP5quVr
	 Qodo+H/klebogyDKY1lmQloEyfJj5DQAwktMsujy9/1MrzU1JrhF8+XoqYPJEEQoH5
	 0somsr208gGZJm64E6CCTfRXnTgyYxy2WWGAdZaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 005/241] wifi: brcmfmac: fix memory leak in brcmf_get_module_param
Date: Wed, 23 Apr 2025 16:41:09 +0200
Message-ID: <20250423142620.745657715@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 9e935c0fe3f806ff700a804c00832f0f340b6061 ]

The memory allocated for settings is not freed when brcmf_of_probe
fails. Fix that by freeing settings before returning in error path.

Fixes: 0ff0843310b7 ("wifi: brcmfmac: Add optional lpo clock enable support")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20250330103425.44197-1-abdun.nihaal@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index cfcf01eb0daa5..f26e4679e4ff0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -561,8 +561,10 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 	if (!found) {
 		/* No platform data for this device, try OF and DMI data */
 		brcmf_dmi_probe(settings, chip, chiprev);
-		if (brcmf_of_probe(dev, bus_type, settings) == -EPROBE_DEFER)
+		if (brcmf_of_probe(dev, bus_type, settings) == -EPROBE_DEFER) {
+			kfree(settings);
 			return ERR_PTR(-EPROBE_DEFER);
+		}
 		brcmf_acpi_probe(dev, bus_type, settings);
 	}
 	return settings;
-- 
2.39.5



