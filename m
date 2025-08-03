Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536A6219E93;
	Sun,  3 Aug 2025 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255914; cv=none; b=mQMqk5SzZ8dhGp/Yvnj2aqu5qmAzA301WY2YEpgZX4M5trumayQrkMhtWUWmeyzMOSo/IN6F45PITrj35QizNG7RTwur/TMNstPOdxJzbnZoaaZu+ZFVJMPpKklByaip/S9m162MWiaRpWFX5ye6nYKpocAuJsS1+nZWeg0VkzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255914; c=relaxed/simple;
	bh=6zBWg0sDxk6NYE+kNcKXUHKlBQAdQGpQDafHZln9pVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YcPpqJZM/DMdeG2NoqJ8B+SiOIJxLPOhsZ1vUTOk/+6ax9BagiPPG3PHCWWC3xRWcju7Gnx3gvKOEbDIdsproIumj1zL+O+aoOBK33sWQgMCF5CzQ+TsJpZ3SidgTIQr7PSdL+CBh9oEFR29x/AeNaSjjUstUARjX++EBrWcMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfogFSm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfogFSm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFF2C4CEEB;
	Sun,  3 Aug 2025 21:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255914;
	bh=6zBWg0sDxk6NYE+kNcKXUHKlBQAdQGpQDafHZln9pVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfogFSm94kN8ZYbTCJ3sKs8freztf3hmalVwNQlNkulvnLSCXPwK2+UKX7+uYlGNf
	 RA7+n9ct2qNQ5kDj1YYpEhNBGsu6E8qrH7f+L+jiPHMTaoUDXNXNY5LCxbXpQU1HEJ
	 lImDvO9xr3BGTZBicge8c8IciY/OkYZMlBthHZcWX0luNGFnVzoqe3Js4MMa1WAH5t
	 a/wX/t3IYasewwWHgRGT0wPn2+ptnxbS55uxwo1cfZ7+2sbJlFKIkNyaV6zqefLbPG
	 0EFwZb0wo3sub+ghERMJSoluBEwfqM1xO/OwMz+11ZL5tJgdRPJRyG5PPHY8S6xvks
	 JtPA9nezQ8G6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16 24/35] ata: ahci: Disallow LPM policy control if not supported
Date: Sun,  3 Aug 2025 17:17:24 -0400
Message-Id: <20250803211736.3545028-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 65b2c92f69d3df81422d27e5be012e357e733241 ]

Commit fa997b0576c9 ("ata: ahci: Do not enable LPM if no LPM states are
supported by the HBA") introduced an early return in
ahci_update_initial_lpm_policy() to ensure that the target_lpm_policy
of ports belonging to a host that does not support the Partial, Slumber
and DevSleep power states is unchanged and remains set to
ATA_LPM_UNKNOWN and thus prevents the execution of
ata_eh_link_set_lpm().

However, a user or a system daemon (e.g. systemd-udevd) may still
attempt changing the LPM policy through the sysfs
link_power_management_policy of the host.

Improve this to prevent sysfs LPM policy changes by setting the flag
ATA_FLAG_NO_LPM for the port of such host, and initialize the port
target_lpm_policy to ATA_LPM_MAX_POWER to guarantee that no unsupported
low power state is being used on the port and its link.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250701125321.69496-9-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit message, code changes, and
examination of the kernel repository context, I can provide the
following assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix Nature**: This commit fixes a real bug where users could
   still change LPM (Link Power Management) policy through sysfs even
   when the hardware doesn't support any LPM states. The original commit
   fa997b0576c9 only prevented automatic LPM enablement but didn't block
   manual sysfs changes.

2. **User-Visible Issue**: The commit message explicitly mentions that
   "a user or a system daemon (e.g. systemd-udevd) may still attempt
   changing the LPM policy through the sysfs
   link_power_management_policy". This is a user-visible issue that
   could lead to unexpected behavior or system instability.

3. **Small and Contained Fix**: The code changes are minimal and well-
   contained:
   - Only adds 2 lines setting `ATA_FLAG_NO_LPM` flag and
     `target_lpm_policy = ATA_LPM_MAX_POWER`
   - Changes one debug message from "not enabling LPM" to "forcing LPM
     max_power"
   - The fix is localized to the `ahci_update_initial_lpm_policy()`
     function

4. **Follows Established Pattern**: The code already uses this exact
   same pattern for external ports (lines above show `ap->flags |=
   ATA_FLAG_NO_LPM; ap->target_lpm_policy = ATA_LPM_MAX_POWER;`), so
   this is extending an existing, proven approach.

5. **Prevents Invalid Configuration**: Looking at the sysfs handler
   `ata_scsi_lpm_store()` in libata-sata.c, it checks for
   `ATA_FLAG_NO_LPM` and returns `-EOPNOTSUPP`, which is the correct
   behavior this patch enables for unsupported hardware.

6. **Builds on Previous Stable Fix**: The referenced commit fa997b0576c9
   was already marked for stable ("Cc: stable@vger.kernel.org"), and
   this commit completes that fix by closing the remaining gap.

7. **Low Risk**: The change has minimal risk of regression since it only
   affects hardware that doesn't support any LPM states, and for such
   hardware, preventing LPM policy changes is the correct behavior.

The commit follows stable kernel rules by fixing an important bug with
minimal changes and low regression risk, making it an ideal candidate
for stable backporting.

 drivers/ata/ahci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index aa93b0ecbbc6..04c9b601cac1 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1782,7 +1782,10 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 	if ((ap->host->flags & ATA_HOST_NO_PART) &&
 	    (ap->host->flags & ATA_HOST_NO_SSC) &&
 	    (ap->host->flags & ATA_HOST_NO_DEVSLP)) {
-		ata_port_dbg(ap, "no LPM states supported, not enabling LPM\n");
+		ata_port_dbg(ap,
+			"No LPM states supported, forcing LPM max_power\n");
+		ap->flags |= ATA_FLAG_NO_LPM;
+		ap->target_lpm_policy = ATA_LPM_MAX_POWER;
 		return;
 	}
 
-- 
2.39.5

