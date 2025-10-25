Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597903054C4;
	Sat, 25 Oct 2025 16:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408948; cv=none; b=B9Vz3C3qHSHtGd2SvN+UcdkRolQDBqvMVr598BiC+6TMI/VrQIRYdnUyuwstHkdWq6sBv2XBjnLJQwN7mRbY8PVmK4OrHBu4e2RhyioH9LJ2d0mJEgJ/aAC+BbpIB6wT2iVKKlTuNP0YSJ51Go6y67w978tZCaq/BQMNlKyBACc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408948; c=relaxed/simple;
	bh=+OIdQ4Hc6oYcoE26VvdOeu32D5owDzXMk0jYJxmpv9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RbYom4sfaxciMbsJdA4gjUTNYIcCDB5VVwL57a9Y2WGJlM3h8ZzaHgmXWaA2iqPjq693aZoR365chaTNQQ+QLxIQ5AUxg253/ntEBkDC2B4QU1PLycRoGvcxSqNB5eGDzJeKEA1jGn9e61DaviM9eAg+tvAn3znPoOVb6NUqN70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjlyuzU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjlyuzU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C341C116B1;
	Sat, 25 Oct 2025 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408948;
	bh=+OIdQ4Hc6oYcoE26VvdOeu32D5owDzXMk0jYJxmpv9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjlyuzU3wj3po0uY0OqpLSrEwMTvG7mIN/6ERh+sifFFsmAToKcCqaRo3DO5OrOjj
	 knenos/qVck+/vKwRUdMJVPFvDNHhgA0lnHLrS0htSumbJeK8rfcEmvUZauqGtiRNH
	 r3Z1wuAFmiDVstmR1OUH1xQD0Rtr+mY3ttGlzY9B+iW6Zdaf2xzslH9IdN+tBiPK5+
	 QYvRuA9jKVRuBa+zR9w+kt1xVEasAs8kgHczqksrPRXp1M/Bye1PdvsdaYsr2wi+zN
	 GN7XHUbTY+/blio9GwwfmhxLZ3pzQjLHwTAcs2ply/j+rd0HeAlFrZ33nu8FNJ/cym
	 PRDEtIsFQfpyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	moti.haimovski@intel.com,
	lukas@wunner.de,
	ariel.suller@intel.com,
	thorsten.blum@linux.dev,
	sharley.calzolari@intel.com
Subject: [PATCH AUTOSEL 6.17-6.6] accel/habanalabs/gaudi2: read preboot status after recovering from dirty state
Date: Sat, 25 Oct 2025 11:56:16 -0400
Message-ID: <20251025160905.3857885-145-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Sinyuk <konstantin.sinyuk@intel.com>

[ Upstream commit a0d866bab184161ba155b352650083bf6695e50e ]

Dirty state can occur when the host VM undergoes a reset while the
device does not. In such a case, the driver must reset the device before
it can be used again. As part of this reset, the device capabilities
are zeroed. Therefore, the driver must read the Preboot status again to
learn the Preboot state, capabilities, and security configuration.

Signed-off-by: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The new retry at `drivers/accel/habanalabs/gaudi2/gaudi2.c:3508`
  ensures `hl_fw_read_preboot_status()` is run again immediately after a
  dirty-state recovery reset; without it, the reset leaves the device’s
  preboot capability registers cleared, so the driver would continue
  with stale or zeroed security/capability data and fail to bring the
  card back after a host-only reboot (the scenario described in the
  commit message).
- `hl_fw_read_preboot_status()` repopulates `asic_prop` fields such as
  `fw_preboot_cpu_boot_dev_sts[01]`, `dynamic_fw_load`, and
  `fw_security_enabled`
  (`drivers/accel/habanalabs/common/firmware_if.c:1564-1605`); these
  values are what the rest of initialization uses to pick the firmware
  loading path and security posture, so skipping the re-read after
  `hw_fini()` leads directly to broken or insecure configuration on the
  recovered device.
- The change is tightly scoped to the Gaudi2 early-init dirty-path,
  reuses the existing error handling (`goto pci_fini;` and the
  `reset_on_preboot_fail` guard), and does not touch unrelated
  subsystems, so regression risk is minimal while it fixes a real user-
  visible recovery bug.

 drivers/accel/habanalabs/gaudi2/gaudi2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2.c b/drivers/accel/habanalabs/gaudi2/gaudi2.c
index 5722e4128d3ce..3df72a5d024a6 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -3150,7 +3150,6 @@ static int gaudi2_early_init(struct hl_device *hdev)
 	rc = hl_fw_read_preboot_status(hdev);
 	if (rc) {
 		if (hdev->reset_on_preboot_fail)
-			/* we are already on failure flow, so don't check if hw_fini fails. */
 			hdev->asic_funcs->hw_fini(hdev, true, false);
 		goto pci_fini;
 	}
@@ -3162,6 +3161,13 @@ static int gaudi2_early_init(struct hl_device *hdev)
 			dev_err(hdev->dev, "failed to reset HW in dirty state (%d)\n", rc);
 			goto pci_fini;
 		}
+
+		rc = hl_fw_read_preboot_status(hdev);
+		if (rc) {
+			if (hdev->reset_on_preboot_fail)
+				hdev->asic_funcs->hw_fini(hdev, true, false);
+			goto pci_fini;
+		}
 	}
 
 	return 0;
-- 
2.51.0

