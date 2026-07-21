Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050F3D16E6;
	Tue, 21 Jul 2026 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657885; cv=none; b=h+pAylq428TWb3N9bpcdHScUb4hMV9o3fXv7VAldlnZsw7iYX9eIgn1e/bA4KgwwnI1zCjKOD7uFvOjeQ+RsSeoV91PRbEG0WXMgylLY4mV9fXHzZdvxEUxecHXQx5ZlwLsSJPtcyNhcAIM2l0GYwkH/J8MhUEesX4Wj7LhMx7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657885; c=relaxed/simple;
	bh=2c++WRD+93dvuu/GsklUVtITNROufrTUUe2EihmJJbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dkn+XX9f+5jktcUVlQhRSQMv98Z6dCBOStyM8OWmiQ0GoHDxmZG7aurDFVfidAQPt3XwEscjQiteL2MpIVHO8c5zX94ZfStWFME/y1mWX+5j81MmmVStTKz5JvqBMAooiYooh4Lh5UdpGoQH4XSH/5zFugFvEr9olrExJPWphWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UusffENB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UusffENB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F8C1F00A3A;
	Tue, 21 Jul 2026 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657883;
	bh=i+tbyUrMef1JD4O9Q+d8dO+3fpTdfuGBopJFOpYoAKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UusffENBob9ViP7+sgfqBqeFh8nIt1ckmsxGiKoMR2bo6HpDV5GBD1Yywr4bjzaNR
	 40Zjqj0QGE1x5EKwcHLZjQfn9ruYLXmPlM/LIUehsi/ZIWC6p411wbd0JIKv5Us0tr
	 7FOT0gmajv7Kc2hKEuU5NFdEOW+ToS9sI39WDIpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0880/1611] power: sequencing: fix ABBA deadlock in pwrseq_device_unregister()
Date: Tue, 21 Jul 2026 17:16:36 +0200
Message-ID: <20260721152535.185762465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d5da006e1ee856..0a1bc6c20c11b3 100644
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



