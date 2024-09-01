Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6294E44C97;
	Sun,  1 Sep 2024 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208118; cv=none; b=j319gtqJwD429seJfDjxDyQVVhge0q2zCglhUlWBXoiqWLAOQuyhzHqzqwIdN5cgDV/UiM5ZpRbFJE1YfJxNgxwPh914/DCLKCgBbdkS6Jl53TurVOMXA41MRLTseeLlXjlW9PIHysEdWLdphxupj0c8Xq//Mba+ZEsmfFeu/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208118; c=relaxed/simple;
	bh=8gjeOA39JZ6EPBdG+zACjetyDvv8c+hmwpJvD/8uOMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8yVr7X1QBGaaGDNJDASOrfrcViW4/Lm6mn/D7kalurwqt73qk4j/wLmT0Urn9elfJp+yw5ycXYo6sZWUCTzVhbgeQjwe/SSy7uYISE4uYRI4Z5pMNj0ghQuLoIw/zYCaGWBGP0UcHrzqOrIOKLc+OE19CfWGzj2gcHBsSa1hmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXz8ITR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXz8ITR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69731C4CEC3;
	Sun,  1 Sep 2024 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208117;
	bh=8gjeOA39JZ6EPBdG+zACjetyDvv8c+hmwpJvD/8uOMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXz8ITR21J6a7O90jMOHp6BUt7ni/7fiOPjFkDygSKC2mJ7+pKZqsNh++c3s0DEEW
	 QjLLVwc4cpKcUgc0IdCEC0mXZfZSGbgFPFXO+m6eTR9UKJuTWitxdDckSQuT6F3St1
	 ubtQDsczkIcV1yoJKOJOplYJhG6stRXHe1XlO1Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 79/93] usb: dwc3: core: Prevent USB core invalid event buffer address access
Date: Sun,  1 Sep 2024 18:17:06 +0200
Message-ID: <20240901160810.709825835@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit 14e497183df28c006603cc67fd3797a537eef7b9 upstream.

This commit addresses an issue where the USB core could access an
invalid event buffer address during runtime suspend, potentially causing
SMMU faults and other memory issues in Exynos platforms. The problem
arises from the following sequence.
        1. In dwc3_gadget_suspend, there is a chance of a timeout when
        moving the USB core to the halt state after clearing the
        run/stop bit by software.
        2. In dwc3_core_exit, the event buffer is cleared regardless of
        the USB core's status, which may lead to an SMMU faults and
        other memory issues. if the USB core tries to access the event
        buffer address.

To prevent this hardware quirk on Exynos platforms, this commit ensures
that the event buffer address is not cleared by software  when the USB
core is active during runtime suspend by checking its status before
clearing the buffer address.

Cc: stable <stable@kernel.org>
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240815064836.1491-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -553,9 +553,17 @@ int dwc3_event_buffers_setup(struct dwc3
 void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
+	u32				reg;
 
 	if (!dwc->ev_buf)
 		return;
+	/*
+	 * Exynos platforms may not be able to access event buffer if the
+	 * controller failed to halt on dwc3_core_exit().
+	 */
+	reg = dwc3_readl(dwc->regs, DWC3_DSTS);
+	if (!(reg & DWC3_DSTS_DEVCTRLHLT))
+		return;
 
 	evt = dwc->ev_buf;
 


