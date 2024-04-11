Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18076BB29;
	Thu, 11 Apr 2024 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832336; cv=none; b=NMML8M1bjgU0COVqlxN+QFinhkkzyGxrrHuDklJOsImF3/rESmvEuuPnKuomoqCTcHE5monx8ScBR7XnU3gztNULiSOi2ITKiLOBse8S5zBzy4Q939/ekYy2dwHyxumjcTHzMFDtTNSM6gWthjwgJ1VWIlFjDhG+1aB+pHe5bTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832336; c=relaxed/simple;
	bh=QXotESlx31SMtgGDy7D5Ve8+9OF0e1XHdHuuzKkEjzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy6qXWM7dHWV+dYOAZjTb7OF9hlLG0f6GPooWVdNvZbSAeTOGVhjTKYaOn4hXeNqe7w42pCuTpMqoEEKnCbe2+oyvs3Uq9izOdHp4uM2NTEzXWBwBUmRfBYNSy9WeoNEPEBlzrSOuRlCA90WRTIWDLMpCih5SdNLtquTqwhi9yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8E+TKjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8E+TKjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444A8C433C7;
	Thu, 11 Apr 2024 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832336;
	bh=QXotESlx31SMtgGDy7D5Ve8+9OF0e1XHdHuuzKkEjzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8E+TKjyFtLg03WHhh1apWf+HLFleEdPaDi4xxnzuTjPPOzOIprdGh7QOONb6Wy8R
	 YISdJDM0VeKW2TdJmLjhs0BAkCShkfZbyUfIQJ+xBMez3j3P00TWqq4f/6dTtsKkRm
	 TYFQaQgUAz2mqWkZCJUI+i0Es5uH97jaE83lCTB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/83] wifi: brcmfmac: Add DMI nvram filename quirk for ACEPC W5 Pro
Date: Thu, 11 Apr 2024 11:56:47 +0200
Message-ID: <20240411095413.136420979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 32167707aa5e7ae4b160c18be79d85a7b4fdfcfb ]

The ACEPC W5 Pro HDMI stick contains quite generic names in the sys_vendor
and product_name DMI strings, without this patch brcmfmac will try to load:
"brcmfmac43455-sdio.$(DEFAULT_STRING)-$(DEFAULT_STRING).txt" as nvram file
which is both too generic and messy with the $ symbols in the name.

The ACEPC W5 Pro uses the same Ampak AP6255 module as the ACEPC T8
and the nvram for the T8 is already in linux-firmware, so point the new
DMI nvram filename quirk to the T8 nvram file.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240216213649.251718-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 86ff174936a9a..c3a602197662b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -82,6 +82,15 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&acepc_t8_data,
 	},
+	{
+		/* ACEPC W5 Pro Cherry Trail Z8350 HDMI stick, same wifi as the T8 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "3"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
+		},
+		.driver_data = (void *)&acepc_t8_data,
+	},
 	{
 		/* Chuwi Hi8 Pro with D2D3_Hi8Pro.233 BIOS */
 		.matches = {
-- 
2.43.0



