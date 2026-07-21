Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52A04302F5;
	Tue, 21 Jul 2026 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662714; cv=none; b=ebnqX/lRzkXeWH3qkzvLzqAsQNvwESrFAiEpCF2Sre/tMpraLp5AQrj00FpQu0qiSHHzIDNa+t6uHhuKyLGpql3mb0BSbROVZ38dnxLjQxq2xTyVxyo2YFp2dA3S7C/ac+SxzVRlTN8dntHawOPEBP4Zj6OlTGnaDJgtJjLJIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662714; c=relaxed/simple;
	bh=EjA4pTF+VcSVefJZQ3SfzfQS/UtieSTLsqICxDd1AcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pf+RucgghMlWPZ/RVYfrGCg7hszkiO7qZcOGzhzR08wtwZ9H0hUgz/C8zfWgIdBTUPV4cRKhTqvCIrK9fDya5rlxLBvVPe5zR611oQWoZR0HlVAzn8FYu0WQ9xVJRMwyrOhh8aRB1GiAuvc74zjaliliIo6HWBEWgC3iDJLlAm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsI8p6pM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsI8p6pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257071F000E9;
	Tue, 21 Jul 2026 19:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662713;
	bh=hUijHzzIRp1PkoptcY7xewdfnDZUh+7sLcT7wyPAQO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsI8p6pMpUn8SJpe3SlLUxF43TCAg6+7RWFVQDDXsSk1ut9a7axZvJdoQ7sbzbt7Q
	 ksj8zGTwArzLCmGYS2voLfSJ0YfRXjWTIN2GDIigU28FycN+aVwNPNlnohzSgpaFrH
	 KIiccEo+O9XVoHpWVwABOoXz0fhOJRcJlLCNcrOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0547/1276] i3c: master: Make hot-join workqueue freezable to block hot-join during suspend
Date: Tue, 21 Jul 2026 17:16:30 +0200
Message-ID: <20260721152458.363487432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index cde9b53a7fc4a6..ab89c8ef6ae86f 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2853,7 +2853,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
-	master->wq = alloc_workqueue("%s", WQ_PERCPU, 0, dev_name(parent));
+	master->wq = alloc_workqueue("%s", WQ_PERCPU | WQ_FREEZABLE, 0, dev_name(parent));
 	if (!master->wq) {
 		ret = -ENOMEM;
 		goto err_put_dev;
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 6e5328c6c6afd2..414a8acde01832 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -503,7 +503,7 @@ struct i3c_master_controller_ops {
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



