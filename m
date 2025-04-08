Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7E6269B1E;
	Tue,  8 Apr 2025 12:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116632; cv=none; b=jvjMdQKVtEIIF/oDNhDBeDHk246+GQznXhXp7dbS4JiEZRNnBihogT6duKnN7Oay1gTLHOB3UGbqUpPLW505si5y/O8tENEKHgoG6+zwJpgOobWnzxzW8w3SHV0qf4nalJJhYgo6WbPCflKe+wfEP76Nu2vAnPnxvj6/koV3oOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116632; c=relaxed/simple;
	bh=3xV28IESZ2dDduz4oM793K5qcbh70eS1aJd1jIh04Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPqKHW5lLOucyTHSRtEjyCUVVxHV9kdyCvkCUfn17Lcy45bEU3FdE+8/HOwjIV2NvMG2VS8CQjNCWRBEEbmJ1vIWs9P3TNOU+ahv4mPoYhpLwedz6FCZTJEVyFPcxhAPUlmjtdz6J4/lCXauc4cqknHzZt7jXlZdN1DzQiOv9YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwSPWAeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwSPWAeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6043EC4CEE7;
	Tue,  8 Apr 2025 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116631;
	bh=3xV28IESZ2dDduz4oM793K5qcbh70eS1aJd1jIh04Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwSPWAeU8obpRH1nvFO8FrFYGuRiZOK91feM7LpOwGe855YeWhSe+37F72YlULA3n
	 iQ88eMlovUxm/qfAqo5IFCG2cnuiqasvfZyvvHsWjlKfZma7+4U4Squ2tKXZ5K2/sv
	 n1O2ICL1YaBlgIMoIk4sTSY8PQ+Y9VZlk2h2msqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/423] i3c: master: svc: Fix missing the IBI rules
Date: Tue,  8 Apr 2025 12:48:56 +0200
Message-ID: <20250408104850.625523204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 9cecad134d84d14dc72a0eea7a107691c3e5a837 ]

The code does not add IBI rules for devices with controller capability.
However, the secondary controller has the controller capability and works
at target mode when the device is probed. Therefore, add IBI rules for
such devices.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-2-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 565af3759813b..87f98fa8afd58 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -990,7 +990,7 @@ static int svc_i3c_update_ibirules(struct svc_i3c_master *master)
 
 	/* Create the IBIRULES register for both cases */
 	i3c_bus_for_each_i3cdev(&master->base.bus, dev) {
-		if (I3C_BCR_DEVICE_ROLE(dev->info.bcr) == I3C_BCR_I3C_MASTER)
+		if (!(dev->info.bcr & I3C_BCR_IBI_REQ_CAP))
 			continue;
 
 		if (dev->info.bcr & I3C_BCR_IBI_PAYLOAD) {
-- 
2.39.5



