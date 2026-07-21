Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5473471414;
	Tue, 21 Jul 2026 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662908; cv=none; b=kXQIQHqZ096+0jX7XGYBFOq0gVNO5lXRILa6cAoUd2GB0iIAXFKQwHVcXofIiYSyTVs5RITAneX5DQ6kOiuRNSwHyTiN62Ya8mLgxLlwJgO4j2ltNr9flPD+zG2hel1ODR9ou8t4MnhMlMN5QlCwnYcr3FHKBWrc8ra+TqfZ7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662908; c=relaxed/simple;
	bh=c0+VU8GHn5DLD1DBu6cHVjfThitCU3ByaajkCRNldzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMfyziR+cMw4KAiNj8bpeB4GmxniB9Nm4F2eElczL6dblJrY+dpqcRug2/rRHA/Av1DSc/cyHy/aK0nAAvGLFp+tLgLuACNTWlxxgz5L+EOO7nS8ONvDE1YFnbbpryEawTeUS+o+g+bkXLqtRKbm9QwD80rQ+anzj+8dinB7O60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D49S+G7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D49S+G7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416A61F000E9;
	Tue, 21 Jul 2026 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662906;
	bh=5b6C81v9DhRhW+4qKv1IGBVRXOppUa2NEsIwLyTSNHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D49S+G7Z9riAqvW+5USD4aFAxiGlWCMH0fq0hJcPBRK7yjKAZ8EBGtLSTVKoUCXxU
	 ZGLWO+2ftNAbO0ns6VerujI5Zr6JGVenYNMLrXjgbkLyE9HCEVfNV3qTLv177aOTDX
	 irtllZDfejsYhB1xgxDBOMkYtMtImdZtji2CMqqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0622/1276] power: sequencing: fix ABBA deadlock in pwrseq_device_unregister()
Date: Tue, 21 Jul 2026 17:17:45 +0200
Message-ID: <20260721152500.025713810@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 2d5a7d406ecece5837af1e278ffbbf6c0315560a ]

The pwrseq core takes three locks in consistent order everywhere:

  pwrseq_sem -> pwrseq->rw_lock -> pwrseq->state_lock

pwrseq_get() -> pwrseq_match_device() takes pwrseq_sem for reading, then
rw_lock for reading. pwrseq_power_on()/pwrseq_power_off() take rw_lock
for reading and then state_lock.

pwrseq_device_unregister() is the only exception, it takes: state_lock,
then rw_lock for writing and finally pwrseq_sem for writing. This created
two potential ABBA deadlock situations that sashiko pointed out.

  - pwrseq_power_on/off() take rw_lock for reading then state_lock, while
    pwrseq_unregister() takes state_lock then rw_lock for writing
  - pwrseq_get() takes pwrseq_sem for reading then rw_lock for reading,
    while pwrseq_unregister() takes rw_lock for writing then pwrseq_sem
    for writing

Reorder the unregister path to taking pwrseq_sem for writing -> rw_lock
for writing and drop the state_lock entirely. This is safe as
enable_count is only ever written under rw_lock held for read (via
pwrseq_unit_enable()/disable(), reached only from pwrseq_power_on/off()),
so holding rw_lock for writing already excludes every other writer and
reader and the active-users WARN() stays race-free without state_lock.

Fixes: 249ebf3f65f8 ("power: sequencing: implement the pwrseq core")
Closes: https://sashiko.dev/#/patchset/20260616151049.1705503-1-vulab%40iscas.ac.cn
Link: https://patch.msgid.link/20260618-pwrseq-abba-deadlock-v1-1-943a3fd81c06@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/power/sequencing/core.c b/drivers/power/sequencing/core.c
index 50aed0a5e8b215..7e94abd913a057 100644
--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -543,15 +543,18 @@ void pwrseq_device_unregister(struct pwrseq_device *pwrseq)
 	struct device *dev = &pwrseq->dev;
 	struct pwrseq_target *target;
 
-	scoped_guard(mutex, &pwrseq->state_lock) {
+	scoped_guard(rwsem_write, &pwrseq_sem) {
 		guard(rwsem_write)(&pwrseq->rw_lock);
 
+		/*
+		 * Holding rw_lock for write excludes all power on/off callers
+		 * (they hold it for read), so it's safe to read enable_count
+		 * here without taking the state_lock.
+		 */
 		list_for_each_entry(target, &pwrseq->targets, list)
 			WARN(target->unit->enable_count,
 			     "REMOVING POWER SEQUENCER WITH ACTIVE USERS\n");
 
-		guard(rwsem_write)(&pwrseq_sem);
-
 		device_del(dev);
 	}
 
-- 
2.53.0



