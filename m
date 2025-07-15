Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AEC2EA159;
	Tue, 15 Jul 2025 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587304; cv=none; b=UVOZ0mJXQYYSyHy2L6atDIP7jeMQ6XLRb7wuRhVqD6b+kUdrKVOu62e2KW9Nm0GAOvl89b6sEZWAnL5sW014mcDi5cNEEC1Afbpb0Ogom1PG93Km4/hGpzMKArfvMHCQJcs44XQEzhewEHH/a8tQxfMHh+I3/Xh/P0G4bhIP0V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587304; c=relaxed/simple;
	bh=67wJzHMO0u6RvpEJEhXWnmH0TUaj+rRWUjxfn46dsEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAw5fJ/kYqBYG0O/fqRNiGhL66zdFgkZlgrdHo7Jt+FvCrYqZGwNNz4mAAoR1/RYxAIXXBhhEflQNKk7rORRUbWZ3jZSfSTcgofHMmWMtCVeqve5Sgjy/vNpl7YUAgGRA+Ta4wB9nlz6EZYuXV22Dvqkb5bW2pJ25ZVFZ6YY1IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYalLKcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYalLKcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60967C4CEE3;
	Tue, 15 Jul 2025 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587304;
	bh=67wJzHMO0u6RvpEJEhXWnmH0TUaj+rRWUjxfn46dsEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYalLKcX+YgWiEZDn2kr6Fwh3YDdDsPWNazqqIEQiBRSryS+Ju+7Tk13MLd0JrTtd
	 s/lkF/cI+fUikFMkJaAaFv+XAjapWm430rKJZiNsEUazMOf8SX5+Bia+glWcX1AuSG
	 4rQyKTUt1LwDVNItnCWz7Cd7KM0EB98pSAXzhrG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/88] usb: cdnsp: Fix issue with CV Bad Descriptor test
Date: Tue, 15 Jul 2025 15:14:27 +0200
Message-ID: <20250715130756.600822338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 2831a81077f5162f104ba5a97a7d886eb371c21c ]

The SSP2 controller has extra endpoint state preserve bit (ESP) which
setting causes that endpoint state will be preserved during
Halt Endpoint command. It is used only for EP0.
Without this bit the Command Verifier "TD 9.10 Bad Descriptor Test"
failed.
Setting this bit doesn't have any impact for SSP controller.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95382CCD50549DABAEFD6156DD7CA@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdnsp-debug.h  |  5 +++--
 drivers/usb/cdns3/cdnsp-ep0.c    | 18 +++++++++++++++---
 drivers/usb/cdns3/cdnsp-gadget.h |  6 ++++++
 drivers/usb/cdns3/cdnsp-ring.c   |  3 ++-
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-debug.h b/drivers/usb/cdns3/cdnsp-debug.h
index cd138acdcce16..86860686d8363 100644
--- a/drivers/usb/cdns3/cdnsp-debug.h
+++ b/drivers/usb/cdns3/cdnsp-debug.h
@@ -327,12 +327,13 @@ static inline const char *cdnsp_decode_trb(char *str, size_t size, u32 field0,
 	case TRB_RESET_EP:
 	case TRB_HALT_ENDPOINT:
 		ret = scnprintf(str, size,
-				"%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c",
+				"%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c %c",
 				cdnsp_trb_type_string(type),
 				ep_num, ep_id % 2 ? "out" : "in",
 				TRB_TO_EP_INDEX(field3), field1, field0,
 				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+				field3 & TRB_CYCLE ? 'C' : 'c',
+				field3 & TRB_ESP ? 'P' : 'p');
 		break;
 	case TRB_STOP_RING:
 		ret = scnprintf(str, size,
diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index f317d3c847810..5cd9b898ce971 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,6 +414,7 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
+	struct cdnsp_ep *pep;
 	int ret = -EINVAL;
 	u16 len;
 
@@ -427,10 +428,21 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 		goto out;
 	}
 
+	pep = &pdev->eps[0];
+
 	/* Restore the ep0 to Stopped/Running state. */
-	if (pdev->eps[0].ep_state & EP_HALTED) {
-		trace_cdnsp_ep0_halted("Restore to normal state");
-		cdnsp_halt_endpoint(pdev, &pdev->eps[0], 0);
+	if (pep->ep_state & EP_HALTED) {
+		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_HALTED)
+			cdnsp_halt_endpoint(pdev, pep, 0);
+
+		/*
+		 * Halt Endpoint Command for SSP2 for ep0 preserve current
+		 * endpoint state and driver has to synchronize the
+		 * software endpoint state with endpoint output context
+		 * state.
+		 */
+		pep->ep_state &= ~EP_HALTED;
+		pep->ep_state |= EP_STOPPED;
 	}
 
 	/*
diff --git a/drivers/usb/cdns3/cdnsp-gadget.h b/drivers/usb/cdns3/cdnsp-gadget.h
index 48336e121ed6f..155fd770a8cd9 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -987,6 +987,12 @@ enum cdnsp_setup_dev {
 #define STREAM_ID_FOR_TRB(p)		((((p)) << 16) & GENMASK(31, 16))
 #define SCT_FOR_TRB(p)			(((p) << 1) & 0x7)
 
+/*
+ * Halt Endpoint Command TRB field.
+ * The ESP bit only exists in the SSP2 controller.
+ */
+#define TRB_ESP				BIT(9)
+
 /* Link TRB specific fields. */
 #define TRB_TC				BIT(1)
 
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 795668435c77e..42db256978bcc 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2475,7 +2475,8 @@ void cdnsp_queue_halt_endpoint(struct cdnsp_device *pdev, unsigned int ep_index)
 {
 	cdnsp_queue_command(pdev, 0, 0, 0, TRB_TYPE(TRB_HALT_ENDPOINT) |
 			    SLOT_ID_FOR_TRB(pdev->slot_id) |
-			    EP_ID_FOR_TRB(ep_index));
+			    EP_ID_FOR_TRB(ep_index) |
+			    (!ep_index ? TRB_ESP : 0));
 }
 
 void cdnsp_force_header_wakeup(struct cdnsp_device *pdev, int intf_num)
-- 
2.39.5



