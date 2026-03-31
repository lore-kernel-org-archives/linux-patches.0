Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358363FA5E6;
	Tue, 31 Mar 2026 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974874; cv=none; b=f2HgtNl+SGnPTiztbyAdXY9iqJqADIr2sjKzqVSdMzHj3wb5rgwcAvBYoOQFHA4lmH3DT3Rzo+q1011BzyXyXQ4TaWJO6/LTfIUHUbOo0nd9mm8AfzzMgmromQwPpuLiE8R5cc7Gosvkp+jZDG4rp+8LV3dh9RV0OA/Cot8fjS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974874; c=relaxed/simple;
	bh=cALsxi5ptQsgUng+A/zlzUF6ODWuMp+9a51kAO4lkCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=His2Ucdoaq5lebxtGrGVUsTTak8p00PPQ0qcabEwiU7D+OKlMI5f5Wnxy6Bhe8waoHB3THQtoq3cmvi+1vOWM6H2MdZ26nkidYtYpRDPuM0UnaVZ0Kgl1RITfsZ7/mf4lKet+L+8I2MoN1Kc3pADZ5ebsf885hDebBx/fsmRSKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ds4nRilw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ds4nRilw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02EDC19423;
	Tue, 31 Mar 2026 16:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974874;
	bh=cALsxi5ptQsgUng+A/zlzUF6ODWuMp+9a51kAO4lkCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ds4nRilwmcvMPUMgWjjVntrxSYIRlQM0pWJZaInrjeH7ESW4i0+QD9O8BM22PBI8s
	 mxJOl3AZ8F42KjYMWs087AzFY9mQiZfNqFcIxeqmSC2ASwWj/UdRf23YuN0T17wp8P
	 TSK4tGHhIJ00n2sEpxNJS8hJ3RejatiLCGyH1pdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Yin <peteryin.openbmc@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 077/342] i3c: master: dw-i3c: Fix missing of_node for virtual I2C adapter
Date: Tue, 31 Mar 2026 18:18:30 +0200
Message-ID: <20260331161801.725725935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Yin <peteryin.openbmc@gmail.com>

[ Upstream commit f26ecaa0f0abfe5db173416214098a00d3b7db79 ]

The DesignWare I3C master driver creates a virtual I2C adapter to
provide backward compatibility with I2C devices. However, the current
implementation does not associate this virtual adapter with any
Device Tree node.

Propagate the of_node from the I3C master platform device to the
virtual I2C adapter's device structure. This ensures that standard
I2C aliases are correctly resolved and bus numbering remains consistent.

Signed-off-by: Peter Yin <peteryin.openbmc@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260302075645.1492766-1-peteryin.openbmc@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index f9b981abd10c5..1368c834ca5e8 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1614,6 +1614,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 		pm_runtime_get_noresume(&pdev->dev);
 
 	INIT_WORK(&master->hj_work, dw_i3c_hj_work);
+
+	device_set_of_node_from_dev(&master->base.i2c.dev, &pdev->dev);
 	ret = i3c_master_register(&master->base, &pdev->dev,
 				  &dw_mipi_i3c_ops, false);
 	if (ret)
-- 
2.51.0



