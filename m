Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AD26CE1A;
	Wed, 25 Feb 2026 01:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983522; cv=none; b=ccVZBZMi2l0P6Qu6zSNJD6QzJRdDn4diG/I4V/QP3Ngrmk2LfE+DkdLpdvhY2TvYO9BfYiwUABF6gmpECTre+K46B2SkNCDprF7tFKhfYcJLpkPa52wMr4Iqi5ENJPwSrY4b/C8zvYa+8RDXT6RaPAudlOZaTaokRVTsb/h1SB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983522; c=relaxed/simple;
	bh=ZzZ9VdaTcSLkKDcD8fzzv5/eTi/iDp6hyVAj0HDV+vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPoB9kMMGZJj09leINJEUvLO3NiX2cVbp/MwH5ECGgYJXM7kcw0BWRCwiYyE3WQYDTwvnXiBcelHQuGOHq0miFdIevi/Ig6NKAI2mcfiA963GOklg4RTJei3LilU8triRII2WT7UrKPYXt55Dcu28gx+I4zi+AvObJnDXJpwi8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1C4U/HIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1C4U/HIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5476C116D0;
	Wed, 25 Feb 2026 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983522;
	bh=ZzZ9VdaTcSLkKDcD8fzzv5/eTi/iDp6hyVAj0HDV+vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C4U/HIpU91OC+WvpxJx7BvzJdtPGTUaTOp5I6KQYveQZ6T664ksKeojZ7rMyZzYI
	 pIS8megjwc3bqTF+K45Wd/XhWEaR2b+mJrnZmy+JVtz1H1tsh/FH6OpRhJU1LCk0lL
	 yh32AZsAX47NTF1sp/MpcQPzugYji0jNlcpsKxH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhai Can <bczhc0@126.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 630/781] ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO
Date: Tue, 24 Feb 2026 17:22:19 -0800
Message-ID: <20260225012415.262660062@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 361a7721a6a87..7da5ae5594a72 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1113,6 +1113,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
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



