Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC178346E57;
	Fri, 21 Nov 2025 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732296; cv=none; b=iOVc+hdNkBbsMgEsj4sWMi3uBdM+JkGWp1cP0bTEmXZCobIgqBAiCKf/7sNcHtOwb0Acmd2sevXIfekvwe/Fhbf0B9VMez1IBJhbzYhAuUpRGLg2R7yd97PIGPekUIZzqZiBU/V1lt1uwrLBNxfgD1PaqxEr7D8GlqdF1gp9wnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732296; c=relaxed/simple;
	bh=GlWyb1Txzu7HoQjzFTMVAULdEbWZVIqJZa6V6UoVVFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxAsKZ9q4ZEfpN8SC77KbXBkjO4REvyKwr26/a51i/d82E9P2KNYfVBm2KF6EjZA90fsSRvP1AaP4f8GTEae0gbmH9Bwi7pWbqMR2zVLLiZ1SCd050JtsQPB5jM5iyvfuz902U5GisHC3mm8bkQSP0dpdlTuXhbLnPVP9zrr7+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpiGYLy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpiGYLy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C56C4CEF1;
	Fri, 21 Nov 2025 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732295;
	bh=GlWyb1Txzu7HoQjzFTMVAULdEbWZVIqJZa6V6UoVVFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpiGYLy0UQSr1CXJoU19umlT7q53aiU1xWgM1+eXo75XVAHvScDAdQ626mRCxX5lt
	 tns6k5OtuEs3rolSPCahOnMMY4qpxKvMfOzvODVq93lMWc/sTEinGh3110tbiiCTCR
	 zunmWfi8GETpCTnuf8SRUtAXPVLixEXgwJ7i9KnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/529] ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]
Date: Fri, 21 Nov 2025 14:06:11 +0100
Message-ID: <20251121130233.587023568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0c5c5c58ae1e..5b5986e10c2d7 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -784,6 +784,8 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
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



