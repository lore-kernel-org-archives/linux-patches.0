Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D517933A037;
	Mon, 18 Aug 2025 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523202; cv=none; b=QQAADlay5HHCEixcEoPlAjsF1FK86L+Q4bDR8f7RY0H3synmfy8hBYEhig5iHc7XRNbGtB9rXXs0nuE9v4B78NAdztYS+DaQ2+BKyl4LRsmRJ/9vdh1cfy+y7Bh/VWfz36QR/JhSiyhJPtBLBMkXEhKZDpoCJipvnXhfhTh5744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523202; c=relaxed/simple;
	bh=0U88I+qHDzwuIEEfBKcU51EZzNma8ad8F9nX3PClBwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tV0P9mgB18cxDXkyMEzLWf+0eN6lihxE4f0pX4Xx7Il9ib8s757t1TkdnGN0qZzTwvWQIEJYatmNvA4VN+aGi3ZUPcLRE/RNDBVUjVCwzIMs6AYnPFvSLu5QiKaMmVHPSFamsYB2J5s7lP97nyW8je4X6zlNsmIJ1rUqQwiqs/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu4kU0L5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu4kU0L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4278FC4CEF1;
	Mon, 18 Aug 2025 13:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523202;
	bh=0U88I+qHDzwuIEEfBKcU51EZzNma8ad8F9nX3PClBwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu4kU0L56Jv2pl5tm+EnUixy0EQ//5jKqn1mwO23SpdYXZ5uiL4PdQgsClCV3ZRyT
	 0yXbENCgk5sLBNWb4bljkdGHpQOk+vBJa8TgIxrYb4ag7oAoHq8uxP6fam0zpKZv8A
	 rGHJbwA3ffiCbgX3owiqawF47dNzRDCEJiLSsFGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 101/515] ata: ahci: Disable DIPM if host lacks support
Date: Mon, 18 Aug 2025 14:41:27 +0200
Message-ID: <20250818124502.260887731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f52ae776d990..f0c4e225172d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1784,6 +1784,13 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
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



