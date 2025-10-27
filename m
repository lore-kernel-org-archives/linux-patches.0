Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7D91B424F;
	Mon, 27 Oct 2025 19:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593408; cv=none; b=auRNp6bZaDXxMNYSQFd0MKG3Jr+6CGywoEmUrWv5z0bH+bHP/av4thWmlI63j1ZUmlSE+S+PcL58cqELm3YoosFXSohE1hEXGHd+D6JB5ORH1WWNFFgVhCrOO0gBO17UMrn4gTNk5EtwTLFYnvjk0zW75l2AgKarh8fIxrsHoHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593408; c=relaxed/simple;
	bh=9oFsYGw38X7HDdIGKBP1diUFaCssbkmF/zUAC+MOvlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi5grEYd0pcdd7FGgUB3kL73xbugX94czI1mieTd2OYSDxzOQwSWIshWktXFr17B5zJYiBG7fiYerUIOEABF+GER9rqTfIdKk+CTcHpTxC02UDV0uwvU7rymvpgMiSG7JU2mQHD5cwIj8KF242QShlrV/ncnY/TeDVf4olHJrWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgXgscn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgXgscn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F9FC4CEF1;
	Mon, 27 Oct 2025 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593408;
	bh=9oFsYGw38X7HDdIGKBP1diUFaCssbkmF/zUAC+MOvlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgXgscn7qIRzIV5/YmHAhqLNSQxP+dg6zfe6X3/H+GX5z2cxT7fHfivLHwfp7UeqB
	 LnMBIT0puwuOom7KW+WEfu4/IhFUAHvBeuczenWF/PmCvLpu972BUT36ySEddUjuhx
	 UIku/XLUae+43cT2U2Nm8itOy0/4VA/vDkdqYWQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Artem Shimko <a.shimko.dev@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/184] firmware: arm_scmi: Fix premature SCMI_XFER_FLAG_IS_RAW clearing in raw mode
Date: Mon, 27 Oct 2025 19:36:47 +0100
Message-ID: <20251027183518.309735950@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Shimko <a.shimko.dev@gmail.com>

[ Upstream commit 20b93a0088a595bceed4a026d527cbbac4e876c5 ]

The SCMI_XFER_FLAG_IS_RAW flag was being cleared prematurely in
scmi_xfer_raw_put() before the transfer completion was properly
acknowledged by the raw message handlers.

Move the clearing of SCMI_XFER_FLAG_IS_RAW and SCMI_XFER_FLAG_CHAN_SET
from scmi_xfer_raw_put() to __scmi_xfer_put() to ensure the flags remain
set throughout the entire raw message processing pipeline until the
transfer is returned to the free pool.

Fixes: 3095a3e25d8f ("firmware: arm_scmi: Add xfer helpers to provide raw access")
Suggested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Artem Shimko <a.shimko.dev@gmail.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20251008091057.1969260-1-a.shimko.dev@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 1cd15412024cd..a8f2247feab9d 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -805,6 +805,7 @@ __scmi_xfer_put(struct scmi_xfers_info *minfo, struct scmi_xfer *xfer)
 
 			scmi_dec_count(info->dbg, XFERS_INFLIGHT);
 		}
+		xfer->flags = 0;
 		hlist_add_head(&xfer->node, &minfo->free_xfers);
 	}
 	spin_unlock_irqrestore(&minfo->xfer_lock, flags);
@@ -823,8 +824,6 @@ void scmi_xfer_raw_put(const struct scmi_handle *handle, struct scmi_xfer *xfer)
 {
 	struct scmi_info *info = handle_to_scmi_info(handle);
 
-	xfer->flags &= ~SCMI_XFER_FLAG_IS_RAW;
-	xfer->flags &= ~SCMI_XFER_FLAG_CHAN_SET;
 	return __scmi_xfer_put(&info->tx_minfo, xfer);
 }
 
-- 
2.51.0



