Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA6B387562;
	Tue, 10 Mar 2026 11:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141978; cv=none; b=K5SZitgxS8MCTNRyTcGJ0/MKwa717KVg1UQfvpPo7WAxkiTRsktxSwTHWfZ9HC7h9yh4+3QI3R9caZzsmsts7N69Gq+bs+V/C7a42BtVO9W8v/HuUMx2Ne862beLiWEWgP/ODo4PWvqzpWarWbCTzgizPma5h245ZwpZg7txTdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141978; c=relaxed/simple;
	bh=pjPkgDJ8r0zFSAWsYmD2rNTM8WHDPnZPOe+QCCDKvLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REPYomPthYsgugvZ+990KfvRHWDl4erbBXlRLhb1SJeUO/WxnwQg3VGGtfnHO0e3EQXuISJpEtqxsCGq+FLCgGWmhlvbUcjVQOKpHjcLztTqp4kjkTIukGSe+7Z5IwQYzCKGVjaasSF85FBsGW3dXblV0udNkTAA70Ld5xdKBGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSRt4F7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSRt4F7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BA0C2BC86;
	Tue, 10 Mar 2026 11:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141978;
	bh=pjPkgDJ8r0zFSAWsYmD2rNTM8WHDPnZPOe+QCCDKvLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSRt4F7o38C3HtvJoyx603048J7m+6nCxOmgZ3Cq95hwqrghOVGRs0aT6h3QsEciR
	 Fz+jiJOkCA6cAMHeZWOc4d+lXpEP+8HEBoUjPW9hCQN7PL6oejQz2R8OGyYDKOChNf
	 hhRLS790wE3iVvZgKpFLft8E4z3iv7DdasgUcb+IGIJXw1/NFbT5H/sNdi0jGNwQ7L
	 0MlJc+mIkW2bSgO06aL3tbYpS2/NhQERRfQ6PL0ZHckS7r8PcoMEsqqHSS6ce+5JTp
	 rtzLZczEYTruzXUH3P/Osyfukn1fgyAlYJsVRE7RuBZ5A7nZEXTjSovkEpJxsrn/r3
	 Pgs0Xrd8sI3TA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/314] Input: synaptics_i2c - replace use of system_wq with system_dfl_wq
Date: Tue, 10 Mar 2026 07:16:02 -0400
Message-ID: <a161baa22a77ecca963a38e272cd4ffa7f853fe8.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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

