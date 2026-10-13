Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658424F5DF5;
	Tue, 13 Oct 2026 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893337; cv=none; b=uxlQGY9AVcJpcYsQ7u5G0kAtgOeFWMK6e2bvScw3oGhya3P4Dl/tZN3a7UcNVgTRdnyjwPFgxqgA9sZdiFQo90aHkNiQhjVc3vn1htcn7U4a810vw17GR7XBGkg7dXcrfHXuJ7mcQnOgT0gT3gkkbPqrrUXHPxao5mHq6jWg8TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893337; c=relaxed/simple;
	bh=WdGU/LRUVzFpimb3JsY42M5ir0SoJPHUNG/jZg72SXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfkZZjNXaqSrBIJ4U2WxXahK0CtFHdFtgQP+FSvdYxIImU46AUhfN7JX1N6mXT5/bajDNrNC49v7wM6mxUIxaMN1MZc0TCF9sizbKo5TVHChUZCc/he6DDScIaPVmrS4oViMCLRnHJBKtT4vXJOpXtGovdnlPmTkAMMRr4c7s4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZ9K1eiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZ9K1eiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D641F000FF;
	Tue, 13 Oct 2026 12:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893336;
	bh=BbNEVOj4/ETr1ofwoiUAS+2Z7s00oqt0eXg2ZstB3ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZ9K1eiCqUTY59uWZ3J14SMWrQ++qp+U9qmie5tiOoU8dK5lpR3+KlSckF6/BUnQl
	 N129tn3k2/P4DOd7AQROiPAX6W0pQI8QB3wOnYb00ujkMUmzd8jP3SehwRP+/MR/YB
	 3391bHXPv3k9cYuvIDMcPUsWG0OELiL6avF0P7MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Utkarsh Singh <utkarsh.singh.em@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/621] gfs2/sysfs: Replace sprintf/snprintf with sysfs_emit
Date: Tue, 13 Oct 2026 13:33:06 +0200
Message-ID: <20261013112925.394364450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Utkarsh Singh <utkarsh.singh.em@gmail.com>

[ Upstream commit 02c03021e2fced59b3b5b200fdd00018725d4ee2 ]

Documentation/filesystems/sysfs.rst mentions that show() should only
use sysfs_emit() or sysfs_emit_at() when formatting values returned
to user space. This patch updates the GFS2 sysfs interface accordingly.

It replaces uses of sprintf() and snprintf() in all *_show() functions
with sysfs_emit() to align with current kernel sysfs API best practices.
It also updates the TUNE_ATTR_2 macro to use sysfs_emit() instead of
snprintf().

Signed-off-by: Utkarsh Singh <utkarsh.singh.em@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: da6f5bbc2e79 ("gfs2: fix memory leaks in gfs2_fill_super error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/sys.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index c3c8842920d24..1213f97419f64 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -59,7 +59,7 @@ static struct kset *gfs2_kset;
 
 static ssize_t id_show(struct gfs2_sbd *sdp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%u:%u\n",
+	return sysfs_emit(buf, "%u:%u\n",
 			MAJOR(sdp->sd_vfs->s_dev), MINOR(sdp->sd_vfs->s_dev));
 }
 
@@ -68,7 +68,7 @@ static ssize_t status_show(struct gfs2_sbd *sdp, char *buf)
 	unsigned long f = sdp->sd_flags;
 	ssize_t s;
 
-	s = snprintf(buf, PAGE_SIZE,
+	s = sysfs_emit(buf,
 		     "Journal Checked:          %d\n"
 		     "Journal Live:             %d\n"
 		     "Journal ID:               %d\n"
@@ -140,7 +140,7 @@ static ssize_t status_show(struct gfs2_sbd *sdp, char *buf)
 
 static ssize_t fsname_show(struct gfs2_sbd *sdp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", sdp->sd_fsname);
+	return sysfs_emit(buf, "%s\n", sdp->sd_fsname);
 }
 
 static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
@@ -150,7 +150,7 @@ static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 	buf[0] = '\0';
 	if (uuid_is_null(&s->s_uuid))
 		return 0;
-	return snprintf(buf, PAGE_SIZE, "%pUB\n", &s->s_uuid);
+	return sysfs_emit(buf, "%pUB\n", &s->s_uuid);
 }
 
 static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
@@ -158,7 +158,7 @@ static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
 	struct super_block *sb = sdp->sd_vfs;
 	int frozen = (sb->s_writers.frozen == SB_UNFROZEN) ? 0 : 1;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", frozen);
+	return sysfs_emit(buf, "%d\n", frozen);
 }
 
 static ssize_t freeze_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
@@ -194,7 +194,7 @@ static ssize_t freeze_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 static ssize_t withdraw_show(struct gfs2_sbd *sdp, char *buf)
 {
 	unsigned int b = gfs2_withdrawing_or_withdrawn(sdp);
-	return snprintf(buf, PAGE_SIZE, "%u\n", b);
+	return sysfs_emit(buf, "%u\n", b);
 }
 
 static ssize_t withdraw_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
@@ -397,7 +397,7 @@ static struct kobj_type gfs2_ktype = {
 static ssize_t proto_name_show(struct gfs2_sbd *sdp, char *buf)
 {
 	const struct lm_lockops *ops = sdp->sd_lockstruct.ls_ops;
-	return sprintf(buf, "%s\n", ops->lm_proto_name);
+	return sysfs_emit(buf, "%s\n", ops->lm_proto_name);
 }
 
 static ssize_t block_show(struct gfs2_sbd *sdp, char *buf)
@@ -408,7 +408,7 @@ static ssize_t block_show(struct gfs2_sbd *sdp, char *buf)
 
 	if (test_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags))
 		val = 1;
-	ret = sprintf(buf, "%d\n", val);
+	ret = sysfs_emit(buf, "%d\n", val);
 	return ret;
 }
 
@@ -459,7 +459,7 @@ static ssize_t wdack_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 static ssize_t lkfirst_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%d\n", ls->ls_first);
+	return sysfs_emit(buf, "%d\n", ls->ls_first);
 }
 
 static ssize_t lkfirst_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
@@ -492,7 +492,7 @@ static ssize_t lkfirst_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 static ssize_t first_done_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%d\n", !!test_bit(DFL_FIRST_MOUNT_DONE, &ls->ls_recover_flags));
+	return sysfs_emit(buf, "%d\n", !!test_bit(DFL_FIRST_MOUNT_DONE, &ls->ls_recover_flags));
 }
 
 int gfs2_recover_set(struct gfs2_sbd *sdp, unsigned jid)
@@ -550,18 +550,18 @@ static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 static ssize_t recover_done_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%d\n", ls->ls_recover_jid_done);
+	return sysfs_emit(buf, "%d\n", ls->ls_recover_jid_done);
 }
 
 static ssize_t recover_status_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%d\n", ls->ls_recover_jid_status);
+	return sysfs_emit(buf, "%d\n", ls->ls_recover_jid_status);
 }
 
 static ssize_t jid_show(struct gfs2_sbd *sdp, char *buf)
 {
-	return sprintf(buf, "%d\n", sdp->sd_lockstruct.ls_jid);
+	return sysfs_emit(buf, "%d\n", sdp->sd_lockstruct.ls_jid);
 }
 
 static ssize_t jid_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
@@ -626,7 +626,7 @@ static struct attribute *lock_module_attrs[] = {
 
 static ssize_t quota_scale_show(struct gfs2_sbd *sdp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%u %u\n",
+	return sysfs_emit(buf, "%u %u\n",
 			sdp->sd_tune.gt_quota_scale_num,
 			sdp->sd_tune.gt_quota_scale_den);
 }
@@ -679,7 +679,7 @@ static struct gfs2_attr tune_attr_##name = __ATTR(name, 0644, show, store)
 #define TUNE_ATTR_2(name, store)                                              \
 static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                   \
 {                                                                             \
-	return snprintf(buf, PAGE_SIZE, "%u\n", sdp->sd_tune.gt_##name);      \
+	return sysfs_emit(buf, "%u\n", sdp->sd_tune.gt_##name);               \
 }                                                                             \
 TUNE_ATTR_3(name, name##_show, store)
 
-- 
2.53.0



