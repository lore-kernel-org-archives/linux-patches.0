Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4719779C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3FAC433C1;
	Wed, 30 Nov 2022 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833822;
	bh=7bxahGR5cIK6Bw34SpYKQcIlMTHfdqeFt+yN+vvop0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZFR9uzjpxZYDwUKayQE4CuoK+PDZVVVc1XffAq+cj3suByV1gwwjU9qNUGSouwAB
	 1nLOySefPI3qtTAKQAH0t0Ud4PJS9/faiRVBCNskDRgotsjTItX0c6pp4ab3QgHaxx
	 5sjZQmyB6uD6C40mIi4qdgtXPWyBKxjUzSQ8gato=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iris <pawel.js@protonmail.com>,
	Daniel Dadap <ddadap@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 019/289] ACPI: video: Add backlight=native DMI quirk for Dell G15 5515
Date: Wed, 30 Nov 2022 19:20:04 +0100
Message-Id: <20221130180544.568582889@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f46acc1efd4b5846de9fa05f966e504f328f34a6 ]

The Dell G15 5515 has the WMI interface (and WMI call returns) expected
by the nvidia-wmi-ec-backlight interface. But the backlight class device
registered by the nvidia-wmi-ec-backlight driver does not actually work.

The amdgpu_bl0 native GPU backlight class device does actually work,
add a backlight=native DMI quirk for this.

Reported-by: Iris <pawel.js@protonmail.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 68a566f69684..aae9261c424a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -578,6 +578,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
 		},
 	},
+	/*
+	 * Models which have nvidia-ec-wmi support, but should not use it.
+	 * Note this indicates a likely firmware bug on these models and should
+	 * be revisited if/when Linux gets support for dynamic mux mode.
+	 */
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell G15 5515 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5515"),
+		},
+	},
+
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
-- 
2.35.1



