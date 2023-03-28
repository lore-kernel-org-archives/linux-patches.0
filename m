Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8448BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87512C433D2;
	Tue, 28 Mar 2023 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016243;
	bh=j4jKcJqBsVg1T7zKJBrYXuMxAuTocnUWvRcNBPceYkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsZur4Hofvrrd5tL/1C06goHFWJf8giWllmIvp9wlgzIto8Xn/y73I0VuQxkLzMjD
	 esUPgCPoHTnRcscPpD9DMVUcjYIGHGYjxYgR48pYMyzf3hV5cMktMGuA+HZ2W22XmL
	 kUt0Fr+HDtmWHtmBv43MzD5Fwn07pm2xAw77ifsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 117/146] usb: cdnsp: Fixes issue with redundant Status Stage
Date: Tue, 28 Mar 2023 16:43:26 +0200
Message-Id: <20230328142607.526556188@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawel Laszczak <pawell@cadence.com>

commit 5bc38d33a5a1209fd4de65101d1ae8255ea12c6e upstream.

In some cases, driver trees to send Status Stage twice.
The first one from upper layer of gadget usb subsystem and
second time from controller driver.
This patch fixes this issue and remove tricky handling of
SET_INTERFACE from controller driver which is no longer
needed.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230307111420.376056-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ep0.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -403,20 +403,6 @@ static int cdnsp_ep0_std_request(struct
 	case USB_REQ_SET_ISOCH_DELAY:
 		ret = cdnsp_ep0_set_isoch_delay(pdev, ctrl);
 		break;
-	case USB_REQ_SET_INTERFACE:
-		/*
-		 * Add request into pending list to block sending status stage
-		 * by libcomposite.
-		 */
-		list_add_tail(&pdev->ep0_preq.list,
-			      &pdev->ep0_preq.pep->pending_list);
-
-		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
-		if (ret == -EBUSY)
-			ret = 0;
-
-		list_del(&pdev->ep0_preq.list);
-		break;
 	default:
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 		break;
@@ -474,9 +460,6 @@ void cdnsp_setup_analyze(struct cdnsp_de
 	else
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 
-	if (!len)
-		pdev->ep0_stage = CDNSP_STATUS_STAGE;
-
 	if (ret == USB_GADGET_DELAYED_STATUS) {
 		trace_cdnsp_ep0_status_stage("delayed");
 		return;
@@ -484,6 +467,6 @@ void cdnsp_setup_analyze(struct cdnsp_de
 out:
 	if (ret < 0)
 		cdnsp_ep0_stall(pdev);
-	else if (pdev->ep0_stage == CDNSP_STATUS_STAGE)
+	else if (!len && pdev->ep0_stage != CDNSP_STATUS_STAGE)
 		cdnsp_status_stage(pdev);
 }


