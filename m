Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E12219A7A;
	Fri, 17 Oct 2025 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714376; cv=none; b=WmKIFTBaD+FCmUrXzd0NO1OG2WXrYuuv4nLA4Mdoxzi6nYKi3u1CNNROXrloM9RGm8G54AiFoNXDeLVEuL2TG6M5oZM0hiWAX2IggQqHa0cdM5dKXqVENLUu38thyX6kYcM740OP/qt6A1EYLrAM0ITshpb5qjbykOl8tmsE+wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714376; c=relaxed/simple;
	bh=DQdcVicKusiqanJ070YJtXO6FrmMiSx6G1xQF0F21f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9OozpyH0bkM2XrfqusO36UxjpeMo52e+/MQzGU2hqkq4SYEOSEPPp+mTAwGMa+a2E/oMJmUUKTjaUXVUQTVG9xHvgmvVodPGCK6KupSLZQRMG9ehLOpNVXSVkKJyeQhhn7hx9xNDm+1/+0xDyJ9Ql4Z9UCCCpvS3eR4AarinBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esLEg+0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esLEg+0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950D6C4CEE7;
	Fri, 17 Oct 2025 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714376;
	bh=DQdcVicKusiqanJ070YJtXO6FrmMiSx6G1xQF0F21f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esLEg+0Oe4LGE4Edyd1kzRjawFOc91STj17MMSWyMkjZsWhOOYSiLG/9O8yqL2Udr
	 ZFH0Meu4KQ/vtwVtcAiuwIX1ltkUX47kDq52jhr/9TdxGCKVm1rE7eiwJsJcTU77xe
	 VdDb0R4iTn7x5xAFpwDVuBrLX7t3tCGl1c08hpsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Xue <zxue@semtech.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 6.12 123/277] bus: mhi: host: Do not use uninitialized dev pointer in mhi_init_irq_setup()
Date: Fri, 17 Oct 2025 16:52:10 +0200
Message-ID: <20251017145151.616304988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Adam Xue <zxue@semtech.com>

commit d0856a6dff57f95cc5d2d74e50880f01697d0cc4 upstream.

In mhi_init_irq_setup, the device pointer used for dev_err() was not
initialized. Use the pointer from mhi_cntrl instead.

Fixes: b0fc0167f254 ("bus: mhi: core: Allow shared IRQ for event rings")
Fixes: 3000f85b8f47 ("bus: mhi: core: Add support for basic PM operations")
Signed-off-by: Adam Xue <zxue@semtech.com>
[mani: reworded subject/description and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250905174118.38512-1-zxue@semtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/init.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/bus/mhi/host/init.c
+++ b/drivers/bus/mhi/host/init.c
@@ -194,7 +194,6 @@ void mhi_deinit_free_irq(struct mhi_cont
 int mhi_init_irq_setup(struct mhi_controller *mhi_cntrl)
 {
 	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
-	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	unsigned long irq_flags = IRQF_SHARED | IRQF_NO_SUSPEND;
 	int i, ret;
 
@@ -221,7 +220,7 @@ int mhi_init_irq_setup(struct mhi_contro
 			continue;
 
 		if (mhi_event->irq >= mhi_cntrl->nr_irqs) {
-			dev_err(dev, "irq %d not available for event ring\n",
+			dev_err(mhi_cntrl->cntrl_dev, "irq %d not available for event ring\n",
 				mhi_event->irq);
 			ret = -EINVAL;
 			goto error_request;
@@ -232,7 +231,7 @@ int mhi_init_irq_setup(struct mhi_contro
 				  irq_flags,
 				  "mhi", mhi_event);
 		if (ret) {
-			dev_err(dev, "Error requesting irq:%d for ev:%d\n",
+			dev_err(mhi_cntrl->cntrl_dev, "Error requesting irq:%d for ev:%d\n",
 				mhi_cntrl->irq[mhi_event->irq], i);
 			goto error_request;
 		}


