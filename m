Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6067339A7FD;
	Tue, 21 Jul 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661056; cv=none; b=kcjeUG4SnCsnSMqHHUBbPe29gTO8cSS7vhmUlyKj+l2I94pYMHoZlACwTGL9g8CXTj99hjGrrY/pwH53AiFnmuMAh7y0BTW4kYZYE6mKgj675YrzxqXhjhQKAuNoasf79ejTcgQsG19kDruLJs+0U6HD0JPm0rtMUfLzdjPH1rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661056; c=relaxed/simple;
	bh=nK6HX+S9605Z18pgCDMtzbFPHWxg4KLYdIL+qZOhsS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQWtbBFvo6RY4iVK7ByLJQ3Qc5TkJKkIh9AiTOfNyx0uIi58URlDmNGroNqRPB0mEFZMRXizxqr8RN97TSSQ4mpYNu0Sw0bjMwwy5Xy/xB+piJVJ2RO0/q9pm9/AhwurlqgI7v8O3IZZ40D32SDZvEe7Oq8gsrP2KQjQwtvNjDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ikph/B8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ikph/B8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F7D1F000E9;
	Tue, 21 Jul 2026 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661055;
	bh=gNTAmwBDtT0I4xU8+zfOdG+XMGjrppzEhu/b1+tckao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ikph/B8dzJhjcL1phdQu0UphypYuhSGOYfvQh0xs89zH0QNXrJAUJWIG0P6DBlv0b
	 ebWaDePs5lqaaPQTptcwQVLgMxlIOq1f+9uKC50hCx92I4l0Jrm09M3GOIBsV3uTfM
	 OzxOc0o/rUI2MwsFqkiRkLWtpC/7jv/X/C+QI0lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1197/2077] power: sequencing: fix ABBA deadlock in pwrseq_device_unregister()
Date: Tue, 21 Jul 2026 17:14:30 +0200
Message-ID: <20260721152621.046144979@linuxfoundation.org>
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
index 9b512a055b5a4b..c12aa494698a6d 100644
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



