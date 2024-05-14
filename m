Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F1C55C3B;
	Tue, 14 May 2024 10:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682536; cv=none; b=HaOI05wG/Bg8tvayxTKP7dhBbviRpzt/7RXxFoCz7qJgBVBO21BScgveCcreRUTMFY0pqy8xbs2ErWC0zb6rKdhBB8X+Dyyx3IHJvxYcWTaL0ARod/wM/Usovrg5cBXubW7zyCzZT92q3xvvm2eBiS1a7WQv2QIHtnqukNkiTks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682536; c=relaxed/simple;
	bh=JqiKmPSD2jYqppUYZTRrhSudI/k/nvXXgUcoIFDUgak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSe40Bz82QhSW3DHt+rf8cuscRe4fHh31R7UUoyvy8rZMqEYbIJ100Qjzn/S5mGEBVsCHfyVmvgP1EAEos08ed2dG0hCJw6etDoMiLYf8c/KJw3pEw3A8Pv2gX9Z1bPLw7MDY4QfXNls0Fsei4cRCHZ67A9858/jmvBU7EPo9kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rp0NhTSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rp0NhTSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12E4C2BD10;
	Tue, 14 May 2024 10:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682536;
	bh=JqiKmPSD2jYqppUYZTRrhSudI/k/nvXXgUcoIFDUgak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rp0NhTSbPeQDwtIBo+fgKvaESMzm8RShTZeWDTP4gxJbWobAbOSNQzASk+23vg44I
	 HPnjhu4fGqqLbzxhm7lWY3Jf15cpVj6OQAPb9FYZ3w1iIbUiGvLRcwN/LY7CLDur+z
	 wmPWFoEA0cHRZVhzlSYqmHX8OKQnUWl9vcEjMrJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/336] thermal/debugfs: Fix two locking issues with thermal zone debug
Date: Tue, 14 May 2024 12:14:11 +0200
Message-ID: <20240514101040.383967592@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c7f7c37271787a7f77d7eedc132b0b419a76b4c8 ]

With the current thermal zone locking arrangement in the debugfs code,
user space can open the "mitigations" file for a thermal zone before
the zone's debugfs pointer is set which will result in a NULL pointer
dereference in tze_seq_start().

Moreover, thermal_debug_tz_remove() is not called under the thermal
zone lock, so it can run in parallel with the other functions accessing
the thermal zone's struct thermal_debugfs object.  Then, it may clear
tz->debugfs after one of those functions has checked it and the
struct thermal_debugfs object may be freed prematurely.

To address the first problem, pass a pointer to the thermal zone's
struct thermal_debugfs object to debugfs_create_file() in
thermal_debug_tz_add() and make tze_seq_start(), tze_seq_next(),
tze_seq_stop(), and tze_seq_show() retrieve it from s->private
instead of a pointer to the thermal zone object.  This will ensure
that tz_debugfs will be valid across the "mitigations" file accesses
until thermal_debugfs_remove_id() called by thermal_debug_tz_remove()
removes that file.

To address the second problem, use tz->lock in thermal_debug_tz_remove()
around the tz->debugfs value check (in case the same thermal zone is
removed at the same time in two different threads) and its reset to NULL.

Fixes: 7ef01f228c9f ("thermal/debugfs: Add thermal debugfs information for mitigation episodes")
Cc :6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_debugfs.c | 34 ++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index 8d66b3a96be1a..1fe2914a8853b 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -139,11 +139,13 @@ struct tz_episode {
  * we keep track of the current position in the history array.
  *
  * @tz_episodes: a list of thermal mitigation episodes
+ * @tz: thermal zone this object belongs to
  * @trips_crossed: an array of trip points crossed by id
  * @nr_trips: the number of trip points currently being crossed
  */
 struct tz_debugfs {
 	struct list_head tz_episodes;
+	struct thermal_zone_device *tz;
 	int *trips_crossed;
 	int nr_trips;
 };
@@ -716,8 +718,7 @@ void thermal_debug_update_temp(struct thermal_zone_device *tz)
 
 static void *tze_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct thermal_zone_device *tz = s->private;
-	struct thermal_debugfs *thermal_dbg = tz->debugfs;
+	struct thermal_debugfs *thermal_dbg = s->private;
 	struct tz_debugfs *tz_dbg = &thermal_dbg->tz_dbg;
 
 	mutex_lock(&thermal_dbg->lock);
@@ -727,8 +728,7 @@ static void *tze_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *tze_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct thermal_zone_device *tz = s->private;
-	struct thermal_debugfs *thermal_dbg = tz->debugfs;
+	struct thermal_debugfs *thermal_dbg = s->private;
 	struct tz_debugfs *tz_dbg = &thermal_dbg->tz_dbg;
 
 	return seq_list_next(v, &tz_dbg->tz_episodes, pos);
@@ -736,15 +736,15 @@ static void *tze_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 static void tze_seq_stop(struct seq_file *s, void *v)
 {
-	struct thermal_zone_device *tz = s->private;
-	struct thermal_debugfs *thermal_dbg = tz->debugfs;
+	struct thermal_debugfs *thermal_dbg = s->private;
 
 	mutex_unlock(&thermal_dbg->lock);
 }
 
 static int tze_seq_show(struct seq_file *s, void *v)
 {
-	struct thermal_zone_device *tz = s->private;
+	struct thermal_debugfs *thermal_dbg = s->private;
+	struct thermal_zone_device *tz = thermal_dbg->tz_dbg.tz;
 	struct thermal_trip *trip;
 	struct tz_episode *tze;
 	const char *type;
@@ -810,6 +810,8 @@ void thermal_debug_tz_add(struct thermal_zone_device *tz)
 
 	tz_dbg = &thermal_dbg->tz_dbg;
 
+	tz_dbg->tz = tz;
+
 	tz_dbg->trips_crossed = kzalloc(sizeof(int) * tz->num_trips, GFP_KERNEL);
 	if (!tz_dbg->trips_crossed) {
 		thermal_debugfs_remove_id(thermal_dbg);
@@ -818,20 +820,30 @@ void thermal_debug_tz_add(struct thermal_zone_device *tz)
 
 	INIT_LIST_HEAD(&tz_dbg->tz_episodes);
 
-	debugfs_create_file("mitigations", 0400, thermal_dbg->d_top, tz, &tze_fops);
+	debugfs_create_file("mitigations", 0400, thermal_dbg->d_top,
+			    thermal_dbg, &tze_fops);
 
 	tz->debugfs = thermal_dbg;
 }
 
 void thermal_debug_tz_remove(struct thermal_zone_device *tz)
 {
-	struct thermal_debugfs *thermal_dbg = tz->debugfs;
+	struct thermal_debugfs *thermal_dbg;
 	struct tz_episode *tze, *tmp;
 	struct tz_debugfs *tz_dbg;
 	int *trips_crossed;
 
-	if (!thermal_dbg)
+	mutex_lock(&tz->lock);
+
+	thermal_dbg = tz->debugfs;
+	if (!thermal_dbg) {
+		mutex_unlock(&tz->lock);
 		return;
+	}
+
+	tz->debugfs = NULL;
+
+	mutex_unlock(&tz->lock);
 
 	tz_dbg = &thermal_dbg->tz_dbg;
 
@@ -844,8 +856,6 @@ void thermal_debug_tz_remove(struct thermal_zone_device *tz)
 		kfree(tze);
 	}
 
-	tz->debugfs = NULL;
-
 	mutex_unlock(&thermal_dbg->lock);
 
 	thermal_debugfs_remove_id(thermal_dbg);
-- 
2.43.0



