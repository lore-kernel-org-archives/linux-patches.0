Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFD02EAE5;
	Thu, 12 Dec 2024 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015776; cv=none; b=blM4iopB4worbKTzXx/3G9xVwPQszFcIBDl2ZoWAuqDq067F9uZKO2OjFTmk7rooiPJoH7rTjO/lnlrwCLw03lNtdqOO9OxXWm4uaanqHbSBG/s61b0C3pNPvFnF3yBWOSteruGbC2FmAfSgW7yl00BSqkgLjbFFfZL+qj2hdDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015776; c=relaxed/simple;
	bh=Rnl8UsbK1i93ZqnTLXOIIMHEe65ox/vOikJS4fsAkX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjzHm7M1WzC41jxD4k3dJCJyBOfLcORAdW6vieXftmZ01L4zVaBzkk9G/OvnkzQSukzRwfjHFKTKJoKYe4UaP38XL6XRQWzy5DMrjY7OaO1WOEjgeQB3E+rNLLlANXVAcZlZehwpNmYv9yRberH3GZmqArmolq7ECQIUVgEJOwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5HpTzWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5HpTzWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD79CC4CED4;
	Thu, 12 Dec 2024 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015776;
	bh=Rnl8UsbK1i93ZqnTLXOIIMHEe65ox/vOikJS4fsAkX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5HpTzWbJz5OVbPMNaedDvtMLmIPW14ciaRXgJJdEmDFLmuZ7l6WZYhEg+6CopPje
	 88a7aYD+VJjuoFJY88+au35oUuIOoCYJtKyC0qpwTy3efQN1ZaMZBj0QNr10m2hwbu
	 vNRsjIIYGbNr1EG8V/WoEw4xLyVxxzT/nwf18nBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Liu <yifei.l.liu@oracle.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/466] ixgbe: downgrade logging of unsupported VF API version to debug
Date: Thu, 12 Dec 2024 15:53:31 +0100
Message-ID: <20241212144308.348893321@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 15915b43a7fb938934bb7fc4290127218859d795 ]

The ixgbe PF driver logs an info message when a VF attempts to negotiate an
API version which it does not support:

  VF 0 requested invalid api version 6

The ixgbevf driver attempts to load with mailbox API v1.5, which is
required for best compatibility with other hosts such as the ESX VMWare PF.

The Linux PF only supports API v1.4, and does not currently have support
for the v1.5 API.

The logged message can confuse users, as the v1.5 API is valid, but just
happens to not currently be supported by the Linux PF.

Downgrade the info message to a debug message, and fix the language to
use 'unsupported' instead of 'invalid' to improve message clarity.

Long term, we should investigate whether the improvements in the v1.5 API
make sense for the Linux PF, and if so implement them properly. This may
require yet another API version to resolve issues with negotiating IPSEC
offload support.

Fixes: 339f28964147 ("ixgbevf: Add support for new mailbox communication between PF and VF")
Reported-by: Yifei Liu <yifei.l.liu@oracle.com>
Link: https://lore.kernel.org/intel-wired-lan/20240301235837.3741422-1-yifei.l.liu@oracle.com/
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
index 6493abf189de5..6639069ad5283 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
@@ -194,6 +194,8 @@ u32 ixgbe_read_reg(struct ixgbe_hw *hw, u32 reg);
 	dev_err(&adapter->pdev->dev, format, ## arg)
 #define e_dev_notice(format, arg...) \
 	dev_notice(&adapter->pdev->dev, format, ## arg)
+#define e_dbg(msglvl, format, arg...) \
+	netif_dbg(adapter, msglvl, adapter->netdev, format, ## arg)
 #define e_info(msglvl, format, arg...) \
 	netif_info(adapter, msglvl, adapter->netdev, format, ## arg)
 #define e_err(msglvl, format, arg...) \
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index e71715f5da228..20415c1238ef8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1047,7 +1047,7 @@ static int ixgbe_negotiate_vf_api(struct ixgbe_adapter *adapter,
 		break;
 	}
 
-	e_info(drv, "VF %d requested invalid api version %u\n", vf, api);
+	e_dbg(drv, "VF %d requested unsupported api version %u\n", vf, api);
 
 	return -1;
 }
-- 
2.43.0



