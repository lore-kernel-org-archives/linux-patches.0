Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A0128BA9F;
	Wed,  7 May 2025 19:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644786; cv=none; b=Wb4iA+DOm/Wkzr1V+5zFgHrH7XB9aet8iVTMvXYegz5mIp8szXRc1eSTuDxGjeZr6D8WjSDr+5hiHASua7kxNHxBM1sFY22OGQQNiP4LvugeulgzTc3Sa25KdzwehrgAqmzsovZjY4OBGJunO2Vf828WjhQmoUbjsWztNsxwzC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644786; c=relaxed/simple;
	bh=Y97ikOv9fCaNCMhOwhPJssvqqzzWsSPK9SsDl1u10Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kptu5eyOaw71sgL6mptRDFQiUoH23vSuphS6n8XBOFkvJtSnuE1/UWVQ8RrAaIXLr8TGCj342EhKqiCjDA/ScWvdhC/WF0tTmfA1jkE3Bfi9XUoy7GDRUdMPmRsiodZltDsLIs2F1GEPQuO4G6Ho84rfnHHJqXXjNU0DWd+PC0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMcMq9T/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMcMq9T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F48C4CEE2;
	Wed,  7 May 2025 19:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644786;
	bh=Y97ikOv9fCaNCMhOwhPJssvqqzzWsSPK9SsDl1u10Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMcMq9T/MalsWwKIgC/WLTB/K9vq+LgQCofXDurYUIjp9toLxpD98/kfFbcCn/egF
	 myDZPxBNJ5qgGbM/2AJO2htUOfPRUSJZ0OO3xCMB9WHqHdYVR7+lFAfHP22j/4JJxx
	 JeJv4rzY17cjSsyZ1ew7D/LWPJ/eREh56+a5FNbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh B Edara <sedara@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/164] octeon_ep: Fix host hang issue during device reboot
Date: Wed,  7 May 2025 20:40:12 +0200
Message-ID: <20250507183826.109610086@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sathesh B Edara <sedara@marvell.com>

[ Upstream commit 34f42736b325287a7b2ce37e415838f539767bda ]

When the host loses heartbeat messages from the device,
the driver calls the device-specific ndo_stop function,
which frees the resources. If the driver is unloaded in
this scenario, it calls ndo_stop again, attempting to free
resources that have already been freed, leading to a host
hang issue. To resolve this, dev_close should be called
instead of the device-specific stop function.dev_close
internally calls ndo_stop to stop the network interface
and performs additional cleanup tasks. During the driver
unload process, if the device is already down, ndo_stop
is not called.

Fixes: 5cb96c29aa0e ("octeon_ep: add heartbeat monitor")
Signed-off-by: Sathesh B Edara <sedara@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250429114624.19104-1-sedara@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index a89f80bac39b8..1b2f5cae06449 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1184,7 +1184,7 @@ static void octep_hb_timeout_task(struct work_struct *work)
 		miss_cnt);
 	rtnl_lock();
 	if (netif_running(oct->netdev))
-		octep_stop(oct->netdev);
+		dev_close(oct->netdev);
 	rtnl_unlock();
 }
 
-- 
2.39.5



