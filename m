Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BFE183CBF;
	Sun,  1 Sep 2024 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209121; cv=none; b=KvGByLyCGxXwfiYumJP0nwRT4XFDDpPEfevPkH8pN7UqsnS0zeeUSJ4Iga+EcPkYa8eaNUNt3YhkOmyhYmWAdovV6a7BPg4Cp5PApO8ArT878D5Hl/RWwh7Af43Z6mrwy/LjyA3qkKUdb1hBC22HgOgoXofEOib7sHktNxMfdC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209121; c=relaxed/simple;
	bh=yTjgF1NZzdvnWTQF9NbsuY4Oz/hb/9Lk3RTGHV0a+C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDOZsMFk/8gi81bGeDioV/Fs3qi3A25SfqPavsiNspzLttndNLW+JVFH7ZEU7QSnEbkGz87MeGU54urIm4dzjr5moS4BaBy3wkHGas4L9452OUMUwlHwBT9kJOOj1s4LoMrLUqyAdV4RL7LeO4aK6cg9k3mTHTGYtUt2GVqOlg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsJkZp7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsJkZp7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1E0C4CEC3;
	Sun,  1 Sep 2024 16:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209120;
	bh=yTjgF1NZzdvnWTQF9NbsuY4Oz/hb/9Lk3RTGHV0a+C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsJkZp7kWBYUNUnfFFJE4Fhlx1IhC/eKIctAcj3Y7osUAw3vc0IwLsrYZvZ8/muTM
	 s1tH9zJr2MfgJKG8RlLIg/9hp+KUJTcxoeXQCvZmAbsR2H4j9ygk22Um9P11uuvbqz
	 K4on2F2pjvx0JYvQdy+0xVbvcJvWoe14+UsFYZTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 129/134] usb: dwc3: core: Prevent USB core invalid event buffer address access
Date: Sun,  1 Sep 2024 18:17:55 +0200
Message-ID: <20240901160814.932726336@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -438,9 +438,17 @@ int dwc3_event_buffers_setup(struct dwc3
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
 


