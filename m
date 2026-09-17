Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E8A51AEC2;
	Thu, 17 Sep 2026 16:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664188; cv=none; b=fFNcMxKqbpJRhEpJyxvVHTIPzJqok7T037ykbkMTExq4dNeBWeQZ7TOwTpP+2I7tsSu3nj+AscXmoQ7tit4mDR99mPyCmGs1nPyV5qiUzBOeBlnyduuk0EZZ4M5JwmKrmco9QIFyJ+6ckCjnj8Dyj12KIdiyxuUhXswbQkUljsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664188; c=relaxed/simple;
	bh=x6bDvR2fsyX8InyCAMdJYzK1N/t1aN12S8M9TTskWio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtFokRU69xyV9KD/hEGaglhCnv88bNokBpkoEhRvwZBN2mRDpgSTxB52Fen2Cm8aRsqWkGujdRSvxUSrzq+oWddCz0teiXfWMLR/paO3muUnoPAZU8m+UEOyVfm1aFGoN87NGX4ujvVWU41lbX4PzEzUV1w/tQklb2j/8wYPi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMtuQ9mK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMtuQ9mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39C91F000FF;
	Thu, 17 Sep 2026 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664187;
	bh=bTV0uiPynQFE2lbkik7t5hkvPhAejmZbg6UVC6Ujg+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMtuQ9mK1YxVnadvPEVLlw8LLFGERzjkjTTb8LpXZ4teDtKcW5ZMqvKOylLgIaSFH
	 GuAkE9jqZH5nv4tXme9DVx5s9R7uBGT3TBxPSFagWBb7RUzg0411m00Ai4NXV6bHka
	 dvdMjM9uq/bIw5fy5eW9bzZSfwn8reC4JaccOtFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0287/1250] net: wwan: t7xx: Add delay between MD and SAP suspend
Date: Thu, 17 Sep 2026 16:01:22 +0100
Message-ID: <20260917151559.909618243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit ae733795e593272f67d607c09d2a00637ac13ed0 ]

SAP (Service Access Point) suspend occasionally times out with error
-110 (ETIMEDOUT), followed by modem port errors and complete modem
failure requiring a system reboot to recover.

Error symptoms:
  mtk_t7xx 0000:72:00.0: [PM] SAP suspend error: -110
  mtk_t7xx 0000:72:00.0: can't suspend (...returned -110)
  mtk_t7xx 0000:07:00.0: Failed to send skb: -22
  mtk_t7xx 0000:07:00.0: Write error on MBIM port, -22

The modem firmware needs time after receiving the MD (modem) suspend
request to complete internal operations before it is ready to accept
the SAP suspend request. Without this delay, if runtime PM attempts
to suspend while the firmware is busy, the SAP suspend command times
out, leaving the modem in an unrecoverable state.

Root cause and userspace interaction:
ModemManager 1.24+ includes changes that reduce the likelihood of this
issue by ensuring the modem is in a low-power state before the kernel
attempts runtime suspend. However, the kernel driver should not depend
on specific userspace behavior or ModemManager versions. Older versions
(1.20-1.22) are still widely deployed, and the kernel should be robust
regardless of userspace implementation details.

There appears to be no hardware status register or other mechanism
available to query whether the firmware is ready for SAP suspend.
A delay between the two suspend requests is the most reliable solution
found through testing.

Add a 50ms delay between MD suspend and SAP suspend. This gives the
firmware adequate time to complete internal operations without adding
significant latency to the suspend path. This makes the driver robust
across all ModemManager versions and system conditions.

Testing: 96+ hours of continuous operation with ModemManager 1.20.2
and Fibocom FM350-GL modem. Zero SAP suspend timeouts observed across
2000+ successful suspend/resume cycles. Previously failed within
24 hours with 100% reproducibility.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260527061451.12710-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index eb137e0784232..46613bba1f411 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -447,6 +447,9 @@ static int __t7xx_pci_pm_suspend(struct pci_dev *pdev)
 		goto abort_suspend;
 	}
 
+	/* Delay to prevent SAP suspend timeout */
+	msleep(50);
+
 	ret = t7xx_send_pm_request(t7xx_dev, H2D_CH_SUSPEND_REQ_AP);
 	if (ret) {
 		t7xx_send_pm_request(t7xx_dev, H2D_CH_RESUME_REQ);
-- 
2.53.0



