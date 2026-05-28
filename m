Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D97833F5BE;
	Thu, 28 May 2026 20:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999295; cv=none; b=jHUNue072edmJ8MfwIg2sOjk24Nz27yonXv44Ny//hzz+upWlmisG9m665Sya79j/UEdsF4kF5+pfo3kseVCCQzK0liplU1ygCoMu62DZrkOztNse6AM+aP4YKM73D1tZfETadQaFWJssvwk++ErfyVX8KEhlNLLS7z7wdxOTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999295; c=relaxed/simple;
	bh=JG1U5ZF7fGeBA1K2w7AZi7mjWhvdSrxLirSX8zlOiKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/fk+bzo40gACzL/or2T3rbb/UoMxdreBV9m9eBt4VSPUs8mZWu2cvDHRapjGisXU/M5id7O/dVDwMajerS5YY653Job/OcYiEl5KAwdUvOP07+a5GI3MM6Objy6STRgFtICXoyYEwSiYeSMNMnRyPPWl66OAMAaer4dfIO8NXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyvPNxah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyvPNxah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5341F000E9;
	Thu, 28 May 2026 20:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999294;
	bh=k5Hes0x6jlNQIZOw5Wa0cUxO1zCzvIsUarwnGGa1WR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QyvPNxah5HzUUoMdYTCE/B0Tc87vO2zy1CGzpXdte1gbrri/ejnrCRiTQdIisBLii
	 oGyWXFjZtVVmaohnO0hwYsgPSSXlzKo1f583O/+9k5+BS0qBakeNm2uk/75MPhYj9M
	 Xj/DiFFQAwBdfYi1QwnmcOzc+C/sJQB3Rj94bBWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Kelly <linux@tkel.ly>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 016/377] ata: libata-scsi: do not use the deferred QC feature for ATA_DEFER_PORT
Date: Thu, 28 May 2026 21:44:14 +0200
Message-ID: <20260528194638.858445078@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1789,11 +1789,11 @@ static int ata_scsi_qc_issue(struct ata_
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
@@ -1813,6 +1813,7 @@ defer_qc:
 		return 0;
 	}
 
+free_qc:
 	/* Force a requeue of the command to defer its execution. */
 	ata_qc_free(qc);
 


