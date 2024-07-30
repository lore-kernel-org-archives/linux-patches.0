Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683671A6160;
	Tue, 30 Jul 2024 16:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356812; cv=none; b=pK7bCDhPgw67leeGLE4H2hlIkJ/e336pSkSBRulV7+pTLjskpFh1N+HGMCeMmkfDP3izTw6cBVDbsFmdjVHzBOpxxeiMYeYm7BiHAB8frzoFW56vpRvsZXZP2cV9uiDPx1fF5JEgs0akSbX9cSshyUnHtGuspgFi+YLUdwI6COo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356812; c=relaxed/simple;
	bh=NSRrz3sTh9Fc16fNcw5gJUD0nO+wEWgBStRpI/0VZ2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2RAkoKO+xMdmkT5/JDKR4Z86A3NhG13FolS/5dn5e4x/xtKNQTqz88IXtX1ApW+VlzIdeHGlfxlS0ZWXgxvYz4zhvh6DdpzYfJLJUYkgndl/ktsosLp4MflI1Z1vPS6B6cjPayz4jFz3KWpL2ugWWZWaU4dw2Ccgyak4rXzHCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULzN8jPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULzN8jPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC839C4AF0C;
	Tue, 30 Jul 2024 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356812;
	bh=NSRrz3sTh9Fc16fNcw5gJUD0nO+wEWgBStRpI/0VZ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULzN8jPIimgw7ExSmVM8+rnQcFuCLtepkkRSajnpwFAfAynJmm5bFkrA9VFJGItFu
	 xg/mHP2LIyZAC53FH7SwBNVKW76x0i1KmU0fURAta/g16bbVPc13OIiYJ8AfyigGX3
	 SnDTep6sRWP6lOrFh9WdtzxJrmWTRLl3lax2e6as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 189/809] wifi: ath12k: fix ACPI warning when resume
Date: Tue, 30 Jul 2024 17:41:05 +0200
Message-ID: <20240730151732.075844502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 8b2a12749b08726f006303814ecc1c37024d3617 ]

Currently ACPI notification handler is installed when driver loads and only
gets removed when driver unloads. During resume after firmware is reloaded,
ath12k tries to install it by default. Since it is installed already, ACPI
subsystem rejects it and returns an error:

[   83.094206] ath12k_pci 0000:03:00.0: failed to install DSM notify callback: 7

Fix it by removing that handler when going to suspend. This also avoid any
possible ACPI call to firmware before firmware is reloaded/reinitialized.

Note ab->acpi also needs to be cleared in ath12k_acpi_stop() such that we
are in a clean state when ACPI structures are reinitialized in
ath12k_acpi_start().

Tested-on: WCN7850 HW2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 576771c9fa21 ("wifi: ath12k: ACPI TAS support")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240531024000.9291-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/acpi.c | 2 ++
 drivers/net/wireless/ath/ath12k/core.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/acpi.c b/drivers/net/wireless/ath/ath12k/acpi.c
index 443ba12e01f37..0555d35aab477 100644
--- a/drivers/net/wireless/ath/ath12k/acpi.c
+++ b/drivers/net/wireless/ath/ath12k/acpi.c
@@ -391,4 +391,6 @@ void ath12k_acpi_stop(struct ath12k_base *ab)
 	acpi_remove_notify_handler(ACPI_HANDLE(ab->dev),
 				   ACPI_DEVICE_NOTIFY,
 				   ath12k_acpi_dsm_notify);
+
+	memset(&ab->acpi, 0, sizeof(ab->acpi));
 }
diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 527cfa3a01ad3..52969a1bb5a56 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -83,6 +83,8 @@ int ath12k_core_suspend_late(struct ath12k_base *ab)
 	if (!ab->hw_params->supports_suspend)
 		return -EOPNOTSUPP;
 
+	ath12k_acpi_stop(ab);
+
 	ath12k_hif_irq_disable(ab);
 	ath12k_hif_ce_irq_disable(ab);
 
-- 
2.43.0



