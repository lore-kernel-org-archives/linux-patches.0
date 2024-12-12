Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C356421764F;
	Thu, 12 Dec 2024 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017685; cv=none; b=ixDgU5I+7OFGPQMIhklwrUZ5MhTrGSKoXZWUZua/vte+EIpeqYDxo3nW7SmalHatc4HW6N+oDMUy/75932XOa/rpojDU8+eLw47V9WFKAHcw/KGHylolyDP5G1MXR5R77BlGOMnaK/3MZ0PP8E2YvfXI31Vt2mLHdA7/j3l21QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017685; c=relaxed/simple;
	bh=gbCK9tUW/ReM+dNzl/pGPZWwKooQEIKz9T97h3LpiOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhOli4HKvnf53BH6IzlIwPfLXR2w2NhnugwZnQIEQlSUftZnkLrAdsx6UpRAq7vZsHUbF7fJa+Y4LujnKnT6XU4QPZPVZNLjsiFRZ/X8ZBM+SOCCNMPFbAS3Tgm1Tnxdf8HKHwJG4vc60CzBfvRFEVtL+5uhiCYVyBEE3cNzSHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOxV0ci/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOxV0ci/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B34C4CECE;
	Thu, 12 Dec 2024 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017685;
	bh=gbCK9tUW/ReM+dNzl/pGPZWwKooQEIKz9T97h3LpiOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOxV0ci/1DWqa0b0SMGwjbXLt/dhBf6p4eUuTZEaxyl5W2BkhLEeFoSY/OtBfssNH
	 Mv1qmldB8LsvxzcW3i+99EjfzcXBoTblZ4fBuC8ib/KauMeE8fGabc3JiAB53la15J
	 RxCyekoIsSyxzfcxcwPWmGlJ2jvwhx5CAWIqA/Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/356] usb: dwc3: ep0: Dont clear ep0 DWC3_EP_TRANSFER_STARTED
Date: Thu, 12 Dec 2024 15:56:41 +0100
Message-ID: <20241212144247.863770685@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 5d2fb074dea289c41f5aaf2c3f68286bee370634 ]

The driver cannot issue the End Transfer command to the SETUP transfer.
Don't clear DWC3_EP_TRANSFER_STARTED flag to make sure that the driver
won't send Start Transfer command again, which can cause no-resource
error. For example this can occur if the host issues a reset to the
device.

Cc: stable@vger.kernel.org
Fixes: 76cb323f80ac ("usb: dwc3: ep0: clear all EP0 flags")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/d3d618185fd614bb7426352a9fc1199641d3b5f5.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/ep0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 371662a552538..69d98f1938edd 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -231,7 +231,7 @@ void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
 	__dwc3_gadget_ep_set_halt(dep, 1, false);
-	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED;
+	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED | DWC3_EP_TRANSFER_STARTED;
 	dep->flags |= DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
-- 
2.43.0



