Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D49913AA40;
	Wed, 19 Jun 2024 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802134; cv=none; b=RsTRhXg6jyfYtCp1qFWKWC7ZcWy24zfstTy8lxrfIlNGZv5P93JgdpCIBYfBzTJsJuTSaJl/BMOBaHZeq3jezGLZplAdORNMfkj22SOYezZ+1Yo20C2sMfGQWSUiD802M5jwfUsziDglNn1S3iT/szoeYl7UCscquVn4fxs/Jr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802134; c=relaxed/simple;
	bh=b45L9dXWvSU31trkhggpLDm7IIJNY0OrPCTIkqfuORQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFHHumE52XBVc42nl3jvsXkAhyxCJc4efRAZd137oDYzu0/sq9dI4WS3MlGsfe713PY6jSAL1dQ0nwp+S7rJ2ShlSD50pLS73GNqkcZcFUy/LmluGYco1ryLggdvr6b0G80vgKzEYu4dFCrI4SoSLfDoyu1QPrZLaEzHIskUTcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwDiEzfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwDiEzfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926BDC2BBFC;
	Wed, 19 Jun 2024 13:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802134;
	bh=b45L9dXWvSU31trkhggpLDm7IIJNY0OrPCTIkqfuORQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwDiEzfM5IW87dlai1pAqz9nb/UeEUpZUPXyXfJeYJc/W1kDJrmfiU+W72J85arZH
	 FcR7WWynIWCRMG7O/V65qoeBxk1fz17KltzWvJUtBvI0gGo9RXZ4TQvFUUmdPqH7X/
	 mZLSbfHBIyn6p8gKi5auCsTluB3AQEkzy8UOrizw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott McCoy <scott.mccoy@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 094/267] scsi: core: Disable CDL by default
Date: Wed, 19 Jun 2024 14:54:05 +0200
Message-ID: <20240619125609.959583089@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 52912ca87e2b810e5acdcdc452593d30c9187d8f upstream.

For SCSI devices supporting the Command Duration Limits feature set, the
user can enable/disable this feature use through the sysfs device attribute
"cdl_enable". This attribute modification triggers a call to
scsi_cdl_enable() to enable and disable the feature for ATA devices and set
the scsi device cdl_enable field to the user provided bool value.  For SCSI
devices supporting CDL, the feature set is always enabled and
scsi_cdl_enable() is reduced to setting the cdl_enable field.

However, for ATA devices, a drive may spin-up with the CDL feature enabled
by default. But the SCSI device cdl_enable field is always initialized to
false (CDL disabled), regardless of the actual device CDL feature
state. For ATA devices managed by libata (or libsas), libata-core always
disables the CDL feature set when the device is attached, thus syncing the
state of the CDL feature on the device and of the SCSI device cdl_enable
field. However, for ATA devices connected to a SAS HBA, the CDL feature is
not disabled on scan for ATA devices that have this feature enabled by
default, leading to an inconsistent state of the feature on the device with
the SCSI device cdl_enable field.

Avoid this inconsistency by adding a call to scsi_cdl_enable() in
scsi_cdl_check() to make sure that the device-side state of the CDL feature
set always matches the scsi device cdl_enable field state.  This implies
that CDL will always be disabled for ATA devices connected to SAS HBAs,
which is consistent with libata/libsas initialization of the device.

Reported-by: Scott McCoy <scott.mccoy@wdc.com>
Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240607012507.111488-1-dlemoal@kernel.org
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -671,6 +671,13 @@ void scsi_cdl_check(struct scsi_device *
 		sdev->use_10_for_rw = 0;
 
 		sdev->cdl_supported = 1;
+
+		/*
+		 * If the device supports CDL, make sure that the current drive
+		 * feature status is consistent with the user controlled
+		 * cdl_enable state.
+		 */
+		scsi_cdl_enable(sdev, sdev->cdl_enable);
 	} else {
 		sdev->cdl_supported = 0;
 	}


