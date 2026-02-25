Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCDF30E855;
	Wed, 25 Feb 2026 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002707; cv=none; b=KhPMJubmJwnI3PGvo5vnU2vdUZwWRACYyWuOXGk6sEwUprqmxrXc6q6wZ5zqLcwQFFJxDT0coIXnAKZ8neew6TFwoK1zShZSBR3OMOShHOg8TurGJp6JdBLJvVnjXtPFEis04kKGsaPY5tBFXjLMEBbjhjyk8b/DF2w2FFeJyZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002707; c=relaxed/simple;
	bh=gxF+QLsVOPdiDd90odlSHwXsHLcD5YJVQxvmHuAogLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgWEQsRkJ8YyDPBngeoQOp4ti+RabLrI23/4pCPcSo+Ff9UONmXkbB0NSkSuk/7/pxoH89bBIw7Wo/73iTZxS3q48t8ddS7hf5K+dxk7e7OQfW6BSPRbABlLiw9pJhCskZY2MgR7fK4rPbMOdKNzBqQQw6d86AUj0/+XgBdfY+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImGIC1yG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImGIC1yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72DCC116D0;
	Wed, 25 Feb 2026 06:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002707;
	bh=gxF+QLsVOPdiDd90odlSHwXsHLcD5YJVQxvmHuAogLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImGIC1yGhqgNvPfS0mEN4l+4RaPehCixDNfVEIEdDq++RCc97PztrybvKXNIfofnA
	 DyJSjt/Fk+a1Jh0mRywAjrbQ2b09p3/mVD9DBTv57Xu4oA+Y3RQeKfXluYVP0fYaLA
	 YlLnSnDYObVoHtlt0hSDs5C+g2AcXs9Q/ojXgk9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhai Can <bczhc0@126.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 508/641] ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO
Date: Tue, 24 Feb 2026 17:23:54 -0800
Message-ID: <20260225012400.834606110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



