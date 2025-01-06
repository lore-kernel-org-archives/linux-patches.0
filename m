Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D311DC9BC;
	Mon,  6 Jan 2025 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177484; cv=none; b=fCTNLWcxLJ2gX5uDOf8qSpbHNLEUW1IRnVzrG8DvG3nnRz+u4JZQRcH0yvNRDPyHMb6boqnre3d10YvQG/LCXFfZJxnvnQocCnPaVHelne2SU3tBLbZq5aVMzR3BZ7e/CIUeoKBgehJX+DxpRziX3ndvBHokJ0b6oRxT7L393qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177484; c=relaxed/simple;
	bh=O0xTL3EK2Zc7uKZ9ZMY2s/S9S0cVEeXX9LW65kh4P6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwmX2dYEQlMPncSik7Z3Hy6kA1X4fhsUqkt4uFjpupkIP05Wt6hbS2OEoj6PZ4Up3H3vzNFfIdgi5Ijzn7Y/H262jmH21kUirC+bUMRRBjzJ/Eu+KvsIIUbFcWkAQzDzIvE4Y/2ZpvJxpsEVdEvwAXR4oQSOBXdNAp4H2rY6ROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+9Y/uIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+9Y/uIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F9CC4CED2;
	Mon,  6 Jan 2025 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177483;
	bh=O0xTL3EK2Zc7uKZ9ZMY2s/S9S0cVEeXX9LW65kh4P6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+9Y/uIWvuGGuCquLwuxyVBCJpc9BsAGzXtFbo5B42dipCPvHYOMsdZ4ni4r0VQH+
	 EU/t/8GgNnoj3BkRQqnchbw4e5fikISyfW+2vDCthLqGvWgBpo47FwHJ5PlPo3O2Wl
	 ogBuZvMC1zw4G++Gnik8iYy51k76QaXe03tS1I4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/222] net: ti: icssg-prueth: Fix clearing of IEP_CMP_CFG registers during iep_init
Date: Mon,  6 Jan 2025 16:16:21 +0100
Message-ID: <20250106151157.463511851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 9b115361248dc6cce182a2dc030c1c70b0a9639e ]

When ICSSG interfaces are brought down and brought up again, the
pru cores are shut down and booted again, flushing out all the memories
and start again in a clean state. Hence it is expected that the
IEP_CMP_CFG register needs to be flushed during iep_init() to ensure
that the existing residual configuration doesn't cause any unusual
behavior. If the register is not cleared, existing IEP_CMP_CFG set for
CMP1 will result in SYNC0_OUT signal based on the SYNC_OUT register values.

After bringing the interface up, calling PPS enable doesn't work as
the driver believes PPS is already enabled, (iep->pps_enabled is not
cleared during interface bring down) and driver will just return true
even though there is no signal. Fix this by disabling pps and perout.

Fixes: c1e0230eeaab ("net: ti: icss-iep: Add IEP driver")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index 3025e9c18970..f06cdec14ed7 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -290,6 +290,9 @@ static void icss_iep_enable_shadow_mode(struct icss_iep *iep)
 	for (cmp = IEP_MIN_CMP; cmp < IEP_MAX_CMP; cmp++) {
 		regmap_update_bits(iep->map, ICSS_IEP_CMP_STAT_REG,
 				   IEP_CMP_STATUS(cmp), IEP_CMP_STATUS(cmp));
+
+		regmap_update_bits(iep->map, ICSS_IEP_CMP_CFG_REG,
+				   IEP_CMP_CFG_CMP_EN(cmp), 0);
 	}
 
 	/* enable reset counter on CMP0 event */
@@ -808,6 +811,11 @@ int icss_iep_exit(struct icss_iep *iep)
 	}
 	icss_iep_disable(iep);
 
+	if (iep->pps_enabled)
+		icss_iep_pps_enable(iep, false);
+	else if (iep->perout_enabled)
+		icss_iep_perout_enable(iep, NULL, false);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(icss_iep_exit);
-- 
2.39.5



