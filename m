Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB7433506D;
	Wed, 21 Jan 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020192; cv=none; b=Z7PxcgIyLRlUqoktECpQMz+FTa/Q5dc2vK7gMzCB3pt6OwnH1EUZzaago7p2BauXJ90/4sMTNAHELUTUv8QHikZGN0p3J4dubiNCAmstv1NEOjZypujg1CX5zdihEGYsxyWuU6cm1STatdL7r6XF97/ZBgn6ZyEvMkct6g2+Svs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020192; c=relaxed/simple;
	bh=mSK0ZgtNKjRRF41swcUndrHf/KjBVB3O/kkn0XYcni0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1y0dB/la1SZal9923MKuaWL1oKy3Tmc7Yzx6HCoKYfS/dslUIAagCM+L6Hg0ip9FzzXUdBOjIqOKfgKVs4aRnhq7pZ8RyRr8FEzMNUzdKvU5sJEivVMpGHIk8wQHcaqA0aYn2nBTvrF0ivlJ/kWAVjHoBu/V2UDPMVZ5z7WhRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXldmCne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXldmCne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BB3C4CEF1;
	Wed, 21 Jan 2026 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020192;
	bh=mSK0ZgtNKjRRF41swcUndrHf/KjBVB3O/kkn0XYcni0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXldmCne0QTgjSeJBUMBl5PvHBlhnzYq8gLL5l1BvkfbflJ3KtMfimZbt+OmBeMQs
	 b23BWNuHDePnY8sny51TuN4Xt6XHlDDs+eMPHL7ygBbXlNzQU1ew5vtkjwntcgnlPb
	 U12FsM0xxIaXEVi1EnVOuwLazbfU8TSQA03MZ3fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/198] i2c: imx-lpi2c: change to PIO mode in system-wide suspend/resume progress
Date: Wed, 21 Jan 2026 19:15:14 +0100
Message-ID: <20260121181421.654612078@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit f2a3f51365bf672dab4b58d1e8954926a9196b44 ]

EDMA resumes early and suspends late in the system power transition
sequence, while LPI2C enters the NOIRQ stage for both suspend and resume.
This means LPI2C resources become available before EDMA is fully resumed.
Once IRQs are enabled, a slave device may immediately trigger an LPI2C
transfer. If the transfer length meets DMA requirements, the driver will
attempt to use EDMA even though EDMA may still be unavailable.

This timing gap can lead to transfer failures. To prevent this, force
LPI2C to use PIO mode during system-wide suspend and resume transitions.
This reduces dependency on EDMA and avoids using an unready DMA resource.

Fixes: a09c8b3f9047 ("i2c: imx-lpi2c: add eDMA mode support for LPI2C")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 2a0962a0b4417..d882126c1778c 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -592,6 +592,13 @@ static bool is_use_dma(struct lpi2c_imx_struct *lpi2c_imx, struct i2c_msg *msg)
 	if (!lpi2c_imx->can_use_dma)
 		return false;
 
+	/*
+	 * A system-wide suspend or resume transition is in progress. LPI2C should use PIO to
+	 * transfer data to avoid issue caused by no ready DMA HW resource.
+	 */
+	if (pm_suspend_in_progress())
+		return false;
+
 	/*
 	 * When the length of data is less than I2C_DMA_THRESHOLD,
 	 * cpu mode is used directly to avoid low performance.
-- 
2.51.0



