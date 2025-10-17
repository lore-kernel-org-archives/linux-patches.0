Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA833711A;
	Fri, 17 Oct 2025 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713165; cv=none; b=WjdQQ6ce3Cy+4dsXLZfX7XxumueLewcplYFlpzSWT27Jxvtm48M88dM7KqBU6iJWHVUeV4VYQOX5JtFPPMOpG1iLEFHC0aDc7FQlnSk+RbDLOEnbyJYUSlJjurLFGWAST21PJ4KkvxEyJgSxJhxzv/OJJhqLLp/QRBKLXNZzAXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713165; c=relaxed/simple;
	bh=Y3zYmgeecGehMD8y8dTuSI9erRGfJnfgOK8Rx5TUZOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKNwg+bsWm+NqiHNME9IWdJzCxpFXG7367Pekvt73bswiDAAtyX5Ax0zneYPBfsQc5/8+dzhH41JrhMDioMJHTFghMzK1Tq0NcwT8bnSKSNq/NxFJic7QI7kkKUt/4nc1r/IwvONOthvgFYqEf0YqnHd4XgT5p/efSadL9rim6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGRTfEk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGRTfEk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBBDC4CEF9;
	Fri, 17 Oct 2025 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713165;
	bh=Y3zYmgeecGehMD8y8dTuSI9erRGfJnfgOK8Rx5TUZOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGRTfEk8mKDcerc5G49SxYPrKH8PrxtD7/vIxpi3eO9UctvJggqa6CPb8+7YacHRD
	 3JkAQMXKuLsivrahqW7Y9sP3ndmns1yZrXqH6rmHJaIVt7Vz0JsWypLodpI18291TB
	 shNqitC2a+I/Zzb1C4+UTndr3KqOzBwSotFJxjLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Xue <zxue@semtech.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 6.1 071/168] bus: mhi: host: Do not use uninitialized dev pointer in mhi_init_irq_setup()
Date: Fri, 17 Oct 2025 16:52:30 +0200
Message-ID: <20251017145131.642574510@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,7 +164,6 @@ void mhi_deinit_free_irq(struct mhi_cont
 int mhi_init_irq_setup(struct mhi_controller *mhi_cntrl)
 {
 	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
-	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	unsigned long irq_flags = IRQF_SHARED | IRQF_NO_SUSPEND;
 	int i, ret;
 
@@ -191,7 +190,7 @@ int mhi_init_irq_setup(struct mhi_contro
 			continue;
 
 		if (mhi_event->irq >= mhi_cntrl->nr_irqs) {
-			dev_err(dev, "irq %d not available for event ring\n",
+			dev_err(mhi_cntrl->cntrl_dev, "irq %d not available for event ring\n",
 				mhi_event->irq);
 			ret = -EINVAL;
 			goto error_request;
@@ -202,7 +201,7 @@ int mhi_init_irq_setup(struct mhi_contro
 				  irq_flags,
 				  "mhi", mhi_event);
 		if (ret) {
-			dev_err(dev, "Error requesting irq:%d for ev:%d\n",
+			dev_err(mhi_cntrl->cntrl_dev, "Error requesting irq:%d for ev:%d\n",
 				mhi_cntrl->irq[mhi_event->irq], i);
 			goto error_request;
 		}


