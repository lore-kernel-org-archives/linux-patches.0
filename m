Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A1E1DF271;
	Tue,  8 Oct 2024 12:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391526; cv=none; b=IcvYF0/u6Q0qSsItZ/UCZ8EeitPIDVsFyfavASKt9TabceSaR7bF3u/LMxf7UB7dQ3JeEjxegSuKgsveJKz1nlFoRutcVRkMRaiGYQJim970IHxX/AifQc+G3jiCPiSl20wyYltbC3y4CEOhbCNso8ACWzcnDGIzAOi6KNW0iag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391526; c=relaxed/simple;
	bh=Hl1Hai2cUKTQkl2iqYODg/xmtq2HQPVrp99v8D0UcBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHqyIDEsvhr8fe+A8Z6Q4FhCWzPeUqy15QVa8WZoH1W5dE6IRYBssa4WGMtnOeZDuv1k11o1FPClyOiOEpulqX1YKygADS5H2xYwFCOaekUcvYZ5KexdX82QIgmclFDf1JZhD/TDqG8zyNy6I31CQK69/GD6IjEAMG8HcpD+Lq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHq7ER3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHq7ER3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FE2C4CEC7;
	Tue,  8 Oct 2024 12:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391526;
	bh=Hl1Hai2cUKTQkl2iqYODg/xmtq2HQPVrp99v8D0UcBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHq7ER3D0a7lK2aOmQCSh/JrXuDm21Afm3QvbkQhXf7JJiDgclCYUTBqasy3QoSmw
	 U7uuSj4vy/+1/0iheFL7ZY8L6AMcqyfuHgivzIMfJ8Es55DAg7a062ay1TWn1YVgx2
	 PD2fFOnpYHJZXYtq7TpBS+06gJ3jW4541H87KG0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 110/558] ACPI: video: Add force_vendor quirk for Panasonic Toughbook CF-18
Date: Tue,  8 Oct 2024 14:02:20 +0200
Message-ID: <20241008115706.695077960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eb7b0f12e13ba99e64e3a690c2166895ed63b437 ]

The Panasonic Toughbook CF-18 advertises both native and vendor backlight
control interfaces. But only the vendor one actually works.

acpi_video_get_backlight_type() will pick the non working native backlight
by default, add a quirk to select the working vendor backlight instead.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240907124419.21195-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 75a5f559402f8..428a7399fe04a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -254,6 +254,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "PCG-FRV35"),
 		},
 	},
+	{
+	 .callback = video_detect_force_vendor,
+	 /* Panasonic Toughbook CF-18 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Matsushita Electric Industrial"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
+		},
+	},
 
 	/*
 	 * Toshiba models with Transflective display, these need to use
-- 
2.43.0



