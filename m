Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818FEC433D6;
	Wed, 30 Nov 2022 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834193;
	bh=1D4f8fUU4CIABjMo6IeZN+Z7Fi+qbxtxwOrDsACa/W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seKTX+t2haStO/buLAwqazguHfsTW3sazunjPM4gUJGorofLsLX3bXx39758ZlBHo
	 AtvySVRJmeLZSCXDz9xTyynylBalsUSc+y2OOxS19Qs08IJ99Nl395HjZvJOueikVx
	 7nhCPNq2uCq3e8ag/izTGWMAPY6tBazLjzBXom6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.0 163/289] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Date: Wed, 30 Nov 2022 19:22:28 +0100
Message-Id: <20221130180547.829165697@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

commit b25264f22b498dff3fa5c70c9bea840e83fff0d1 upstream.

During handling Clear Halt Endpoint Feature request, driver invokes
Reset Endpoint command. Because this command has some issue with
transition endpoint from Running to Idle state the driver must
stop the endpoint by using Stop Endpoint command.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20221110063005.370656-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |   12 ++++--------
 drivers/usb/cdns3/cdnsp-ring.c   |    3 ++-
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_dev
 
 	trace_cdnsp_ep_halt(value ? "Set" : "Clear");
 
-	if (value) {
-		ret = cdnsp_cmd_stop_ep(pdev, pep);
-		if (ret)
-			return ret;
+	ret = cdnsp_cmd_stop_ep(pdev, pep);
+	if (ret)
+		return ret;
 
+	if (value) {
 		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_STOPPED) {
 			cdnsp_queue_halt_endpoint(pdev, pep->idx);
 			cdnsp_ring_cmd_db(pdev);
@@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_dev
 
 		pep->ep_state |= EP_HALTED;
 	} else {
-		/*
-		 * In device mode driver can call reset endpoint command
-		 * from any endpoint state.
-		 */
 		cdnsp_queue_reset_ep(pdev, pep->idx);
 		cdnsp_ring_cmd_db(pdev);
 		ret = cdnsp_wait_for_cmd_compl(pdev);
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2076,7 +2076,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_devic
 	u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
 	int ret = 0;
 
-	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
+	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
+	    ep_state == EP_STATE_HALTED) {
 		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
 		goto ep_stopped;
 	}


