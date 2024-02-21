Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFAD7C092;
	Wed, 21 Feb 2024 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523431; cv=none; b=P/ZyJSjfo6n0rn6lYOgXY8MVxn+95UaAtfmDIwPK9+fMtXOBrGrBRmwS+G6npJk5lsH7eIp6SENIE2KFERKOB0wW1m7J3xUEWu9V8ZEtlM1OehmbXgvPGc0JdwW1/31bVgrX/znEdqxLIkYDLmGs8OHcZvqvyk2uufN1VgZYSDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523431; c=relaxed/simple;
	bh=qxtnmXtLJwhIeqr6U1/VkB2VCA58fUFQmEO/877sshI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFN2gbEZ4vFQBkOmzlPkVJoEJ55/ZEPg+/AFrwRMYzNPbtWKMEpKc6Zo1HIkII4OsCbNHpJjaXfyRbRJocX6h4ZE2Ce6C1n/4ZDaaXZPnLqriIn31pDAPkVg43zG0VG9ILwExQ3NNLuMT7GdpaFLDBncXOBblrvHuh9QnpKD0Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XedqjC+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XedqjC+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E851EC433F1;
	Wed, 21 Feb 2024 13:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523431;
	bh=qxtnmXtLJwhIeqr6U1/VkB2VCA58fUFQmEO/877sshI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XedqjC+28xlUCzaGzUzUgWaSrJhf0lMPQhGM4o/wn5mWW36M/Cxub+KyxOooQYGvG
	 ty3JajQN/kWrkPeBsnU0ctPhyqYd2H/Dv6ZqwRGN1P4GV/pIr8R5iTfgK/6c5KpDJG
	 PxgW9Vjd/1ifestPjsjBe+MIzODAbYPeJxb/UVrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/476] usb: dwc3: gadget: Only End Transfer for ep0 data phase
Date: Wed, 21 Feb 2024 14:08:06 +0100
Message-ID: <20240221130024.106939141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit ace17b6ee4f92ab0375d12a1b42494f8590a96b6 ]

The driver shouldn't be able to issue End Transfer to the control
endpoint at anytime. Typically we should only do so in error cases such
as invalid/unexpected direction of Data Phase as described in the
control transfer flow of the programming guide. It _may_ end started
data phase during controller deinitialization from soft disconnect or
driver removal. However, that should not happen because the driver
should be maintained in EP0_SETUP_PHASE during driver tear-down. On
soft-connect, the controller should be reset from a soft-reset and there
should be no issue starting the control endpoint.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c6643678863a26702e4115e9e19d7d94a30d49c.1650593829.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2afe6784f1df..4d830ba7d824 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3647,6 +3647,17 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	bool interrupt)
 {
+	struct dwc3 *dwc = dep->dwc;
+
+	/*
+	 * Only issue End Transfer command to the control endpoint of a started
+	 * Data Phase. Typically we should only do so in error cases such as
+	 * invalid/unexpected direction as described in the control transfer
+	 * flow of the programming guide.
+	 */
+	if (dep->number <= 1 && dwc->ep0state != EP0_DATA_PHASE)
+		return;
+
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
 	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
-- 
2.43.0



