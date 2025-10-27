Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF7322745;
	Mon, 27 Oct 2025 19:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593043; cv=none; b=QTktwFGGktrCwbVgAyyb5J2dIzrcoDU7ssmeTb2TY2QV6tVYXIIHWzfAh4geSjXN6Uf8Ovh8BW/EuSJaF/dB4spTEzf9JRBSW5/hbkNUmY7VSUs2YPfWFRM76W1CMj7gu5YitqX2qXU4lnJle7vAnMZq2MZ6ViRsItiEHM13zSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593043; c=relaxed/simple;
	bh=S/YEs79iBkTOh00p5nfHf0U90MHlDSQ3XqYZb8U74iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htlaNOi3ip6zNT8naVhTED6VCwxai2WmRyhXZJBpZBG1U5Nl+Fbg+9y+wQ+0y69o7VQA8lAOjAcInbNuJzanpsQZ52X67r7edp3g1hwjOIj0wMCEHmcJIPW9YYuknc0lngpvsP8JrE8739bfGowdtz6lS/OkUJXIHjTHygfFacw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ+OEfL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ+OEfL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603B1C4CEF1;
	Mon, 27 Oct 2025 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593043;
	bh=S/YEs79iBkTOh00p5nfHf0U90MHlDSQ3XqYZb8U74iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZ+OEfL0t6xhtMVf3Usiwk2EU6FEn99UH7mGKjGFe3Y7kW88lMMlenQ96EdPPgLht
	 3dmOKUhipfxvHp43gt057ff6OCAO++skKYdrXfhU/gYhziX++QamzYiL7tC+sBXpwt
	 gltb9AWKfFQZyGjzDp4R5tskfOb4aUqIupR5ghNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Artem Shimko <a.shimko.dev@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/117] firmware: arm_scmi: Fix premature SCMI_XFER_FLAG_IS_RAW clearing in raw mode
Date: Mon, 27 Oct 2025 19:36:39 +0100
Message-ID: <20251027183455.995269814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
index 5b4df0a27e22f..79866f3b6b3e7 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -771,6 +771,7 @@ __scmi_xfer_put(struct scmi_xfers_info *minfo, struct scmi_xfer *xfer)
 			hash_del(&xfer->node);
 			xfer->pending = false;
 		}
+		xfer->flags = 0;
 		hlist_add_head(&xfer->node, &minfo->free_xfers);
 	}
 	spin_unlock_irqrestore(&minfo->xfer_lock, flags);
@@ -789,8 +790,6 @@ void scmi_xfer_raw_put(const struct scmi_handle *handle, struct scmi_xfer *xfer)
 {
 	struct scmi_info *info = handle_to_scmi_info(handle);
 
-	xfer->flags &= ~SCMI_XFER_FLAG_IS_RAW;
-	xfer->flags &= ~SCMI_XFER_FLAG_CHAN_SET;
 	return __scmi_xfer_put(&info->tx_minfo, xfer);
 }
 
-- 
2.51.0



