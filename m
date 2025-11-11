Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C77E7262A;
	Tue, 11 Nov 2025 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822810; cv=none; b=lppEClt86QSgaXe8ytMksnDU0ehZoaQwSroIFTy0Kks8i0sU226bsTfLQu2NZAmiiVmPgOLOweisExF4YSNWptwvcsgqOHNVROHYB2gng+1tAe+AUoBYlT3HLLJkV2oV9rOM4z0hT4vuP+/30iTNd7a9hStgdbbKHMxhSNBwZXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822810; c=relaxed/simple;
	bh=2b5aeT5il8QcHRX0QNMCXjt24N5a1dBL/gVrtCzp+SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwgkauHEQ5zTzKxcg/tZoC3skzhwgTl+OVHqI+taiI3ZLrMquRs6kSdTXPwmjs6FltDIzhUiP+kE/OzCD4VGVJB34iazag/bb6/MfbvItlx8v8CQiLug1EeXFX7qFeEe0ibBRt6bflayQeEvDGAJ23F10aGMP4YaxS+HsUsAYfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS4Zu8oW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS4Zu8oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E90C116B1;
	Tue, 11 Nov 2025 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822810;
	bh=2b5aeT5il8QcHRX0QNMCXjt24N5a1dBL/gVrtCzp+SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xS4Zu8oWdew/eipqqgN+5QIlmCn3zE1dcL64DsJAwg0p6O2o3dCyAu6F8OxeMNTxq
	 T/3a2CV8shPCj2e4h6YNidywk6v52lc9rvpfnlOF223W/nUQrASNLCpr6aWmC3ws9N
	 mE1uE4Kb2V9I2SoivVhIHi34Bf76qh2wwueA6i8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/565] ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]
Date: Tue, 11 Nov 2025 09:39:29 +0900
Message-ID: <20251111004529.496125921@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 4405a214df146775338a1e6232701a29024b82e1 ]

Some x86/ACPI laptops with MIPI cameras have a INTC10DE or INTC10E0 ACPI
device in the _DEP dependency list of the ACPI devices for the camera-
sensors (which have flags.honor_deps set).

These devices are for an Intel Vision CVS chip for which an out of tree
driver is available [1].

The camera sensor works fine without a driver being loaded for this
ACPI device on the 2 laptops this was tested on:

ThinkPad X1 Carbon Gen 12 (Meteor Lake)
ThinkPad X1 2-in-1 Gen 10 (Arrow Lake)

For now add these HIDs to acpi_ignore_dep_ids[] so that
acpi_dev_ready_for_enumeration() will return true once the other _DEP
dependencies are met and an i2c_client for the camera sensor will get
instantiated.

Link: https://github.com/intel/vision-drivers/ [1]
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250829142748.21089-1-hansg@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7ecc401fb97f9..4ef94d06365fc 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -847,6 +847,8 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
 static const char * const acpi_ignore_dep_ids[] = {
 	"PNP0D80", /* Windows-compatible System Power Management Controller */
 	"INT33BD", /* Intel Baytrail Mailbox Device */
+	"INTC10DE", /* Intel CVS LNL */
+	"INTC10E0", /* Intel CVS ARL */
 	"LATT2021", /* Lattice FW Update Client Driver */
 	NULL
 };
-- 
2.51.0



