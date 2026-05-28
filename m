Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682DB34D4D6;
	Thu, 28 May 2026 19:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998061; cv=none; b=nyLrRc4olIDFNcy+rXU9YX4BQ0a5BldXxuud9F62CAj1AZSYdFdmvYCDLUqMk+zUm9lGsvDaH0aT6P4YRiRt9aIY5ZBaM24frzAzf5D4215RK1XeUAFxdKuvqDGfLs9w7Y831tEZrJS2pevteRpEIFKi1LTR9skUn5K34LVVRTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998061; c=relaxed/simple;
	bh=8aMUV+R2m22hLcDgLTdJL0B3hfNgFR/tpmRjO7gxtRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5dIzg6KzDD+OT4lWt0LwhQ+FISc9xGqXfK0QitIE8LN8wSYO6EjH2Fq2FooP/aylpeZTH0MJ05E/EnGMn12z4K+FwHmfsODdg5GkIGWj+cxal5Ih7E7UiiOou733BoKdWiZruD6hcbx/KSTdhzaUR14q0Wph8ceU51HJRLIBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrApmZnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrApmZnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EB61F000E9;
	Thu, 28 May 2026 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998060;
	bh=uRjlZZEN8EVIYCXMTZGAI2K8xc3h385lQcGwyusg9sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrApmZnEvKWLGsNzYmFNjiXfqQRE7yK+HBCSBdvNBFz56ffh20jbByuecJqQOuYD5
	 IXnQgaRv+jYmz+gvvwwRPpTHflozTQlHjcELYV3BI24j9rOPFszC2klw1loEHGnZbp
	 iVwdc38G2albG4AqikC8meQuhybMB32nSTGQkrEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Kelly <linux@tkel.ly>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 7.0 006/461] ata: libata-scsi: do not use the deferred QC feature for ATA_DEFER_PORT
Date: Thu, 28 May 2026 21:42:15 +0200
Message-ID: <20260528194647.021145343@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit ce4548807d2e4ae48fd0dbe38865467369877913 upstream.

The deferred QC feature was meant to handle mixed NCQ and non-NCQ commands,
i.e. for return value ATA_DEFER_LINK.

ATA_DEFER_PORT is returned by PATA drivers, but also certain SATA drivers
like sata_mv and sata_sil24 that uses ap->excl_link to workaround hardware
bugs in these HBAs. Regardless of the reason, using the deferred QC feature
for ATA_DEFER_PORT is always wrong, and will break the ap->excl_link usage
of the SATA drivers that rely on that feature.

Modify ata_scsi_qc_issue() to only use the deferred QC feature when mixing
NCQ and non-NCQ commands, i.e. ATA_DEFER_LINK.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Tested-by: Tommy Kelly <linux@tkel.ly>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1790,11 +1790,11 @@ static int ata_scsi_qc_issue(struct ata_
 		goto defer_qc;
 	case ATA_DEFER_PORT:
 		ret = SCSI_MLQUEUE_HOST_BUSY;
-		goto defer_qc;
+		goto free_qc;
 	default:
 		WARN_ON_ONCE(1);
 		ret = SCSI_MLQUEUE_HOST_BUSY;
-		goto defer_qc;
+		goto free_qc;
 	}
 
 issue_qc:
@@ -1814,6 +1814,7 @@ defer_qc:
 		return 0;
 	}
 
+free_qc:
 	/* Force a requeue of the command to defer its execution. */
 	ata_qc_free(qc);
 


