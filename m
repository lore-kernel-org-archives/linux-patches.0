Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83B5223328;
	Thu, 28 May 2026 20:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000383; cv=none; b=HYDtfhz0RpDmccuVINjVP8JWShw+kvmql4VPKk8SCwGd0iTeS3cP28BQN6eAPxk1NPSpPGrHTQMZnpCf3tAGx5zfBXl76j5UMd3bKWZrCRIzfyBkmVyhnDbJbcfNaEgEs/1A0U/RxwyA3YL9Nn9Vk13UMq3ytbO2jn4TqZ5Gzp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000383; c=relaxed/simple;
	bh=dO69E1tj4Mr1Sskf1sDgaktNJHyCdZ+PDvhqGVi8r1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVG2GjmuryiyhFCRoy7XnPtzHb6vJP9/Vu992aKImbnbGKX57VYGHqIbzyj8+/H4x/990ZipnwfT5/niGYdU86p+pt/1iM+CLEQQ4vpOXVgiuvaaBJTLnhFb2RS+CZFeOftQRKBjbnaBL28A8yA8Ku9WpSoaqr+RXsoVfwYF24s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEY8N882; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEY8N882"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437EE1F000E9;
	Thu, 28 May 2026 20:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000382;
	bh=1+4bL5STdByjs5B+w4k5pnldVSyT/zlh2eKQxGlCL04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEY8N882x9VRv9dH5mslaWAacHwKZYBiLR3e8eyWFtvNFakivEexkgHQbNqNbq/NS
	 luSboQapi1u4Z7OcdiOF/z3WZgW06Ut2zRoE+aybxHTxiIOQnimTaDfo+abZdZHTEG
	 1QYvxCxRwWv5qK5hv9vw3+545+bueWHJMNFl7/CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Kelly <linux@tkel.ly>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 026/272] ata: libata-scsi: do not use the deferred QC feature for ATA_DEFER_PORT
Date: Thu, 28 May 2026 21:46:40 +0200
Message-ID: <20260528194630.119243273@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -1801,11 +1801,11 @@ static int ata_scsi_qc_issue(struct ata_
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
@@ -1825,6 +1825,7 @@ defer_qc:
 		return 0;
 	}
 
+free_qc:
 	/* Force a requeue of the command to defer its execution. */
 	ata_qc_free(qc);
 


