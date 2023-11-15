Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D65228382
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLwUR/Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73583C433C7;
	Wed, 15 Nov 2023 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076366;
	bh=sxhNYClWr5+5q//Blj0mJFx6C9CSDDdauij7vKuwHAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLwUR/TyJP6cbqdNC2S0v8Ywa9jFQ7tzBJQO80AurTab81P+rYbXsndxtcwvtJF5u
	 epiXieLJ0d4u0GHIJojM2JFIS2CA+dIiFZcBUEyAAjwy10/vVxSLImEzTqzgHcMSQC
	 LTCWSO3awmV01LaMZ9LrEuC0XKTtBarE7ObQEjOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 246/550] drm/bridge: lt9611uxc: fix the race in the error path
Date: Wed, 15 Nov 2023 14:13:50 -0500
Message-ID: <20231115191617.786328284@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 15fe53be46eaf4f6339cd433972ecc90513e3076 ]

If DSI host attachment fails, the LT9611UXC driver will remove the
bridge without ensuring that there is no outstanding HPD work being
done. In rare cases this can result in the warnings regarding the mutex
being incorrect. Fix this by forcebly freing IRQ and flushing the work.

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 0 PID: 10 at kernel/locking/mutex.c:582 __mutex_lock+0x468/0x77c
Modules linked in:
CPU: 0 PID: 10 Comm: kworker/0:1 Tainted: G     U             6.6.0-rc5-next-20231011-gd81f81c2b682-dirty #1206
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: events lt9611uxc_hpd_work
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __mutex_lock+0x468/0x77c
lr : __mutex_lock+0x468/0x77c
sp : ffff8000800a3c70
x29: ffff8000800a3c70 x28: 0000000000000000 x27: ffffd595fe333000
x26: ffff7c2f0002c005 x25: ffffd595ff1b3000 x24: ffffd595fccda5a0
x23: 0000000000000000 x22: 0000000000000002 x21: ffff7c2f056d91c8
x20: 0000000000000000 x19: ffff7c2f056d91c8 x18: fffffffffffe8db0
x17: 000000040044ffff x16: 005000f2b5503510 x15: 0000000000000000
x14: 000000000006efb8 x13: 0000000000000000 x12: 0000000000000037
x11: 0000000000000001 x10: 0000000000001470 x9 : ffff8000800a3ae0
x8 : ffff7c2f0027f8d0 x7 : ffff7c2f0027e400 x6 : ffffd595fc702b54
x5 : 0000000000000000 x4 : ffff8000800a0000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff7c2f0027e400
Call trace:
 __mutex_lock+0x468/0x77c
 mutex_lock_nested+0x24/0x30
 drm_bridge_hpd_notify+0x2c/0x5c
 lt9611uxc_hpd_work+0x6c/0x80
 process_one_work+0x1ec/0x51c
 worker_thread+0x1ec/0x3e4
 kthread+0x120/0x124
 ret_from_fork+0x10/0x20
irq event stamp: 15799
hardirqs last  enabled at (15799): [<ffffd595fc702ba4>] finish_task_switch.isra.0+0xa8/0x278
hardirqs last disabled at (15798): [<ffffd595fd5a1580>] __schedule+0x7b8/0xbd8
softirqs last  enabled at (15794): [<ffffd595fc690698>] __do_softirq+0x498/0x4e0
softirqs last disabled at (15771): [<ffffd595fc69615c>] ____do_softirq+0x10/0x1c

Fixes: bc6fa8676ebb ("drm/bridge/lontium-lt9611uxc: move HPD notification out of IRQ handler")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231011220002.382422-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index 2a57e804ea020..e562dc6cf4049 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -927,9 +927,9 @@ static int lt9611uxc_probe(struct i2c_client *client)
 	init_waitqueue_head(&lt9611uxc->wq);
 	INIT_WORK(&lt9611uxc->work, lt9611uxc_hpd_work);
 
-	ret = devm_request_threaded_irq(dev, client->irq, NULL,
-					lt9611uxc_irq_thread_handler,
-					IRQF_ONESHOT, "lt9611uxc", lt9611uxc);
+	ret = request_threaded_irq(client->irq, NULL,
+				   lt9611uxc_irq_thread_handler,
+				   IRQF_ONESHOT, "lt9611uxc", lt9611uxc);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
 		goto err_disable_regulators;
@@ -965,6 +965,8 @@ static int lt9611uxc_probe(struct i2c_client *client)
 	return lt9611uxc_audio_init(dev, lt9611uxc);
 
 err_remove_bridge:
+	free_irq(client->irq, lt9611uxc);
+	cancel_work_sync(&lt9611uxc->work);
 	drm_bridge_remove(&lt9611uxc->bridge);
 
 err_disable_regulators:
@@ -981,7 +983,7 @@ static void lt9611uxc_remove(struct i2c_client *client)
 {
 	struct lt9611uxc *lt9611uxc = i2c_get_clientdata(client);
 
-	disable_irq(client->irq);
+	free_irq(client->irq, lt9611uxc);
 	cancel_work_sync(&lt9611uxc->work);
 	lt9611uxc_audio_exit(lt9611uxc);
 	drm_bridge_remove(&lt9611uxc->bridge);
-- 
2.42.0



