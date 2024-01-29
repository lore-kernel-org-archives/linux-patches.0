Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378E66F062;
	Mon, 29 Jan 2024 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548457; cv=none; b=klOeP83JmL7ybOSZTaR8qoXd7cMmc+LAZ+px3S0velSC0tXgN9/HCBl08Ls2OEvBRa8Jjzm6n2lByJl2ErU5ygPJFc743Rmj3Jv2HTF2zdYUMsZRx5zqXzSxyrsM46wp5eSD09BDVmql/eIN3zI2baAfRIAdmDm4FVZUiTbF8+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548457; c=relaxed/simple;
	bh=/RVfp5prStTJF0adS/CjGVF1PJLp1AlpxJS7me7SVl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQelEuoL+u3gL3OiMoKCafPJ8LP/vVaCMDBx+wPtOpBOa5EO/mDOSYLvx+SLMcpkAA5HWBX1SlZzAFw+g/ClgVeAXZti15jZFhh/9hSIW0ono8gakTJN4vMv3WjPOv/l+1U+wkmwSkZj9/ALCfGTDWVNRqTCH1ScAl+OGMO+g3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLP9LX3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLP9LX3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26A6C433C7;
	Mon, 29 Jan 2024 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548457;
	bh=/RVfp5prStTJF0adS/CjGVF1PJLp1AlpxJS7me7SVl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLP9LX3iqMz2K18TOiR/VxeE9voQ7zyprGtujir2BwiBwrChLc4+6CBNlQJgt2e/i
	 yCyETzHLo3l9YuFtY3Lsf3xlWJimpb2nsQj6kX9sdFStSdJC9TCfKxPNNE3cidFe8Y
	 ADv1ICaJOoeULSEnzm45fMF1GoP1VJSMdInjWqqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhaumik Bhatt <bbhatt@codeaurora.org>,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.6 069/331] bus: mhi: host: Add spinlock to protect WP access when queueing TREs
Date: Mon, 29 Jan 2024 09:02:13 -0800
Message-ID: <20240129170016.945886064@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

commit b89b6a863dd53bc70d8e52d50f9cfaef8ef5e9c9 upstream.

Protect WP accesses such that multiple threads queueing buffers for
incoming data do not race.

Meanwhile, if CONFIG_TRACE_IRQFLAGS is enabled, irq will be enabled once
__local_bh_enable_ip is called as part of write_unlock_bh. Hence, let's
take irqsave lock after TRE is generated to avoid running write_unlock_bh
when irqsave lock is held.

Cc: stable@vger.kernel.org
Fixes: 189ff97cca53 ("bus: mhi: core: Add support for data transfer")
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Tested-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1702276972-41296-2-git-send-email-quic_qianyu@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -1127,17 +1127,15 @@ static int mhi_queue(struct mhi_device *
 	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)))
 		return -EIO;
 
-	read_lock_irqsave(&mhi_cntrl->pm_lock, flags);
-
 	ret = mhi_is_ring_full(mhi_cntrl, tre_ring);
-	if (unlikely(ret)) {
-		ret = -EAGAIN;
-		goto exit_unlock;
-	}
+	if (unlikely(ret))
+		return -EAGAIN;
 
 	ret = mhi_gen_tre(mhi_cntrl, mhi_chan, buf_info, mflags);
 	if (unlikely(ret))
-		goto exit_unlock;
+		return ret;
+
+	read_lock_irqsave(&mhi_cntrl->pm_lock, flags);
 
 	/* Packet is queued, take a usage ref to exit M3 if necessary
 	 * for host->device buffer, balanced put is done on buffer completion
@@ -1157,7 +1155,6 @@ static int mhi_queue(struct mhi_device *
 	if (dir == DMA_FROM_DEVICE)
 		mhi_cntrl->runtime_put(mhi_cntrl);
 
-exit_unlock:
 	read_unlock_irqrestore(&mhi_cntrl->pm_lock, flags);
 
 	return ret;
@@ -1209,6 +1206,9 @@ int mhi_gen_tre(struct mhi_controller *m
 	int eot, eob, chain, bei;
 	int ret;
 
+	/* Protect accesses for reading and incrementing WP */
+	write_lock_bh(&mhi_chan->lock);
+
 	buf_ring = &mhi_chan->buf_ring;
 	tre_ring = &mhi_chan->tre_ring;
 
@@ -1226,8 +1226,10 @@ int mhi_gen_tre(struct mhi_controller *m
 
 	if (!info->pre_mapped) {
 		ret = mhi_cntrl->map_single(mhi_cntrl, buf_info);
-		if (ret)
+		if (ret) {
+			write_unlock_bh(&mhi_chan->lock);
 			return ret;
+		}
 	}
 
 	eob = !!(flags & MHI_EOB);
@@ -1244,6 +1246,8 @@ int mhi_gen_tre(struct mhi_controller *m
 	mhi_add_ring_element(mhi_cntrl, tre_ring);
 	mhi_add_ring_element(mhi_cntrl, buf_ring);
 
+	write_unlock_bh(&mhi_chan->lock);
+
 	return 0;
 }
 


