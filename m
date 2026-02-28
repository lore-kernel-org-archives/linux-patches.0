Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9167E379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301928; cv=none; b=nkriuYE78OIm/0WXux2GOJDaTvg6co3nQzkkAYpLTDiwotzkiQaytFrL6/h7VipTZZ1Tyupn8+I48uu1KFfM04gqaMmvcdRNnIUEmBY9ppxePnOGlmvFeMiBNTMDYSI0cOIK8n0+Hiq8A79Z1txlUP61wwwFLbg+W4E+AhDTar0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301928; c=relaxed/simple;
	bh=0eUO4yL3RN1SAa3yHkMnfieKLsulvgQ1lrTO5z78cMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHmRCadxUZLMSypWJKPvM4FaQ9kBBPrdPF63jp3+3jOv0YeFDYNHQQnkh8tjihEgMud2UMyLMrYT7bRE7KqOkmLKAXD0ohtCcUATZRcMz/wbnD1i/vY8qPMbjRiWJ7M1UZFBRkeeVlEm7gstIIThlcbu2v7IXE9LILFNgXhVf4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrbxeqkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrbxeqkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03334C19423;
	Sat, 28 Feb 2026 18:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301928;
	bh=0eUO4yL3RN1SAa3yHkMnfieKLsulvgQ1lrTO5z78cMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrbxeqkA1nJqQ9VfrKTVNIrueldZIqIX60QjAS6tIpyzwbKQGljQpt90ZDRnBZilE
	 Hq6WDIS8df7YLsALiUrgReiEcKSgSACRL0TZrvy2Jbm39PoLs+TgyqM13X1NsvCRWU
	 WNMFjyp/7zTCmU8aCNlTzembsp9uVpK5GALksyA9bcQs2ZRaw611BhBfb5+G5RaCcb
	 oc0ML9hEgQtQ37WuEG1Wo5ldLX5EsDJT3ysbm4rRqzltluOBXW/NOXlxQwFHLclNy/
	 DgWHJxJW/vMpgTCcF3Se1ORkuB9OD2XDAG3zu5rWqaOGQBPMD5lU0LBae+pVKnsLg2
	 exZbLSjQHhxCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhai Can <bczhc0@126.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/385] ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO
Date: Sat, 28 Feb 2026 12:59:45 -0500
Message-ID: <20260228180011.1568201-363-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhai Can <bczhc0@126.com>

[ Upstream commit cd7ef20ba8c6e936dba133b4136537a8ada22976 ]

On the THUNDEROBOT ZERO laptop, the second NVMe slot and the discrete
NVIDIA GPU are both controlled by power-resource PXP. Due to the SSDT table
bug (lack of reference), PXP will be shut dow as an "unused" power resource
during initialization, making the NVMe slot #2 + NVIDIA both inaccessible.

This issue was introduced by commit a1224f34d72a ("ACPI: PM: Check
states of power resources during initialization"). Here are test
results on the three consecutive commits:

(bad again!) a1224f34d72a ACPI: PM: Check states of power resources during initialization
(good) bc2836859643 ACPI: PM: Do not turn off power resources in unknown state
(bad) 519d81956ee2 Linux 5.15-rc6

On commit bc2836859643 ("ACPI: PM: Do not turn off power resources in
unknown state") this was not an issue because the power resource state
left UNKNOWN thus being ignored.

See also commit 9b04d99788cf ("ACPI: PM: Do not turn of unused power
resources on the Toshiba Click Mini") which is another almost identical
case to this one.

Fixes: a1224f34d72a ("ACPI: PM: Check states of power resources during initialization")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221087
Signed-off-by: Zhai Can <bczhc0@126.com>
Link: https://patch.msgid.link/20260214161452.2849346-1-bczhc0@126.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index c2c70139c4f1d..ff5fcd541e50f 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1035,6 +1035,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE Click Mini L9W-B"),
 		},
 	},
+	{
+		/*
+		 * THUNDEROBOT ZERO laptop: Due to its SSDT table bug, power
+		 * resource 'PXP' will be shut down on initialization, making
+		 * the NVMe #2 and the NVIDIA dGPU both unavailable (they're
+		 * both controlled by 'PXP').
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "THUNDEROBOT"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZERO"),
+		}
+
+	},
 	{}
 };
 
-- 
2.51.0

