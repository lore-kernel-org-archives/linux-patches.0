Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC78347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302467; cv=none; b=ufMS0yqhyfECmeODWDx7X55OMdzi9m5R2rOlubPx/bLQzxHg5GtY8wkpbKj/8nnUZ8dSe18Y9Vdig5mnnFWU5JFW5HUfbDhWuoBk7cUynNAAq2XRYlOCxDZAlu+A2bqITXV4WcIXBtvbFlah7zv4qiiOx8mohHVD6vsNKhp3slY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302467; c=relaxed/simple;
	bh=ruqMQhFcB40l9ZH+6DumFxM9hFjBVf6JR38sTDWRS54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf2Uc3NqejIWwjcZoH2L5Pc6E9g9UufBK6y0svp/pFnn+wBWSA9GE6oHhb4GYYmcz6dB2fVvT2UOBGP7EkoS8yACEAUJQ2DBkBteahtHDBtg5xu/jMSHx20FFHW51I3tL20GvkNmipePNdcaSkitlA+Vd56gNjBL/FmIBXSGFsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEkeXg4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEkeXg4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E53EC116D0;
	Sat, 28 Feb 2026 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302467;
	bh=ruqMQhFcB40l9ZH+6DumFxM9hFjBVf6JR38sTDWRS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEkeXg4kaxFBSVPszSLjDygqC1SJILmm7/tRxC9YDA6pLhjxSGRznxoOpE0x9+Yfl
	 d6zNcbKw86hJpLfLbLp5zb1UcqHnK4pyl/NEgDvgyffkjTlRY3aFNvS3nNC8kSmxAD
	 eWg861dBJRltdyoxB4CHyFNOeISXg+J1wb/keCY2QiqhGW8Ph0z+T68L/HoNs18fdz
	 H8XFamo/yK6XLDHGMUo5MQxSOMGPKlGjc6Nt8rQgJfZgVE5ltZ7sAGf6rj2cFitBOD
	 maL1+p1LXfDJVao8jviJgpadlpLHf5yqL+KFzoqTlcpCzdRwb1/16re/SnkPkq4wxH
	 cPYmqOFtjat2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhai Can <bczhc0@126.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/232] ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO
Date: Sat, 28 Feb 2026 13:11:04 -0500
Message-ID: <20260228181127.1592657-211-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index aea8c994caeac..db7b5534931be 100644
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

