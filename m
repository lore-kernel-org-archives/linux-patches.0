Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97376280CFB;
	Mon, 13 Apr 2026 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098300; cv=none; b=mpsvb6cBZDf0O3tP0RSA8wCUSGL1TCgpnK7lEzQkcluQ6BIPNujcr9Ru4lsZFc4H+qJMuw018kxYGnnhoBKX5EOyJuaNPfnkb45oD2YctPNbaOuCc81fMoKDVsnA5hasL5SyegHVyH2Tsc2zSUOqDOVK8y2gh+nZwp8rFH0MD4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098300; c=relaxed/simple;
	bh=Iu1NwpXC8RtxxdV3WR0Jis31ERl6xcqfqg8l8/OpkYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLjn3ZjNkazV/F/f88w+S9yELKyqLmL0SEipMTH3Lc0w7195+c8i3w4rxpc8UZHLUls7TJf+X3FSYvzv379LDhJFvPYfdhHr9p19KHXsxUB8YyFhrsV2loiQgZcmt8lOny49aVMF1/VLUYmQNFt9X6/qtXLA5PmeyrQuFDsfUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahnEB7r2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahnEB7r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E497C2BCAF;
	Mon, 13 Apr 2026 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098300;
	bh=Iu1NwpXC8RtxxdV3WR0Jis31ERl6xcqfqg8l8/OpkYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahnEB7r2Az3PhyjFYnLe4zMlqGo7WKY1L5EewKfa4SEZn1ppDXp16TARDTpD29d23
	 kS3KdKO6ZEgBvhz0kbgh5sLfMGAvOi1/dHpfWaep3SmAVId4P/a1Pey0zUeOF8hfpD
	 k+y5bGOfhgnYb+p7cJr2ZA+4TGXhkVL+NCl9fDjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Juno Choi <juno.choi@lge.com>
Subject: [PATCH 5.15 470/570] usb: dwc2: gadget: Fix spin_lock/unlock mismatch in dwc2_hsotg_udc_stop()
Date: Mon, 13 Apr 2026 18:00:01 +0200
Message-ID: <20260413155848.071581383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juno Choi <juno.choi@lge.com>

commit 9bb4b5ed7f8c4f95cc556bdf042b0ba2fa13557a upstream.

dwc2_gadget_exit_clock_gating() internally calls call_gadget() macro,
which expects hsotg->lock to be held since it does spin_unlock/spin_lock
around the gadget driver callback invocation.

However, dwc2_hsotg_udc_stop() calls dwc2_gadget_exit_clock_gating()
without holding the lock. This leads to:
 - spin_unlock on a lock that is not held (undefined behavior)
 - The lock remaining held after dwc2_gadget_exit_clock_gating() returns,
   causing a deadlock when spin_lock_irqsave() is called later in the
   same function.

Fix this by acquiring hsotg->lock before calling
dwc2_gadget_exit_clock_gating() and releasing it afterwards, which
satisfies the locking requirement of the call_gadget() macro.

Fixes: af076a41f8a2 ("usb: dwc2: also exit clock_gating when stopping udc while suspended")
Cc: stable <stable@kernel.org>
Signed-off-by: Juno Choi <juno.choi@lge.com>
Link: https://patch.msgid.link/20260324014910.2798425-1-juno.choi@lge.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4605,7 +4605,9 @@ static int dwc2_hsotg_udc_stop(struct us
 	/* Exit clock gating when driver is stopped. */
 	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
 	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
+		spin_lock_irqsave(&hsotg->lock, flags);
 		dwc2_gadget_exit_clock_gating(hsotg, 0);
+		spin_unlock_irqrestore(&hsotg->lock, flags);
 	}
 
 	/* all endpoints should be shutdown */


