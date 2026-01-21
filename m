Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716E333C52D;
	Wed, 21 Jan 2026 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020185; cv=none; b=HlBCN8ZkLSG9D2kXDlU8sNrVQL7CCeLyhnKuG8bixYzDrZfdSBSpGBVWgp8s/6BDONdG6l1wdweNhAdvW6lISJNhLs2iXHkMX+BprcFaxvoxIgQ/Lld39GlAGlqpcM4UaNe+qh7ObORsGFknVL5FEtNMnLi4y0+WG2qs1jZG8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020185; c=relaxed/simple;
	bh=mDMWJXvKuWkX9AzpGVCKb5rSN01T8WyyN38qbRh1D8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfOFWVErutmZnsLwR3CzQ/g/wu6IT7z1TMBZaISHSvvidh5s/VInaxhFZ/XGRZgoz9PhJTBRWxEtpEJ0WLdY/8cpulJIEFP2SfPuOGRkU6/IMCX8bOqQkL0+Lv8IDa9xOtA0elI31LAZ9apfdFLaUJdLRpvieVLfdliBVzVxXG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7+ApCvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7+ApCvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC38C4CEF1;
	Wed, 21 Jan 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020185;
	bh=mDMWJXvKuWkX9AzpGVCKb5rSN01T8WyyN38qbRh1D8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7+ApCvrrfyEbSmmeIWBSAdakIlmLuDnRyI1WtxxfRcMEXG1eJEXDmMy6t8cnn64/
	 dwrh0zEksWtAR8A8Z9sqtmb9ioODVYVebP3cAXbWZUC2vna/vlrGegyLduWgb35dju
	 ljbie+5hyCFkNs0O2aRvRmT1bFlm9VW9aC6spkcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/198] soundwire: bus: fix off-by-one when allocating slave IDs
Date: Wed, 21 Jan 2026 19:15:12 +0100
Message-ID: <20260121181421.583443571@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 12d4fd9a657174496677cff2841315090f1c11fc ]

ida_alloc_max() interprets its max argument as inclusive.

Using SDW_FW_MAX_DEVICES(16) therefore allows an ID of 16 to be
allocated, but the IRQ domain created for the bus is sized for IDs
0-15.  If 16 is returned, irq_create_mapping() fails and the driver
ends up with an invalid IRQ mapping.

Limit the allocation to 0-15 by passing SDW_FW_MAX_DEVICES - 1.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512240450.hlDH3nCs-lkp@intel.com/
Fixes: aab12022b076 ("soundwire: bus: Add internal slave ID and use for IRQs")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260110201959.2523024-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus_type.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/bus_type.c b/drivers/soundwire/bus_type.c
index 91e70cb46fb57..5c67c13e57357 100644
--- a/drivers/soundwire/bus_type.c
+++ b/drivers/soundwire/bus_type.c
@@ -105,7 +105,7 @@ static int sdw_drv_probe(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = ida_alloc_max(&slave->bus->slave_ida, SDW_FW_MAX_DEVICES, GFP_KERNEL);
+	ret = ida_alloc_max(&slave->bus->slave_ida, SDW_FW_MAX_DEVICES - 1, GFP_KERNEL);
 	if (ret < 0) {
 		dev_err(dev, "Failed to allocated ID: %d\n", ret);
 		return ret;
-- 
2.51.0



