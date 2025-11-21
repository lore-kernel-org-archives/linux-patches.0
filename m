Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503071B4F0A;
	Fri, 21 Nov 2025 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731500; cv=none; b=P+p3R2ALO8RkJJ4gaQE7ffGMaNS9UxcglKzu/TueeOyjVJVemEx8amS0EQKb6L1VLjkrOtpZMgnMk5otpRHhoF6NQYWxqt44qnelJAXnmrRV+kfDg9/B84f4ziZ7b0ydyRJ6ETiynym5aE06YHt6Z25aPIU4s8C0W+cLZYEPSIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731500; c=relaxed/simple;
	bh=1UuT8BOc6z+EJUBmYje4x+f5IgaKElvpPyfJMwveWYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww7As9QX2KAuAJo9bMZxOykfgB708et8amGk+nVUkYtt2Jyuo1Rtwo6XG8pK0ay8rTs5RlxUiJoYPPfCJeXidEZEdfgBL0arq33qO/MFTYaevkaMAORL+rBvbssUeSoywkio/CJPCKBSjpKMgWfKsUCwSQLMeDDRoPI+OPHYRss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4/wOuIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4/wOuIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C625CC4CEF1;
	Fri, 21 Nov 2025 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731500;
	bh=1UuT8BOc6z+EJUBmYje4x+f5IgaKElvpPyfJMwveWYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4/wOuIQ+W+qrO/KSdhP+MnWgcaFsfqyViLIxEz1ZY5FbgilO2lDAUkScp1quiRO2
	 FYdqcBCGJNGCwFpKCHPkzUuIijO1vir6a2HEeYxQe2eXCTf3VDiZnJAg3HX6MFc7nf
	 uh2Bo/9cbChRRngDCkXul7Cq1cLooxWfozFksHUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 195/247] ASoC: sdw_utils: fix device reference leak in is_sdca_endpoint_present()
Date: Fri, 21 Nov 2025 14:12:22 +0100
Message-ID: <20251121130201.722426143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 1a58d865f423f4339edf59053e496089075fa950 upstream.

The bus_find_device_by_name() function returns a device pointer with an
incremented reference count, but the original code was missing put_device()
calls in some return paths, leading to reference count leaks.

Fix this by ensuring put_device() is called before function exit after
  bus_find_device_by_name() succeeds

This follows the same pattern used elsewhere in the kernel where
bus_find_device_by_name() is properly paired with put_device().

Found via static analysis and code review.

Fixes: 4f8ef33dd44a ("ASoC: soc_sdw_utils: skip the endpoint that doesn't present")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://patch.msgid.link/20251029071804.8425-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1239,7 +1239,7 @@ static int is_sdca_endpoint_present(stru
 	struct sdw_slave *slave;
 	struct device *sdw_dev;
 	const char *sdw_codec_name;
-	int i;
+	int ret, i;
 
 	dlc = kzalloc(sizeof(*dlc), GFP_KERNEL);
 	if (!dlc)
@@ -1269,13 +1269,16 @@ static int is_sdca_endpoint_present(stru
 	}
 
 	slave = dev_to_sdw_dev(sdw_dev);
-	if (!slave)
-		return -EINVAL;
+	if (!slave) {
+		ret = -EINVAL;
+		goto put_device;
+	}
 
 	/* Make sure BIOS provides SDCA properties */
 	if (!slave->sdca_data.interface_revision) {
 		dev_warn(&slave->dev, "SDCA properties not found in the BIOS\n");
-		return 1;
+		ret = 1;
+		goto put_device;
 	}
 
 	for (i = 0; i < slave->sdca_data.num_functions; i++) {
@@ -1284,7 +1287,8 @@ static int is_sdca_endpoint_present(stru
 		if (dai_type == dai_info->dai_type) {
 			dev_dbg(&slave->dev, "DAI type %d sdca function %s found\n",
 				dai_type, slave->sdca_data.function[i].name);
-			return 1;
+			ret = 1;
+			goto put_device;
 		}
 	}
 
@@ -1292,7 +1296,11 @@ static int is_sdca_endpoint_present(stru
 		"SDCA device function for DAI type %d not supported, skip endpoint\n",
 		dai_info->dai_type);
 
-	return 0;
+	ret = 0;
+
+put_device:
+	put_device(sdw_dev);
+	return ret;
 }
 
 int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,


