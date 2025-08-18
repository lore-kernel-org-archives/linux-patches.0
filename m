Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E121CC55;
	Mon, 18 Aug 2025 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524949; cv=none; b=caxdsJP7uLzXmhB8TdIIBhDOWNepNpCjz9TLoCGzRGlEhJAuhK0pbDdLvlaR+MIRfhqUuKl8xk/AMjqdd0237R6rkyBsITZ3kF1G4zpzwbAl9fw/OhnQDKIdd/Xed7NJ6jU7E732WaZOUxc1ltsp9WpAN+oOCItDbUDFIfr2ATw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524949; c=relaxed/simple;
	bh=pvo7FNyhY/991h9zn4NhkY6UnyPRh0rGt0SnXelbsRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unVOGTTxFM9+1LLCzqOgwq0P5MevuaYimZzlyDFb7AL8K5Z8hze8ZuqATmxYcSlbVzUQQi9EEt2Oo+zFxOo21L7rB6NyODJWFuHGWpyLz42mSowu3cBObBtR53IbLyk4PIQ0VhrBPERwhhbMd6qup1IknB6zIjAx6RV/yrcrpYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY8uDq2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY8uDq2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470F7C113D0;
	Mon, 18 Aug 2025 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524948;
	bh=pvo7FNyhY/991h9zn4NhkY6UnyPRh0rGt0SnXelbsRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DY8uDq2vuSgwVKK/yA4Kh6lktVVVbFVBJEtE/18zjWz86EcpTPUU0fCSvihLPiUx1
	 iwjxNIa5BfMWkbSK6GhIDzMSmfJea1oJsoGqH/uD+3v+YXEamOMpdA+f+cFATdRnIt
	 t5Y83oJEn3aALm0Hss6zzN9AdJW8MpJ8ty02qGRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 113/570] ata: ahci: Disable DIPM if host lacks support
Date: Mon, 18 Aug 2025 14:41:40 +0200
Message-ID: <20250818124510.156954800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit f7870e8d345cdabfb94bcbdcba6a07e050f8705e ]

The AHCI specification version 1.3.1 section 8.3.1.4 (Software
Requirements and Precedence) states that:

If CAP.SSC or CAP.PSC is cleared to ‘0’, software should disable
device-initiated power management by issuing the appropriate SET
FEATURES command to the device.

To satisfy this constraint and force ata_dev_configure to disable the
device DIPM feature, modify ahci_update_initial_lpm_policy() to set the
ATA_FLAG_NO_DIPM flag on ports that have a host with either the
ATA_HOST_NO_PART flag set or the ATA_HOST_NO_SSC flag set.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de.>
Link: https://lore.kernel.org/r/20250701125321.69496-7-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 04c9b601cac1..4f69da480e86 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1778,6 +1778,13 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 		return;
 	}
 
+	/* If no Partial or no Slumber, we cannot support DIPM. */
+	if ((ap->host->flags & ATA_HOST_NO_PART) ||
+	    (ap->host->flags & ATA_HOST_NO_SSC)) {
+		ata_port_dbg(ap, "Host does not support DIPM\n");
+		ap->flags |= ATA_FLAG_NO_DIPM;
+	}
+
 	/* If no LPM states are supported by the HBA, do not bother with LPM */
 	if ((ap->host->flags & ATA_HOST_NO_PART) &&
 	    (ap->host->flags & ATA_HOST_NO_SSC) &&
-- 
2.39.5



