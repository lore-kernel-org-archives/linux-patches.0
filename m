Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3E2FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C434FC433D2;
	Mon, 15 May 2023 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172645;
	bh=yVHtOSh96vcPvf96GHnuM9QQ9aFcp3NBW3kwfes67Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVIql56zIUoZvM2UNfgP03IfXdgWCWcRDuHSSSHkdINhMqB+ezFtEi+gmGYdfMcks
	 niVQpvgYq0nnVgIIPTMI66Sg5dGzcCU+2UQ3ttOU0ZDV08IOE1/F6AmvS4SJbnxQ8Y
	 scRRRYnwxEvGydgPJnikjvJMmQwXXPXuxlw0lk+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/381] usb: gadget: tegra-xudc: Fix crash in vbus_draw
Date: Mon, 15 May 2023 18:27:51 +0200
Message-Id: <20230515161746.680241993@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 5629d31955297ca47b9283c64fff70f2f34aa528 ]

Commit ac82b56bda5f ("usb: gadget: tegra-xudc: Add vbus_draw support")
populated the vbus_draw callback for the Tegra XUDC driver. The function
tegra_xudc_gadget_vbus_draw(), that was added by this commit, assumes
that the pointer 'curr_usbphy' has been initialised, which is not always
the case because this is only initialised when the USB role is updated.
Fix this crash, by checking that the 'curr_usbphy' is valid before
dereferencing.

Fixes: ac82b56bda5f ("usb: gadget: tegra-xudc: Add vbus_draw support")
Reviewed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20230405181854.42355-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 3ebc8c5416e30..66d5f6a85c848 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -2154,7 +2154,7 @@ static int tegra_xudc_gadget_vbus_draw(struct usb_gadget *gadget,
 
 	dev_dbg(xudc->dev, "%s: %u mA\n", __func__, m_a);
 
-	if (xudc->curr_usbphy->chg_type == SDP_TYPE)
+	if (xudc->curr_usbphy && xudc->curr_usbphy->chg_type == SDP_TYPE)
 		ret = usb_phy_set_power(xudc->curr_usbphy, m_a);
 
 	return ret;
-- 
2.39.2



