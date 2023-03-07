Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F959BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74A0C433EF;
	Tue,  7 Mar 2023 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214650;
	bh=RiCNwv1Awez4l2RQhlpLXXi8EvXGX1zPvdyL8Kt58n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvk5MdI0ONQRny/7zSP5E/FGTm0v5WvYFOT++4W9uwuc+LgmEsZ7EGBFjDb4W6/Od
	 A9hQMYWuZGGFdqklcdbwrqfu7hFW/+nXu/Vqkhse7MYdWzJmxxtO9bWpbKADhl21U5
	 mlehi8v7rHwXkLZNfiH1dZvZD8bnFEGEJPBb69oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.1 869/885] bus: mhi: ep: Only send -ENOTCONN status if client driver is available
Date: Tue,  7 Mar 2023 18:03:23 +0100
Message-Id: <20230307170039.533206362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit e6cebcc27519dcf1652e604c73b9fd4f416987c0 upstream.

For the STOP and RESET commands, only send the channel disconnect status
-ENOTCONN if client driver is available. Otherwise, it will result in
null pointer dereference.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: e827569062a8 ("bus: mhi: ep: Add support for processing command rings")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221228161704.255268-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/main.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -196,9 +196,11 @@ static int mhi_ep_process_cmd_ring(struc
 		mhi_ep_mmio_disable_chdb(mhi_cntrl, ch_id);
 
 		/* Send channel disconnect status to client drivers */
-		result.transaction_status = -ENOTCONN;
-		result.bytes_xferd = 0;
-		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		if (mhi_chan->xfer_cb) {
+			result.transaction_status = -ENOTCONN;
+			result.bytes_xferd = 0;
+			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		}
 
 		/* Set channel state to STOP */
 		mhi_chan->state = MHI_CH_STATE_STOP;
@@ -228,9 +230,11 @@ static int mhi_ep_process_cmd_ring(struc
 		mhi_ep_ring_reset(mhi_cntrl, ch_ring);
 
 		/* Send channel disconnect status to client driver */
-		result.transaction_status = -ENOTCONN;
-		result.bytes_xferd = 0;
-		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		if (mhi_chan->xfer_cb) {
+			result.transaction_status = -ENOTCONN;
+			result.bytes_xferd = 0;
+			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		}
 
 		/* Set channel state to DISABLED */
 		mhi_chan->state = MHI_CH_STATE_DISABLED;


