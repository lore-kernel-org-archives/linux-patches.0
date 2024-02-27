Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5059C1420C4;
	Tue, 27 Feb 2024 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040961; cv=none; b=YVMwUFg6PTsa1I2l1z20/cQ36S10+aV0pNpkrHgr1bl5IT73m66UdgQ0aLiktXumj2CUtlBIr6atB1AxlgdLS16K5DOs5U29o7KSM4d8H0DI63hJ74ZmGmOuvjMz58nRlT8e9C8fzfyzzsgAmJlUNJFcAZ3XJJSqz1Po20ZmtJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040961; c=relaxed/simple;
	bh=HJcDIbzabQjdD78I42+lRBiCO6bNoxYfGnOFCnW1E3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0iTG9AMpY1FvyQK0VScBhaUHyQV2AKWIU5t8Q1DemO5iGxjVswQCQNDfWJG8WIx37iV+J+HFL29nL+Mbb9+aM+mOgBbgSvh5rn09ayxGkaXZ/5pUm1LsWfD/+P/b3N7V3+jvm7yPeHzB8yqSYvA3XfdsVctX81UEgDgGecN4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsfEBkzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsfEBkzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3575C433F1;
	Tue, 27 Feb 2024 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040961;
	bh=HJcDIbzabQjdD78I42+lRBiCO6bNoxYfGnOFCnW1E3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsfEBkzpuSio3G6RwMvf4OGyQcqU7iYiNmJ1fjH1ZKfAiM6QrNYNa4CatMEayQWRx
	 VJczDtQqthWFCRtKOx5v+hbcTbyXtp8s73Gce4fDuXYDLyDmw1J5xWJmj/5/MALTDt
	 3ZKBBvsKjV0OgGm6XqRnXjj483ZcIHf3WhsEjBys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Julian Sikorski <belegdol@gmail.com>,
	Lee Duncan <lee.duncan@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 169/334] scsi: core: Consult supported VPD page list prior to fetching page
Date: Tue, 27 Feb 2024 14:20:27 +0100
Message-ID: <20240227131635.978931065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


