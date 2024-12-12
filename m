Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00022135C1;
	Thu, 12 Dec 2024 15:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017558; cv=none; b=oJsa76urR/ElmBLBD7h7ePeEG/JakEJdhcLPMjOW4hixFb8RpoD3438F7U/R4/8PVQb7ZwHZDN7YAr7OdM+in7egZRddWnqdklEAnNRxfm+8ddy6atp8re/dwvnU/lhJupM0SBdGb7hY4gPRc9kyg/eVYjTJV4Dt0ZTmUZ+GIQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017558; c=relaxed/simple;
	bh=9g1hZoZrmX3uHssOLvxDGaw1W0x+kcY2xEwGkRrKXfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9pDB5BSzPxiZ/ilvP4ouIkhDIs9pDw9YwMr5CnFnd2OQK3YLBjic9MZKq57q2zI3gSKjNlNPwG+uKRHpm7M3AdwKCCDPTmcbiqDYHUduoIknKlwpEd4c0CO6d0whkvMYZE7cDVPEUsFWbA0i48FxE2GQQvUocCGf6hGitteZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAkzxm6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAkzxm6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B812C4CECE;
	Thu, 12 Dec 2024 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017558;
	bh=9g1hZoZrmX3uHssOLvxDGaw1W0x+kcY2xEwGkRrKXfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAkzxm6VOydv5KnArKlMJOK8RPg5Q+KGXvkNmR2C5GWyuIkiN8XajRbC9FU5Z9X2f
	 CurH7A8hJeg0ycwSH/RTuORcOXRQBUFDsM30EMm3N8F25sNb13bWQcf6ol7I2xqZ5D
	 /0y1dD+CBRMuWjUh/Ckcac+RxqHvoe3/XbVHIodQ=
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
Subject: [PATCH 6.6 047/356] ixgbe: downgrade logging of unsupported VF API version to debug
Date: Thu, 12 Dec 2024 15:56:06 +0100
Message-ID: <20241212144246.492003531@linuxfoundation.org>
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
index 34761e691d52d..efdc222e183d1 100644
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
index d0a6c220a12ac..9c89a87e35e01 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1049,7 +1049,7 @@ static int ixgbe_negotiate_vf_api(struct ixgbe_adapter *adapter,
 		break;
 	}
 
-	e_info(drv, "VF %d requested invalid api version %u\n", vf, api);
+	e_dbg(drv, "VF %d requested unsupported api version %u\n", vf, api);
 
 	return -1;
 }
-- 
2.43.0



