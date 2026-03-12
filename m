Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EAF1A0712;
	Thu, 12 Mar 2026 20:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346791; cv=none; b=WU4FJl58+tdfrwTb4d1gdxY2LyMWevKBxQySIRpRd01L6aK/km47ZxFjYW8xHKccxe/jZ/a6YCTXO+DXFVZD03y6ZJBWgZkqnyQkh1EatiHG4TYVGp5E+Mm3IrXZzheScnbkEQLOjXRAxZJzSNEN1L2+qpaAaikN1fnI0XPnAOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346791; c=relaxed/simple;
	bh=U9ErQx5Kjz589gWP1aH9WvvdDq+fcD4Knk/Aq+NhclM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3rI25HtMDySKvGJGzzAt+SArUh8O2PVMI3rCxGt2v8qsDiI4VB0wmeqjUWIjGQZ5LQYi9RB5vma7Hfp1uPg+4wO+AS5pQaFptKZ04AWSDE8fY4fiLy+huvyQPjLOBOhECUQh83etAzLmlmm0z++BoTIZuGZGN7qOP79/jnEKeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfOrIFFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfOrIFFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F1C4CEF7;
	Thu, 12 Mar 2026 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346791;
	bh=U9ErQx5Kjz589gWP1aH9WvvdDq+fcD4Knk/Aq+NhclM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfOrIFFMsXmsZFXRtjJHeauFwFWSvT8kjq2CrQfgJLrnNCNQMDIzOjMVscnFgHqNI
	 3v57Ms3gz8ty49+QUsr+Cjih682MxiLusOyDGuNzJFXgb1RMJaVRqMfQKXESkzjFTZ
	 XLWdhS4khrSTkcrMIO0KMCWoOAv4LPfSHxfOMbW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/265] Input: synaptics_i2c - replace use of system_wq with system_dfl_wq
Date: Thu, 12 Mar 2026 21:07:49 +0100
Message-ID: <20260312201021.182449047@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit b3ee88e27798f0e8dd3a81867804d693da74d57d ]

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This specific workload do not benefit from a per-cpu workqueue, so use
the default unbound workqueue (system_dfl_wq) instead.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Link: https://patch.msgid.link/20251106141955.218911-4-marco.crivellari@suse.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 870c2e7cd881 ("Input: synaptics_i2c - guard polling restart in resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics_i2c.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index a0d707e47d932..c8ddfff2605ff 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -372,7 +372,7 @@ static irqreturn_t synaptics_i2c_irq(int irq, void *dev_id)
 {
 	struct synaptics_i2c *touch = dev_id;
 
-	mod_delayed_work(system_wq, &touch->dwork, 0);
+	mod_delayed_work(system_dfl_wq, &touch->dwork, 0);
 
 	return IRQ_HANDLED;
 }
@@ -448,7 +448,7 @@ static void synaptics_i2c_work_handler(struct work_struct *work)
 	 * We poll the device once in THREAD_IRQ_SLEEP_SECS and
 	 * if error is detected, we try to reset and reconfigure the touchpad.
 	 */
-	mod_delayed_work(system_wq, &touch->dwork, delay);
+	mod_delayed_work(system_dfl_wq, &touch->dwork, delay);
 }
 
 static int synaptics_i2c_open(struct input_dev *input)
@@ -461,7 +461,7 @@ static int synaptics_i2c_open(struct input_dev *input)
 		return ret;
 
 	if (polling_req)
-		mod_delayed_work(system_wq, &touch->dwork,
+		mod_delayed_work(system_dfl_wq, &touch->dwork,
 				msecs_to_jiffies(NO_DATA_SLEEP_MSECS));
 
 	return 0;
@@ -620,7 +620,7 @@ static int synaptics_i2c_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	mod_delayed_work(system_wq, &touch->dwork,
+	mod_delayed_work(system_dfl_wq, &touch->dwork,
 				msecs_to_jiffies(NO_DATA_SLEEP_MSECS));
 
 	return 0;
-- 
2.51.0



