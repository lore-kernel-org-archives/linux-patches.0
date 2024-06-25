Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666741465A8;
	Tue, 25 Jun 2024 09:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308710; cv=none; b=l4ooE1sUf43tfQ5dtY9tR4E5+wtUR79gchLJdNPIDUj8RaaBoEtmpNBu8zCyiNOqFHEbe9t9QbBok3MQq4u6yDYYF6W6AfZqwP8a+p+UpHZmhugr4jVv3v08/uG2040vOMpkP28qUGstGMm213x/H3UeuVT5YnGf2HHJLfHFkuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308710; c=relaxed/simple;
	bh=ntMy5HbXhTOEEhHeKKiwxKFv5MLItUDtBvQuJ9I0pMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDJ1SO1dKA2OepoeBzYOhwiMsKqtEiSGKRbdtqJX8nBqG8ZjtudpoTvD3tj+JBd5ytAoNRdE0BXRXm7FaSK8rjeZV2RSKEKfsysWuzp7YmX61H+tX8d7V8Ce+X+KZErypigaaJJ1nbVkOx0J/3uMG7OrYelxA9U4/fnNc7o7sOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1W/suXfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1W/suXfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D30C32786;
	Tue, 25 Jun 2024 09:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308710;
	bh=ntMy5HbXhTOEEhHeKKiwxKFv5MLItUDtBvQuJ9I0pMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1W/suXfINotnPWT9ZN+M2mL8tKwQPp5d3e+nC+WbrKvyFyF+0WyS7Y6uHz6WC6wlf
	 3fSj41Ob21u54WsdX1+E09EaveXEqHskXb9pdH4F4OwyAel7tIYczmNhxI4sZAeJrX
	 l+aSNFuU5Io3oNRtockiNN197JO+5HEB0t2PheJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 214/250] ata: ahci: Do not enable LPM if no LPM states are supported by the HBA
Date: Tue, 25 Jun 2024 11:32:52 +0200
Message-ID: <20240625085556.269224092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit fa997b0576c9df635ee363406f5e014dba0f9264 upstream.

LPM consists of HIPM (host initiated power management) and DIPM
(device initiated power management).

ata_eh_set_lpm() will only enable HIPM if both the HBA and the device
supports it.

However, DIPM will be enabled as long as the device supports it.
The HBA will later reject the device's request to enter a power state
that it does not support (Slumber/Partial/DevSleep) (DevSleep is never
initiated by the device).

For a HBA that doesn't support any LPM states, simply don't set a LPM
policy such that all the HIPM/DIPM probing/enabling will be skipped.

Not enabling HIPM or DIPM in the first place is safer than relying on
the device following the AHCI specification and respecting the NAK.
(There are comments in the code that some devices misbehave when
receiving a NAK.)

Performing this check in ahci_update_initial_lpm_policy() also has the
advantage that a HBA that doesn't support any LPM states will take the
exact same code paths as a port that is external/hot plug capable.

Side note: the port in ata_port_dbg() has not been given a unique id yet,
but this is not overly important as the debug print is disabled unless
explicitly enabled using dynamic debug. A follow-up series will make sure
that the unique id assignment will be done earlier. For now, the important
thing is that the function returns before setting the LPM policy.

Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240618152828.2686771-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 07d66d2c5f0d..5eb38fbbbecd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1735,6 +1735,14 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 	if (ap->pflags & ATA_PFLAG_EXTERNAL)
 		return;
 
+	/* If no LPM states are supported by the HBA, do not bother with LPM */
+	if ((ap->host->flags & ATA_HOST_NO_PART) &&
+	    (ap->host->flags & ATA_HOST_NO_SSC) &&
+	    (ap->host->flags & ATA_HOST_NO_DEVSLP)) {
+		ata_port_dbg(ap, "no LPM states supported, not enabling LPM\n");
+		return;
+	}
+
 	/* user modified policy via module param */
 	if (mobile_lpm_policy != -1) {
 		policy = mobile_lpm_policy;
-- 
2.45.2



