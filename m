Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7024FDE75;
	Tue, 13 Oct 2026 12:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895505; cv=none; b=Z/nEJLt2dXgA03pA3pqhAVxMs9adTyrG71Eyn5mZuVjqEmj/NtKQxEXZROS1lR3AJpSJaMzhSno0hWhtLxQCUYu26SFN+SKPky4lij0812Ge5HZllC3Q/0ear/ArjsSNfYAugYFvdp2z4e9RzQLCkVq1W57HyR3u+o7BpS4Xpm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895505; c=relaxed/simple;
	bh=pECGLrgxAQn5g0pB3mFKZRatXKYMPHWxPaMKvNB2/hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miycwdpcqEKZ0+F4na12cp+6yEhwC3OSU5m2O/eCLY/NXa+Sk17QXcqsbQhNnTPc2e+Kr91VK27UYHUOQBIseYFEIYqMsneYbmUhNnz/ZA6GDJaJdA6tKYK+g9GB7ZWJg+7OgddZ093QHISxuoggl0bu24qqC90Eja25t6iBGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ixg/G/NJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ixg/G/NJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BC91F000FF;
	Tue, 13 Oct 2026 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895504;
	bh=P8eqSU0yEFWelB44b1i13CcAYR5jmff0ruJAHVFdeMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ixg/G/NJboepP6oXMXTh1yMlio5AcdBsUaAuz/+4DrlSp9qkFO/fc/DXcp08S+ceQ
	 ewV/ABTSpPrml6IQl/THf2NbwWqD9yV8Km4ohSC1uV8MFAQNcbsUktF3zKu//CVFzq
	 vmwKsLrw1l+LUuQ6mK+5Tnrvia4wdWrs9Gax7ASU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/497] USB: dwc2: shut down wakeup timer before freeing HCD state
Date: Tue, 13 Oct 2026 13:37:44 +0200
Message-ID: <20261013112914.945988356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fd772af9512cdecb83de34a461801533828e77fd ]

dwc2_wakeup_detected() accesses the DWC2 host state and can rearm the
wakeup timer.  dwc2_hcd_free() currently deletes the timer only after
freeing host-owned state, and timer_delete() does not synchronize a
callback or prevent it from being queued again.

Stop and shut down the timer in dwc2_hcd_release(), before the HCD
resources are freed.  This covers both the HCD initialization error path
and normal HCD removal.

Fixes: 7359d482eb4d ("staging: HCD files for the DWC2 driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260904065323.4047026-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted timer_delete() removal to the existing del_timer() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 8e295f41fc13b..938b646c4b0f8 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5082,14 +5082,13 @@ static void dwc2_hcd_free(struct dwc2_hsotg *hsotg)
 	}
 
 	cancel_work_sync(&hsotg->phy_reset_work);
-
-	del_timer(&hsotg->wkp_timer);
 }
 
 static void dwc2_hcd_release(struct dwc2_hsotg *hsotg)
 {
 	/* Turn off all host-specific interrupts */
 	dwc2_disable_host_interrupts(hsotg);
+	timer_shutdown_sync(&hsotg->wkp_timer);
 
 	dwc2_hcd_free(hsotg);
 }
-- 
2.53.0



