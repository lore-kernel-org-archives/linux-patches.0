Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7352BE03C;
	Tue, 26 Aug 2025 11:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208284; cv=none; b=FR6aiOf+L6/lfbIYv+KW0GfZoSFB59yNdqrP8J5j4froURwHXz7cQofGtrVgaDC+UTR0rIhIltaGUJotxv5GMzPBHciATyvlgFCxcnSqdo7TAa/Gg+XPxnilvVEG7oLPpoYBz0VDq8Y+fqNqgbRezM56g4710Yw2BZSFi1c6lNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208284; c=relaxed/simple;
	bh=P82NRHfMNheHISOY/wBb5wLAp9ICnKPy4eNBVgibojw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVtFi2vJTNL/ameWlZDjo0xdap+DS8qG0eRTR3Y7m0oioCg7MPqYCfRbrg20sYLZznzNptCousSGLNt8B5Za4ElTMtL64rfv7wq6YjAmjTQgPjcBPBxJFKX7+BMaTZoko49ugEzGjtCxRyh4EYt/M4y8HhwavTsMe9Gonw8BpLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtAmHTPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtAmHTPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CABC4CEF1;
	Tue, 26 Aug 2025 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208284;
	bh=P82NRHfMNheHISOY/wBb5wLAp9ICnKPy4eNBVgibojw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtAmHTPDuNGJIDyg3lD3rLybE4cqWyMJgsQzSFgAtTKTB8rm55aN5g3qzorN4TXAM
	 OBpGnrnXxqQFwci0ynA+5QP63emKMRFuqelLYfBvQCa6yDyl2npMLhfAgkkSEsdR1z
	 GIetb4/egT5tt+hxo/iQh9znyOaeWRpO0gB4n2HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 053/322] ata: libata-scsi: Fix CDL control
Date: Tue, 26 Aug 2025 13:07:48 +0200
Message-ID: <20250826110916.716718008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

commit 58768b0563916ddcb73d8ed26ede664915f8df31 upstream.

Delete extra checks for the ATA_DFLAG_CDL_ENABLED flag that prevent
SET FEATURES command from being issued to a drive when NCQ commands
are active.

ata_mselect_control_ata_feature() sets / clears the ATA_DFLAG_CDL_ENABLED
flag during the translation of MODE SELECT to SET FEATURES. If SET FEATURES
gets deferred due to outstanding NCQ commands, the original MODE SELECT
command will be re-queued. When the re-queued MODE SELECT goes through
the ata_mselect_control_ata_feature() translation again, SET FEATURES
will not be issued because ATA_DFLAG_CDL_ENABLED has been already set or
cleared by the initial translation of MODE SELECT.

The ATA_DFLAG_CDL_ENABLED checks in ata_mselect_control_ata_feature()
are safe to remove because scsi_cdl_enable() implements a similar logic
that avoids enabling CDL if it has been enabled already.

Fixes: 17e897a45675 ("ata: libata-scsi: Improve CDL control")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3752,21 +3752,16 @@ static int ata_mselect_control_ata_featu
 	/* Check cdl_ctrl */
 	switch (buf[0] & 0x03) {
 	case 0:
-		/* Disable CDL if it is enabled */
-		if (!(dev->flags & ATA_DFLAG_CDL_ENABLED))
-			return 0;
+		/* Disable CDL */
 		ata_dev_dbg(dev, "Disabling CDL\n");
 		cdl_action = 0;
 		dev->flags &= ~ATA_DFLAG_CDL_ENABLED;
 		break;
 	case 0x02:
 		/*
-		 * Enable CDL if not already enabled. Since this is mutually
-		 * exclusive with NCQ priority, allow this only if NCQ priority
-		 * is disabled.
+		 * Enable CDL. Since CDL is mutually exclusive with NCQ
+		 * priority, allow this only if NCQ priority is disabled.
 		 */
-		if (dev->flags & ATA_DFLAG_CDL_ENABLED)
-			return 0;
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
 			ata_dev_err(dev,
 				"NCQ priority must be disabled to enable CDL\n");


