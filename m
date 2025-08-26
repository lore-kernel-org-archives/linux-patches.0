Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4F1A256B;
	Tue, 26 Aug 2025 11:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207491; cv=none; b=qADwJK1jpC9wgjwV+CDhxxJ6xE/gwwe4tuFLr2wX74Z04DgM8weeya4FeZi8HkzcZLEyEarNCvyFka9hX3Pwjrh9jc7TUOFEp8HoLBXPZdEUS5pOTBQapSEZWrhePh5q6eQDsBBfkZpDsASARRnef8hAWTEY/fgA/uaVYobbRJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207491; c=relaxed/simple;
	bh=yEahuuJM2GziV7Bd6WygUROaP8+XW3GwSLpZgeP05eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEmhPC3amyC+dFxMn1K0fSN1Zu7kKp0kLSD+w52BV1sQhVZolvXuwNkUvaDQ3V3wyn20VfOyQIlbRLR+mJ3twhLjFB8wkvFmc2H62nMOV7VFrDrOn/y6o5BauyDtJR6ZxVPsyJKrKKUvNxgyLt7HREqb82g65q70fCngECCNU34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yu+vzo5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yu+vzo5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709A4C4CEF4;
	Tue, 26 Aug 2025 11:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207491;
	bh=yEahuuJM2GziV7Bd6WygUROaP8+XW3GwSLpZgeP05eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yu+vzo5tc6+7fmmWSLAEw+r+kG/WJcSLFxV3DEQNhR5jsVKKw6CxkfBh6XdoNe+OC
	 Bp11jyr4q010/SfeycUUbzY3PTGxIETgBVRsR5ky6IGjuMiZimFfsa/AhBAF7Xk1ei
	 7mh4OLrBGcwMcfdUP5zLzglEtQ3YEPw8SyX/5E3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Govindarajulu, Hariganesh" <hariganesh.govindarajulu@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.16 202/457] ACPI: pfr_update: Fix the driver update version check
Date: Tue, 26 Aug 2025 13:08:06 +0200
Message-ID: <20250826110942.359023868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

commit 8151320c747efb22d30b035af989fed0d502176e upstream.

The security-version-number check should be used rather
than the runtime version check for driver updates.

Otherwise, the firmware update would fail when the update binary had
a lower runtime version number than the current one.

Fixes: 0db89fa243e5 ("ACPI: Introduce Platform Firmware Runtime Update device driver")
Cc: 5.17+ <stable@vger.kernel.org> # 5.17+
Reported-by: "Govindarajulu, Hariganesh" <hariganesh.govindarajulu@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Link: https://patch.msgid.link/20250722143233.3970607-1-yu.c.chen@intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/pfr_update.c  |    2 +-
 include/uapi/linux/pfrut.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -310,7 +310,7 @@ static bool applicable_image(const void
 	if (type == PFRU_CODE_INJECT_TYPE)
 		return payload_hdr->rt_ver >= cap->code_rt_version;
 
-	return payload_hdr->rt_ver >= cap->drv_rt_version;
+	return payload_hdr->svn_ver >= cap->drv_svn;
 }
 
 static void print_update_debug_info(struct pfru_updated_result *result,
--- a/include/uapi/linux/pfrut.h
+++ b/include/uapi/linux/pfrut.h
@@ -89,6 +89,7 @@ struct pfru_payload_hdr {
 	__u32 hw_ver;
 	__u32 rt_ver;
 	__u8 platform_id[16];
+	__u32 svn_ver;
 };
 
 enum pfru_dsm_status {


