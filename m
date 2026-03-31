Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D23423A7C;
	Tue, 31 Mar 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976370; cv=none; b=Y3rowkzRPK40Bf46u4gUwrz/2E+0ek0OPKBgQysCKCSN9PP8akncI+qK7WgVH9Hz2BTz18rcQSFlm2nH0o2P4t166BryaXwVdtct+oQP7bk9V0lni1IIZ2svsHBWRbaDQhaAT2ymAaRaBdN1EKC7XzKD79Fe0vxB/BbOusl9MGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976370; c=relaxed/simple;
	bh=ETtv2SZ/EIAIUVPJ1BxEC2PwqWgC0kg+fj9cjsej41U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYz+nqHsMm4SE1tKH3dRSqYdWpbQXUN4k7oRKRE6hjNRclWeVOmwFbm6gy89u4AfNkhdxRALaq1JzzeFW8PDC9Zju/CwddbmtgXeYIBJWUGxArQ2FwmtTIQYuvH8wapHTvDxPbfLnlV4ItZYysByY9iyFkyeyRAYscs5QeoXvLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsW0woPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsW0woPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DCCC19423;
	Tue, 31 Mar 2026 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976370;
	bh=ETtv2SZ/EIAIUVPJ1BxEC2PwqWgC0kg+fj9cjsej41U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsW0woPS+ydXk8e66km9iFZ7bvZDJXS82RIaFL0Su1qpWiXt0vpkipV1Kn/5B+qSm
	 B8FBdHWByhVf1zumRW73QJeMgRUekEqv6r30JAEK+c41rQQsC1PcD1LGPsTbZlLf8V
	 22VpZprlJMuA2A4Ybm+ES4pqAxMJZtAYWbXe+Qcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Yin <peteryin.openbmc@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/309] i3c: master: dw-i3c: Fix missing of_node for virtual I2C adapter
Date: Tue, 31 Mar 2026 18:19:30 +0200
Message-ID: <20260331161755.953793883@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index 41ddac1d49d5e..825eb2d20e9eb 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1596,6 +1596,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	master->quirks = (unsigned long)device_get_match_data(&pdev->dev);
 
 	INIT_WORK(&master->hj_work, dw_i3c_hj_work);
+
+	device_set_of_node_from_dev(&master->base.i2c.dev, &pdev->dev);
 	ret = i3c_master_register(&master->base, &pdev->dev,
 				  &dw_mipi_i3c_ops, false);
 	if (ret)
-- 
2.51.0



