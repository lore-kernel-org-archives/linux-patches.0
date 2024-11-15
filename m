Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB2BEAD0;
	Fri, 15 Nov 2024 06:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653394; cv=none; b=sLeKeFeKUQ0ReDcCHwexaZQLE2W07MUmPExeXdUbGCMMk+wlF4AdWoY9+QDE0rPEP6t/40hyCr3L0KIPMxW0RNgqAomrckpP1FyZ542/D3UQPg6Gx61avGoyYdVOQyKLUt3qExkAw22WiBrxI6VrUJtv/KtywwzkQumH2kw4RZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653394; c=relaxed/simple;
	bh=YlV28u13sf3Jigw7jPugYpM9uh0IKb78Yq4h7s9SZHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9EadWgnWktDGA4ebp9NDd2Kb0Oz3kYZjszc99DNgCj+hTEEdl3xEqi4LhN9UrDfx3qnC6uSrl3m1bnSRUqIMwZGjCTBWhRCN1jDRXahO4Yu+aU8Mdhgr2nXwRpxsusa610CPnHUUs8cDMrTZDFAMm1fEpzdddrm1zNitm3rrqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrlFntCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrlFntCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE622C4CECF;
	Fri, 15 Nov 2024 06:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653394;
	bh=YlV28u13sf3Jigw7jPugYpM9uh0IKb78Yq4h7s9SZHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrlFntCWkRyexTKuYuKKUvc/itq2yHH2YSE/bX1RRRhoE/NakxFgy9Patnq2PNb8Y
	 uKld/4SefSV2bnLiP4K5QckZ7LQhYOjoadrLXPRNyvwpj8Bb2KDFdX72il+MqCtGiu
	 ysRy76mGcOhgFrimNP6eiRo8Gw8HMuAxhBL6Ka80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Joyce <gjoyce@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/48] nvme: disable CC.CRIME (NVME_CC_CRIME)
Date: Fri, 15 Nov 2024 07:37:59 +0100
Message-ID: <20241115063723.335041499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

From: Greg Joyce <gjoyce@linux.ibm.com>

[ Upstream commit 0ce96a6708f34280a536263ee5c67e20c433dcce ]

Disable NVME_CC_CRIME so that CSTS.RDY indicates that the media
is ready and able to handle commands without returning
NVME_SC_ADMIN_COMMAND_MEDIA_NOT_READY.

Signed-off-by: Greg Joyce <gjoyce@linux.ibm.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 82509f3679373..e25206c7de80c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2250,8 +2250,13 @@ int nvme_enable_ctrl(struct nvme_ctrl *ctrl)
 	else
 		ctrl->ctrl_config = NVME_CC_CSS_NVM;
 
-	if (ctrl->cap & NVME_CAP_CRMS_CRWMS && ctrl->cap & NVME_CAP_CRMS_CRIMS)
-		ctrl->ctrl_config |= NVME_CC_CRIME;
+	/*
+	 * Setting CRIME results in CSTS.RDY before the media is ready. This
+	 * makes it possible for media related commands to return the error
+	 * NVME_SC_ADMIN_COMMAND_MEDIA_NOT_READY. Until the driver is
+	 * restructured to handle retries, disable CC.CRIME.
+	 */
+	ctrl->ctrl_config &= ~NVME_CC_CRIME;
 
 	ctrl->ctrl_config |= (NVME_CTRL_PAGE_SHIFT - 12) << NVME_CC_MPS_SHIFT;
 	ctrl->ctrl_config |= NVME_CC_AMS_RR | NVME_CC_SHN_NONE;
@@ -2286,10 +2291,7 @@ int nvme_enable_ctrl(struct nvme_ctrl *ctrl)
 		 * devices are known to get this wrong. Use the larger of the
 		 * two values.
 		 */
-		if (ctrl->ctrl_config & NVME_CC_CRIME)
-			ready_timeout = NVME_CRTO_CRIMT(crto);
-		else
-			ready_timeout = NVME_CRTO_CRWMT(crto);
+		ready_timeout = NVME_CRTO_CRWMT(crto);
 
 		if (ready_timeout < timeout)
 			dev_warn_once(ctrl->device, "bad crto:%x cap:%llx\n",
-- 
2.43.0



