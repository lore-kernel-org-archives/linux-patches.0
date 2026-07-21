Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850CE42DA39;
	Tue, 21 Jul 2026 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660664; cv=none; b=B4NkNCG2vHUpZLR3LIjSbybkFsFJzdlF6UtCeIJSgO+99VuJmektZTxUt/e/Mz7NC07j5Z9ZV5VflRRP0XZ1SmDTrDo7Vj4+8ujsnlg9uFZPfCy8UsMOqzryebWsE1inZPh338ZMhbSKiqN//mycwVwoUEADQhuUMiA4Rrtrtn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660664; c=relaxed/simple;
	bh=/A8QXC2IujIU2bnxkDAydLOxQ0E55Y4XfgKxG/PDvLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKSA/zXEg85fcbbQ+zu+0XP8yMxuPr4psmQ6wxm/3PjrwKKYz/K6tEl8JvZiusS2UXqAG1ZUE3F7XEpkRaYxUkr+vxkkZGFxCqIqnlNFPOyuVlgHZvkzcmJ0iz4KYPgOlYTLHB+NnjKIv3644HkkS3Oivnhqi3eljUEFh/nbjgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBhWqQHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBhWqQHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0941F000E9;
	Tue, 21 Jul 2026 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660663;
	bh=N94MM8+QpZzu6TVFoisSz7X3HyT8+xCa6sc4wNcw+vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBhWqQHKvo3NTpvYInMy14zZlZhwDtzxAFvx+SyAp+mHJn0fwjIJnmL57Ddb1Y4W5
	 UDiI0YCNWaRKAQpy9iJHBXQXVPWXfkKN4tyzAYF7FFfgR33oydQDf59GPx3Qb4MoZS
	 DBWLvMsq30OOcNKglXNo+R4tNdyC/zMqMTGDs1NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1058/2077] i3c: master: Make hot-join workqueue freezable to block hot-join during suspend
Date: Tue, 21 Jul 2026 17:12:11 +0200
Message-ID: <20260721152617.775989269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 527756cb9ebb277dca12fff00af9fbb3b9ec8cc8 ]

The I3C master workqueue (master->wq) is used to defer work that needs
thread context and the bus maintenance lock, most notably Hot Join
processing (which calls i3c_master_do_daa() to assign dynamic addresses
to newly joined devices).

Currently the workqueue keeps running across system suspend, which can
race with the suspend path:

 - do_daa() may execute after the controller has been suspended,
   issuing bus transactions on a powered-down or otherwise unusable
   controller.
 - New I3C devices can be enumerated and added to the bus mid-suspend,
   registering driver model objects at a point where the I3C subsystem
   and its consumers are not prepared to handle them.

Mark the workqueue WQ_FREEZABLE so its workers are frozen for the
duration of system suspend/hibernate and resumed afterwards. This
naturally defers any pending or newly queued Hot Join work until the
system (and the controller) is fully resumed, closing both races
without adding explicit suspend/resume synchronization in the master
drivers.

Update the kerneldoc for struct i3c_master_controller::wq to reflect
that the workqueue is freezable.

Fixes: 3a379bbcea0af ("i3c: Add core I3C infrastructure")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260608054312.10604-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 2 +-
 include/linux/i3c/master.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 5cd4e5da22333d..ab11e2d79aabb4 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -3079,7 +3079,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
-	master->wq = alloc_workqueue("%s", WQ_PERCPU, 0, dev_name(parent));
+	master->wq = alloc_workqueue("%s", WQ_PERCPU | WQ_FREEZABLE, 0, dev_name(parent));
 	if (!master->wq) {
 		ret = -ENOMEM;
 		goto err_put_dev;
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 592b646f6134b8..e6112e5f6608de 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -515,7 +515,7 @@ struct i3c_master_controller_ops {
  * @boardinfo.i2c: list of I2C boardinfo objects
  * @boardinfo: board-level information attached to devices connected on the bus
  * @bus: I3C bus exposed by this master
- * @wq: workqueue which can be used by master
+ * @wq: freezable workqueue which can be used by master
  *	drivers if they need to postpone operations that need to take place
  *	in a thread context. Typical examples are Hot Join processing which
  *	requires taking the bus lock in maintenance, which in turn, can only
-- 
2.53.0



