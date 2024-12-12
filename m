Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647D621E0BC;
	Thu, 12 Dec 2024 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020879; cv=none; b=phOrrrKXb5vGMBr7lyP9u9lWSt5OU5tvCwYVpB6+baC0CORDws8p+YCnapOaaUAnF0SyEnukXLAzL+KFdmSjz4mTVB/cYuYjJjcXMS/tSbxRCO9SdOF2dnQ7o2FnSmw00JzPZQzXcAvQSoIqBaItTcfU+6fOue1KmndFfrznViQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020879; c=relaxed/simple;
	bh=R2s1ZQd3xGi7Xh6uqjghSue/m0C3+YDR4t7pkTT3Plg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HON2uAv3wI3pUKyt6kxXdCjjtFTQLd9b5UC3YmYNPgwkeMntlX8A/tw9SxyA5U8ZwbwjtP+dzeMkfLZHFGhNdeKlHcsO4CwxogMR9Gb8os2DUWOPvt6+pt3rwKASHwCQHCje6oIwscaz874tJXKJA1iuPfWt+Z6xCyNi5Md/W44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4KzTTrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4KzTTrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CD7C4CEDE;
	Thu, 12 Dec 2024 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020879;
	bh=R2s1ZQd3xGi7Xh6uqjghSue/m0C3+YDR4t7pkTT3Plg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4KzTTrzEmPsQkWX/UX+UgI0Q2V28i/J+MOsZDt6+9dSsZ2Una1mgzto2TTw2cWDM
	 3/6s4a/j+kslfurzDmeUQp36IUDu/7/fv6Xj91d6BuKyp7TJGIEITG18pnRqNBG/Rm
	 6wSvT6VHtYo8zwMSapuEYWw8KSZfzv3Dq1bURghM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 555/772] usb: dwc3: ep0: Dont clear ep0 DWC3_EP_TRANSFER_STARTED
Date: Thu, 12 Dec 2024 15:58:20 +0100
Message-ID: <20241212144412.903184469@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2da36f02a10e8..e87b37cb9a7af 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -229,7 +229,7 @@ void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
 	__dwc3_gadget_ep_set_halt(dep, 1, false);
-	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED;
+	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED | DWC3_EP_TRANSFER_STARTED;
 	dep->flags |= DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
-- 
2.43.0



