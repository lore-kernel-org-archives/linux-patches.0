Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14F1343D63;
	Tue, 26 Aug 2025 14:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218371; cv=none; b=UUlSH0aZrHsBqnzRjOgf3NkaoUJmYmQqoMEKEhwKVR0Rs/jeXWDDt0ixUnoBmslHrGfNmfpuWCszNSaGjrRsuUqwOi3yclbTaJSBRYqYcZ1m5eMRzRtjNVFGxAzzgMutIqZ9/MVdPg+uH8IoSBoVsmI28cNSjHHgDDV8vXTJ3ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218371; c=relaxed/simple;
	bh=T1Vt421JVg5JQBGWel1dqi4KMnNrJZ4Xj/rl6hDAaDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMqAPHOk+vbgvwTDWftdynU50SBa9YTFSRcDBdG+CnJtCI23hdWS1eYiag070xa7imZHR8MGMeaq+gn28CQx2GVTF/HF+o5hPDny7wvL4tnJU2JouOTyq1zvu2QVpv8tdqN87nIsa4vLkPtz+pyymxecoHEGb+33acJcljd6EWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp52/eHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp52/eHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D4CC4CEF1;
	Tue, 26 Aug 2025 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218371;
	bh=T1Vt421JVg5JQBGWel1dqi4KMnNrJZ4Xj/rl6hDAaDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kp52/eHSsIl8itXo1+tgZ2UyP3iNaxveAHH7V6IrnBG8GjDfOg84W3W/f1yTzmwc1
	 4P6xoL43cEfZKDqHKoFiFXEPTDRRmMmC+vZ3uvg1jogOz2qLCYXFOp2gTFN8t1IqsV
	 yNKCU0AfGxdt6/laub64qvGo+kD1DhmG4Ib2QQIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>
Subject: [PATCH 5.10 496/523] usb: dwc3: Remove DWC3 locking during gadget suspend/resume
Date: Tue, 26 Aug 2025 13:11:46 +0200
Message-ID: <20250826110936.676705120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 5265397f94424eaea596026fd34dc7acf474dcec upstream.

Remove the need for making dwc3_gadget_suspend() and dwc3_gadget_resume()
to be called in a spinlock, as dwc3_gadget_run_stop() could potentially
take some time to complete.

Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220901193625.8727-3-quic_wcheng@quicinc.com
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c   |    4 ----
 drivers/usb/dwc3/gadget.c |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1742,9 +1742,7 @@ static int dwc3_suspend_common(struct dw
 	case DWC3_GCTL_PRTCAP_DEVICE:
 		if (pm_runtime_suspended(dwc->dev))
 			break;
-		spin_lock_irqsave(&dwc->lock, flags);
 		dwc3_gadget_suspend(dwc);
-		spin_unlock_irqrestore(&dwc->lock, flags);
 		synchronize_irq(dwc->irq_gadget);
 		dwc3_core_exit(dwc);
 		break;
@@ -1805,9 +1803,7 @@ static int dwc3_resume_common(struct dwc
 			return ret;
 
 		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
-		spin_lock_irqsave(&dwc->lock, flags);
 		dwc3_gadget_resume(dwc);
-		spin_unlock_irqrestore(&dwc->lock, flags);
 		break;
 	case DWC3_GCTL_PRTCAP_HOST:
 		if (!PMSG_IS_AUTO(msg)) {
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4115,12 +4115,17 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 
 int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
+	unsigned long flags;
+
 	if (!dwc->gadget_driver)
 		return 0;
 
 	dwc3_gadget_run_stop(dwc, false, false);
+
+	spin_lock_irqsave(&dwc->lock, flags);
 	dwc3_disconnect_gadget(dwc);
 	__dwc3_gadget_stop(dwc);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
 }


