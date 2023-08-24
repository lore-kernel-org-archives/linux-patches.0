Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF24412B94
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646C6C433C8;
	Thu, 24 Aug 2023 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888895;
	bh=yJOsphVYCeuY2KrfiocFcuc5+ZJOsxVcBfNFO3RLtFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LugEFlgfaUoJK+Yj+209TSINStuJx5j5dMca215HE/AB2k7eWPGjF2j6ZcKJnNLbU
	 ejbmuDBUuZFZhw9Aoe20n8QQDXiEjrMYrGQafQYsiCX4JvVQ01jYqoU6kUgCMIPpgl
	 KzwMeIczNmQrhljAi54urrw5Z312WHZCCFqp/Glw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/139] usb: dwc3: Remove DWC3 locking during gadget suspend/resume
Date: Thu, 24 Aug 2023 16:49:35 +0200
Message-ID: <20230824145025.882975731@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 5265397f94424eaea596026fd34dc7acf474dcec ]

Remove the need for making dwc3_gadget_suspend() and dwc3_gadget_resume()
to be called in a spinlock, as dwc3_gadget_run_stop() could potentially
take some time to complete.

Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220901193625.8727-3-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c8540870af4c ("usb: dwc3: gadget: Improve dwc3_gadget_suspend() and dwc3_gadget_resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 4 ----
 drivers/usb/dwc3/gadget.c | 5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f2e841bc05c70..ac119a88e6c76 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1766,9 +1766,7 @@ static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 	case DWC3_GCTL_PRTCAP_DEVICE:
 		if (pm_runtime_suspended(dwc->dev))
 			break;
-		spin_lock_irqsave(&dwc->lock, flags);
 		dwc3_gadget_suspend(dwc);
-		spin_unlock_irqrestore(&dwc->lock, flags);
 		synchronize_irq(dwc->irq_gadget);
 		dwc3_core_exit(dwc);
 		break;
@@ -1829,9 +1827,7 @@ static int dwc3_resume_common(struct dwc3 *dwc, pm_message_t msg)
 			return ret;
 
 		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
-		spin_lock_irqsave(&dwc->lock, flags);
 		dwc3_gadget_resume(dwc);
-		spin_unlock_irqrestore(&dwc->lock, flags);
 		break;
 	case DWC3_GCTL_PRTCAP_HOST:
 		if (!PMSG_IS_AUTO(msg)) {
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b2ffc98c9e747..e0c67a256c214 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4439,12 +4439,17 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 
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
-- 
2.40.1



