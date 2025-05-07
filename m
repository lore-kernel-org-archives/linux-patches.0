Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093D52116E9;
	Wed,  7 May 2025 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644162; cv=none; b=H8U7IOBW6KzH2r3LfGMJerjgmcTH3VfMivQQKiIRPzRUBSRGHTXrY53Dq/MwuFlhGbcW6Jg/ZCSHi4WkR5XfaAkcWCoJCMph0YKbXnGH9s3JXo23szVMhIlRKtajo1EnkY/vlKCmJAjnqttDviQvXPvMnfUne7lCwGDCGYZtgSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644162; c=relaxed/simple;
	bh=fHUszuKP15cpUq59OUkAYlmQ9OiDRVxdtGq/Zc4Ih2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c60maNIxyzYUg4ma+7Mtx7E0J4r48AYow+HeSnX+zNs84l7sLoAeyNQkvPHUujlp8BXd/EMFsmtG73JpLy4Dze9WNQdajj7xzFVsjEeIO1dgc+doStCBW4a7/snFCDaJuKSBZY3yjrE9kYAD47zrpsoZaSUDKw0KXb+QY2adepo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffToK4v6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffToK4v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D690C4CEE2;
	Wed,  7 May 2025 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644161;
	bh=fHUszuKP15cpUq59OUkAYlmQ9OiDRVxdtGq/Zc4Ih2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffToK4v632JQ6oznLi+cOlN1ReNIIbUETu5SMBzWCQXP0dhHCYMy9+YjdepBiP8ZU
	 OUaTnzg101riR3MNJAvrA3kaIVPzKTo5bbO0TPozb/MOe4WS3km+4UiLvJMecPXoLh
	 qEfd1B+W+IPb1Cn0Hq/O9BtHb/F7hM4+TpdywuFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh B Edara <sedara@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 139/183] octeon_ep: Fix host hang issue during device reboot
Date: Wed,  7 May 2025 20:39:44 +0200
Message-ID: <20250507183830.475231780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0a679e95196fe..24499bb36c005 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1223,7 +1223,7 @@ static void octep_hb_timeout_task(struct work_struct *work)
 		miss_cnt);
 	rtnl_lock();
 	if (netif_running(oct->netdev))
-		octep_stop(oct->netdev);
+		dev_close(oct->netdev);
 	rtnl_unlock();
 }
 
-- 
2.39.5



