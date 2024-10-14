Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB30D611E;
	Mon, 14 Oct 2024 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916872; cv=none; b=q2XoY9SqBom/9ziwMRiZkUP98cWTzy2xuOA6adT7GSH78HYpF2AGubjofdhma1tFrE7d2THbIMz1gVEXFoJa0++iF0eKG7ia09i6KRkrboJxK1kRzxOHDC1QS/P9Ji8KbocH6TCBlaZaOrsY8R+fqgX/fV1A9rym/ihea1iMBCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916872; c=relaxed/simple;
	bh=5UPkypACSx0uIJZGUk2S5vDrg4rmfgu5OvdeYQdeftM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CM/AO0E8DqIg/nOsWc9UpP3ieLYlaM6vcCyYHx+Tz9useshdZKoyXY4gTShIuxhoEbu7MqI4mEQmurhubmW/lae4gT4GZ0Zo7SMXAzqUloMc4B24U9xtQ8ERhNI0kRX80U+ElUwh8zh+YiDtaGm7a6leHNOcIjT/ekeTi7HfoII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7F7HbyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7F7HbyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D347C4CEC7;
	Mon, 14 Oct 2024 14:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916872;
	bh=5UPkypACSx0uIJZGUk2S5vDrg4rmfgu5OvdeYQdeftM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7F7HbyNfyQKEhu0r1Q07GspcBgtyrILQVAz/qcL97kYVKMf5T5w4EmrQKyrqeHsw
	 IMBlEbEdZfWSJp1IR4cuh96UYHJxHrI1k5ING8103I1RG9/Unws8tbW4d02OZVWlKw
	 c09XrMuE7r2M5+xCEFmLGoQKMkY+DH2bCo4WPKkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/213] usb: typec: tipd: Free IRQ only if it was requested before
Date: Mon, 14 Oct 2024 16:19:55 +0200
Message-ID: <20241014141046.448450111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wadim Egorov <w.egorov@phytec.de>

[ Upstream commit db63d9868f7f310de44ba7bea584e2454f8b4ed0 ]

In polling mode, if no IRQ was requested there is no need to free it.
Call devm_free_irq() only if client->irq is set. This fixes the warning
caused by the tps6598x module removal:

WARNING: CPU: 2 PID: 333 at kernel/irq/devres.c:144 devm_free_irq+0x80/0x8c
...
...
Call trace:
  devm_free_irq+0x80/0x8c
  tps6598x_remove+0x28/0x88 [tps6598x]
  i2c_device_remove+0x2c/0x9c
  device_remove+0x4c/0x80
  device_release_driver_internal+0x1cc/0x228
  driver_detach+0x50/0x98
  bus_remove_driver+0x6c/0xbc
  driver_unregister+0x30/0x60
  i2c_del_driver+0x54/0x64
  tps6598x_i2c_driver_exit+0x18/0xc3c [tps6598x]
  __arm64_sys_delete_module+0x184/0x264
  invoke_syscall+0x48/0x110
  el0_svc_common.constprop.0+0xc8/0xe8
  do_el0_svc+0x20/0x2c
  el0_svc+0x28/0x98
  el0t_64_sync_handler+0x13c/0x158
  el0t_64_sync+0x190/0x194

Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240816124150.608125-1-w.egorov@phytec.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 125269f39f83a..01db27cbf1d10 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -907,6 +907,8 @@ static void tps6598x_remove(struct i2c_client *client)
 
 	if (!client->irq)
 		cancel_delayed_work_sync(&tps->wq_poll);
+	else
+		devm_free_irq(tps->dev, client->irq, tps);
 
 	tps6598x_disconnect(tps, 0);
 	typec_unregister_port(tps->port);
-- 
2.43.0



