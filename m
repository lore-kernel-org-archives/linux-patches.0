Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5979E349AE6;
	Wed,  3 Dec 2025 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777640; cv=none; b=sKXSx045wOiokERq1pN47ryL7vhIlmaGRZ/FpoU8e88ym8SLQL8CxGRtm1xRoLrJgLMElXjv6aBPB8CNSQ6K2JPiBAmlv/oqjze0btzJlMIb1oTpvu+pme1pX+ptpXga2wN8xiEDNubW+9EAf97JIF8rnSO2mY0xe5n9ZAAb8pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777640; c=relaxed/simple;
	bh=+gJoTt2Hcep1evxbZUIJ0pTrgAguJkiR1PVFVTivDvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkAmJVHHi2LN4ewYlJwSI6PvrVvNmqJu6o0h9scj3ZxN1GSyCNJr+6fEbXUsUMRHZ7o4jdHCjLkbtvMapIUV8+ZXiYKoz0shr32Qcya2WSoyjQhCO4dm4a8qWg+HtlbT3Xho7NRbq8Cyg1D86x+wDVAtFXORl9UPtndPcYJC+Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PetBWdSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PetBWdSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F2C4CEF5;
	Wed,  3 Dec 2025 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777640;
	bh=+gJoTt2Hcep1evxbZUIJ0pTrgAguJkiR1PVFVTivDvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PetBWdShu3yfWIfngGkC8zJ2uzRox01x0BzYzX0z3agO6n+E6Yi8k7T5PmgjkSU7+
	 0xgMb+gZueEmyPD1uB2ETFHvFttLfSsQGjBdjSPaXCzITY0OF6mCZ/q/AOERbtnw80
	 J/wMD8eD10t6uJ7wYYK7Rxq0n2XgMUBk182hMx+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/392] ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]
Date: Wed,  3 Dec 2025 16:23:37 +0100
Message-ID: <20251203152416.575716976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2393cd993b3cb..151c57c7bb3a4 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -789,6 +789,8 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
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



