Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F1B168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40691C433EF;
	Mon,  8 May 2023 10:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541427;
	bh=c4s/d7N9CygnHM5HXhDB3gqOhdRQiA9yT9344RTsDz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCzvwo7zeINfCwH6sUInWkQIBLkF886OmorQOAhL3VD8MNbEIMBslfFnyqBfPctNR
	 QfGjnfIZp1axxgHjjsrsGbmK9knQTkmWeJSETLG23A8LsT+quFGqthF2zlhupNOdYi
	 l6CctvpPVK4SS3Aa73pD3dSWxJsG5FCbV358QVoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Carl Vanderlip <quic_carlv@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.2 112/663] bus: mhi: host: Remove duplicate ee check for syserr
Date: Mon,  8 May 2023 11:38:58 +0200
Message-Id: <20230508094432.130386788@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

commit d469d9448a0f1a33c175d3280b1542fa0158ad7a upstream.

If we detect a system error via intvec, we only process the syserr if the
current ee is different than the last observed ee.  The reason for this
check is to prevent bhie from running multiple times, but with the single
queue handling syserr, that is not possible.

The check can cause an issue with device recovery.  If PBL loads a bad SBL
via BHI, but that SBL hangs before notifying the host of an ee change,
then issuing soc_reset to crash the device and retry (after supplying a
fixed SBL) will not recover the device as the host will observe a PBL->PBL
transition and not process the syserr.  The device will be stuck until
either the driver is reloaded, or the host is rebooted.  Instead, remove
the check so that we can attempt to recover the device.

Fixes: ef2126c4e2ea ("bus: mhi: core: Process execution environment changes serially")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Carl Vanderlip <quic_carlv@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/1681142292-27571-2-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -503,7 +503,7 @@ irqreturn_t mhi_intvec_threaded_handler(
 	}
 	write_unlock_irq(&mhi_cntrl->pm_lock);
 
-	if (pm_state != MHI_PM_SYS_ERR_DETECT || ee == mhi_cntrl->ee)
+	if (pm_state != MHI_PM_SYS_ERR_DETECT)
 		goto exit_intvec;
 
 	switch (ee) {


