Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2312338904;
	Tue,  6 Jan 2026 17:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721417; cv=none; b=eDK2qD/yq4rb/oBtFlk0xtxyfAMKG1NHUJvBLq+sYjoq5BIqQEgBrEU2hC5QyGyuYfaEwpvV46yrJGvMvzH7sAofC1ufQBQNrvJM9T7EQOry1Of0wcYaJTAvQFFiI0w+3RoynohvkIKuw7zKMyRVr30Zc4D0KvCFeIGezZY4Cb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721417; c=relaxed/simple;
	bh=HuJGAzGuA9GSuuIN3Kug9YepwTSVbe4aKc6DQS2CS/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGsslY/Z0MC/GHWxhCG8S9Qwcvir15Zn+WjphCWEvrJzy2rDjZGC/8yXpi72q8Mgft3n+ToEmV4UgUl1Qx0h6SJJYWZvXX/qDkmO94wVs/JB1X4v85QPLaDZOEHhGH8U4btQ2oovviu1BK70fMhUmuCQvgUs73V3ZRvUzIwbv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW+5hm+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW+5hm+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C419AC19423;
	Tue,  6 Jan 2026 17:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721417;
	bh=HuJGAzGuA9GSuuIN3Kug9YepwTSVbe4aKc6DQS2CS/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kW+5hm+rFV4OqvuueRhVAXyxc6Gdu/zjHsxhA5yJdwDJxqhVFD7nRX+CF1YSsPFA5
	 e392p2myTIvlvwozD/iLy2ctc9zEelulk368ZL/EPbFvMuUqMT5DGompWOB3jfAZxo
	 GSnsR3d3ReuZzv+Fg7SvbcsexPjqfx5NBfT8Nz+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aidan Stewart <astewart@tektelic.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 498/567] serial: core: fix OF node leak
Date: Tue,  6 Jan 2026 18:04:40 +0100
Message-ID: <20260106170509.787870547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 273cc3406c8d4e830ed45967c70d08d20ca1380e ]

Make sure to drop the OF node reference taken when initialising the
control and port devices when the devices are later released.

Fixes: d36f0e9a0002 ("serial: core: restore of_node information in sysfs")
Cc: Aidan Stewart <astewart@tektelic.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250708085817.16070-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 24ec03cc5512 ("serial: core: Restore sysfs fwnode information")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_base_bus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/serial_base_bus.c
+++ b/drivers/tty/serial/serial_base_bus.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/serial_core.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -93,6 +94,7 @@ static void serial_base_ctrl_release(str
 {
 	struct serial_ctrl_device *ctrl_dev = to_serial_base_ctrl_device(dev);
 
+	of_node_put(dev->of_node);
 	kfree(ctrl_dev);
 }
 
@@ -140,6 +142,7 @@ static void serial_base_port_release(str
 {
 	struct serial_port_device *port_dev = to_serial_base_port_device(dev);
 
+	of_node_put(dev->of_node);
 	kfree(port_dev);
 }
 


