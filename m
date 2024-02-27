Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197A578B61;
	Tue, 27 Feb 2024 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043404; cv=none; b=piKC82wdJ2sCVC9mdlNnixqhkvX0pkqMQPwY+cAmofzox3tbKTJ+qhin/NwAp0x2EGpoflHWOzBXugJFgRgZIfRJrs3sv3DMQZPn8RfZsFnvnXjUs5vgMaiBgoBlJso4WZtSDP7WxQbg0u0Iyi95KiYUCE5jFrCMafR7TJ8niks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043404; c=relaxed/simple;
	bh=pdFDwYt6Kvw1xFsOB1caUSIE5JST1RAofptsUc7FN4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dliRffHff0d1hCLrbFysZBI+++UQ72IgklDSoxCaZdE3QpqpHuESrB6Yt5kwsiyQf32Kb6vvZ3lqERF04d0wv0sPoK0y0ia4EcNzAzR97mxfl0MUuocH3BZJK3iSJrDhXsBowenmkjw6xqGOrPfyD3wfd8SmTyD+waumGCx/4Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfhPm1gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfhPm1gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97256C433C7;
	Tue, 27 Feb 2024 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043404;
	bh=pdFDwYt6Kvw1xFsOB1caUSIE5JST1RAofptsUc7FN4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfhPm1gctQrD5ucKPe75cJsyeDiWSQDPNN0Bux9jSp6mjOBkQGCWnw4niJeEopl1G
	 aJym3F1FcYMZ/q/qtUR7Fcl5A8fmjkBiT4+B/rO18h5lWlSrrka5sMSolT3gmAfL+f
	 RC+bKWyMxoAMzBYn9+WpMrEy5a0zS2NtpUYuJ8qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Julian Sikorski <belegdol@gmail.com>,
	Lee Duncan <lee.duncan@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 095/195] scsi: core: Consult supported VPD page list prior to fetching page
Date: Tue, 27 Feb 2024 14:25:56 +0100
Message-ID: <20240227131613.612916760@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit b5fc07a5fb56216a49e6c1d0b172d5464d99a89b upstream.

Commit c92a6b5d6335 ("scsi: core: Query VPD size before getting full
page") removed the logic which checks whether a VPD page is present on
the supported pages list before asking for the page itself. That was
done because SPC helpfully states "The Supported VPD Pages VPD page
list may or may not include all the VPD pages that are able to be
returned by the device server". Testing had revealed a few devices
that supported some of the 0xBn pages but didn't actually list them in
page 0.

Julian Sikorski bisected a problem with his drive resetting during
discovery to the commit above. As it turns out, this particular drive
firmware will crash if we attempt to fetch page 0xB9.

Various approaches were attempted to work around this. In the end,
reinstating the logic that consults VPD page 0 before fetching any
other page was the path of least resistance. A firmware update for the
devices which originally compelled us to remove the check has since
been released.

Link: https://lore.kernel.org/r/20240214221411.2888112-1-martin.petersen@oracle.com
Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full page")
Cc: stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Reported-by: Julian Sikorski <belegdol@gmail.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Reviewed-by: Lee Duncan <lee.duncan@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi.c        |   22 ++++++++++++++++++++--
 include/scsi/scsi_device.h |    4 ----
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -328,21 +328,39 @@ static int scsi_vpd_inquiry(struct scsi_
 	return result + 4;
 }
 
+enum scsi_vpd_parameters {
+	SCSI_VPD_HEADER_SIZE = 4,
+	SCSI_VPD_LIST_SIZE = 36,
+};
+
 static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 {
-	unsigned char vpd_header[SCSI_VPD_HEADER_SIZE] __aligned(4);
+	unsigned char vpd[SCSI_VPD_LIST_SIZE] __aligned(4);
 	int result;
 
 	if (sdev->no_vpd_size)
 		return SCSI_DEFAULT_VPD_LEN;
 
 	/*
+	 * Fetch the supported pages VPD and validate that the requested page
+	 * number is present.
+	 */
+	if (page != 0) {
+		result = scsi_vpd_inquiry(sdev, vpd, 0, sizeof(vpd));
+		if (result < SCSI_VPD_HEADER_SIZE)
+			return 0;
+
+		result -= SCSI_VPD_HEADER_SIZE;
+		if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
+			return 0;
+	}
+	/*
 	 * Fetch the VPD page header to find out how big the page
 	 * is. This is done to prevent problems on legacy devices
 	 * which can not handle allocation lengths as large as
 	 * potentially requested by the caller.
 	 */
-	result = scsi_vpd_inquiry(sdev, vpd_header, page, sizeof(vpd_header));
+	result = scsi_vpd_inquiry(sdev, vpd, page, SCSI_VPD_HEADER_SIZE);
 	if (result < 0)
 		return 0;
 
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,10 +100,6 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
-enum scsi_vpd_parameters {
-	SCSI_VPD_HEADER_SIZE = 4,
-};
-
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;


