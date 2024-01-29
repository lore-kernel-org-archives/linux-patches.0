Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6915A4A8;
	Mon, 29 Jan 2024 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548319; cv=none; b=pLSKa5vDkO0hbdgYo0ljBcX0DnoUQHtLNlfO33leBH5pLTH5iYIRaH5+MRol9ZE2C96Cog0vJlv5JY1nBW5r9j8voKAxh3tg3fYZTjXdl2qxY77u8BwNgk/VgaJQG+BQPeZ156IpX1S6Xxlb4KLa0Clk8QDRo8YxsXQs/NbfNtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548319; c=relaxed/simple;
	bh=75wGUEamwXjelpdxQ0X3YXVbPN8D61UEUwz5vTmDxaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMJHRbDRhqcgnWrO5F/lWPETF7R3rDl+uYcAfYGZ16YidSL/X/1ajKPKiJYSVxWKHTuayFwBXFppJkalvorcuuFU9wx8YZMcKXduSTapv0hOcHIo/p+9fs3aqHdmBkzLBoO1Yz/eY/hIqAhFVmhVOzhfMTXqGzoDE6UTxBbuZlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkRInjff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkRInjff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C60C433C7;
	Mon, 29 Jan 2024 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548319;
	bh=75wGUEamwXjelpdxQ0X3YXVbPN8D61UEUwz5vTmDxaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkRInjffbZc2Q/tt7G6IXZ92jKlmA1M4ygCia8ZCgiDuDaahj+rv3OSDJKE6pO2qv
	 ZWynqIdy2sp7otlyUeXORt4hvJCBMY1o8nTK2OEuQr7uTA/wngpRsmxrJqnDeoEeTN
	 BO+Tm3WYfR6iX48VK1bsmEYkwBD4kMZx/zy6e+68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 322/346] firmware: arm_ffa: Add missing rwlock_init() for the driver partition
Date: Mon, 29 Jan 2024 09:05:53 -0800
Message-ID: <20240129170025.948391758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 5ff30ade16cd9efc2466d3ea22bbaf370772941a ]

Add the missing rwlock initialization for the FF-A partition associated
the driver in ffa_setup_partitions(). It will the primary scheduler
partition in the host or the VM partition in the virtualised environment.
IOW, it corresponds to the partition with VM ID == drv_info->vm_id.

Fixes: 1b6bf41b7a65 ("firmware: arm_ffa: Add notification handling mechanism")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240108-ffa_fixes_6-8-v1-2-75bf7035bc50@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index ed1d6a24934e..8df92c9521f4 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1237,6 +1237,7 @@ static void ffa_setup_partitions(void)
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return;
+	rwlock_init(&info->rw_lock);
 	xa_store(&drv_info->partition_info, drv_info->vm_id, info, GFP_KERNEL);
 	drv_info->partition_count++;
 }
-- 
2.43.0



