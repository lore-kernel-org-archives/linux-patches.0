Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9D02494F0;
	Wed,  8 Apr 2026 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672698; cv=none; b=BAC6kFAQepEyUKw/IJzLZNmww75F7fttIQEgpyMnLYepOHS0EUoVqRLcDXpzCSctVjq7LOs/f4/QlJFaqzFTQDrkLlB4z8DtkL/EbiOB4RvVXYTcls2FmdvKcbXCIWj4RrxM9YauY2ZuZwvpFt8x+EMwF2qddQGr0327gOy5mE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672698; c=relaxed/simple;
	bh=bDcunfu5/TBMHacGmFpeWUkm7yID2zhiIsztcy16clU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRQ8CTxzTvkmMp7t1UXg59pstwr4nAaDGcXVW0q3grFn29nshMtvEwwY6xHcB2fpEbBAb3oE8cyhwlvrZN5Ggi/7vqXig28E8T6gIRo7BgxMil9iH1vgD8wc4oMTXvcqgqRD8Q1Tx9MJJ+/WoKNmtr2HgdOs+RYkDCW5tpbnx2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jE56+bUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jE56+bUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC35C19421;
	Wed,  8 Apr 2026 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672698;
	bh=bDcunfu5/TBMHacGmFpeWUkm7yID2zhiIsztcy16clU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jE56+bUqFVgIcVz9WCEFthIF9eVEa6YcjCGPD9IVL4WBfJnuLOW7lzA8fEnFsBVCg
	 C4BCGcKDga507/WPnQvZ8ahFyyCnTusMwGG5heBjhpARqOdHC2IMszvEE91liv5iIH
	 IFQaiMjA1ANrNrD5yXh21IcKSNn8cxgtsdOlyrdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Juno Choi <juno.choi@lge.com>
Subject: [PATCH 6.6 108/160] usb: dwc2: gadget: Fix spin_lock/unlock mismatch in dwc2_hsotg_udc_stop()
Date: Wed,  8 Apr 2026 20:03:15 +0200
Message-ID: <20260408175917.215293535@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4604,7 +4604,9 @@ static int dwc2_hsotg_udc_stop(struct us
 	/* Exit clock gating when driver is stopped. */
 	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
 	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
+		spin_lock_irqsave(&hsotg->lock, flags);
 		dwc2_gadget_exit_clock_gating(hsotg, 0);
+		spin_unlock_irqrestore(&hsotg->lock, flags);
 	}
 
 	/* all endpoints should be shutdown */


