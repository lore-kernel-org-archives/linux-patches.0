Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C3118FDAE;
	Tue, 10 Sep 2024 10:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962648; cv=none; b=qW0DWi3UC03UOm2eLbfmA7bZIKbSzsl+KuzAvLF0mIiUjy/F5ksE2bogW2jAUujd/QR8RLPfnAV2DOGs02qvg9JRumitzUZIofmRHdRBHpGc8B/n6XOGZBasVnuySk9rtAnqFDJGx9fDOIWX5aSpEinffkTsNf+5FnXiDz3/NRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962648; c=relaxed/simple;
	bh=rbavm0Rvmme1RimERejf5v0/Gmg3muX/a/CIWh/N5uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyM60tNEgXKOhky2Yw1ay1SwQCeLp41nCSqua5j0YLi/WH1K+Q3dAVcxvaQDhnJDQZVtse3gTr3XOoMM68Kr9qT9xhG0TxObVm6XvavDTXQ25P/zT+KF85HOOQSGXcvwgweqbrTva/hfaE45OH7vISyIIRtZeITPAedsgy0OOpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpNTjxmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpNTjxmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2AEC4CECD;
	Tue, 10 Sep 2024 10:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962648;
	bh=rbavm0Rvmme1RimERejf5v0/Gmg3muX/a/CIWh/N5uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpNTjxmz2plscpXolr7ExLXdC1u3Bqgg7NccEoz/k0NX8E1pOgDs+0m04XZNpwdMT
	 VFoWBVjyn+guL7eHuo27eWP/XVeoPjMeeAd7Rz2ogUyjBlkctz4YQD3V1aTixoAcCi
	 hNpaVrBxt5RucTnEWOWHnTCl/qECD1e58/l+jQLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Jason Liu <jason.hui.liu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 105/121] clocksource/drivers/imx-tpm: Fix next event not taking effect sometime
Date: Tue, 10 Sep 2024 11:33:00 +0200
Message-ID: <20240910092550.804810173@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

commit 3d5c2f8e75a55cfb11a85086c71996af0354a1fb upstream.

The value written into the TPM CnV can only be updated into the hardware
when the counter increases. Additional writes to the CnV write buffer are
ignored until the register has been updated. Therefore, we need to check
if the CnV has been updated before continuing. This may require waiting for
1 counter cycle in the worst case.

Cc: stable@vger.kernel.org
Fixes: 059ab7b82eec ("clocksource/drivers/imx-tpm: Add imx tpm timer support")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Ye Li <ye.li@nxp.com>
Reviewed-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240725193355.1436005-2-Frank.Li@nxp.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-imx-tpm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/clocksource/timer-imx-tpm.c
+++ b/drivers/clocksource/timer-imx-tpm.c
@@ -91,6 +91,14 @@ static int tpm_set_next_event(unsigned l
 	now = tpm_read_counter();
 
 	/*
+	 * Need to wait CNT increase at least 1 cycle to make sure
+	 * the C0V has been updated into HW.
+	 */
+	if ((next & 0xffffffff) != readl(timer_base + TPM_C0V))
+		while (now == tpm_read_counter())
+			;
+
+	/*
 	 * NOTE: We observed in a very small probability, the bus fabric
 	 * contention between GPU and A7 may results a few cycles delay
 	 * of writing CNT registers which may cause the min_delta event got


