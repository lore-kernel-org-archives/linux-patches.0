Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9D5478E57;
	Sat, 12 Sep 2026 11:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213156; cv=none; b=pt2quvd4g11n+sEGqBX5wMjW5TXE/9MfZ9CRAjekXwBex8i35TxChOaT/pO1rIV3chHUZQecfSSCbsndPWEEtsfcRR7KNyeQEO991o07fhkt3Ofd9HW0TEP1mrAy39sXm9DdBVZi4GmSxPHvBAoStRDn9SqYe7ow/UqETIiMeR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213156; c=relaxed/simple;
	bh=Ftf+qOeA8MIbbsRCRvlRSKOSEWEdGOitYu/R4jbcI5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qvn6wkW7IjYVAuuSYahJZ4vVmOB/7RL2xePkXXUaWJQwUxtE/CSDkirVuKc7vpR5Sge/Kx/DL9TE2Gl4MJW0xlG1iaisnRJvYrU27BnKNw+KaJjLqeUmt+WsBFbNM73JUJULxKd1HgWulfk/ojYCC3psuKDF1Ug6DbwJPSMIaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnkdgmwE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnkdgmwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74421F000FF;
	Sat, 12 Sep 2026 11:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213152;
	bh=Qy6PnSh9SVYdG0kjYuum4rZ6T5e+fHW5+kxXmTF1cVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnkdgmwEP+rOJMhyzVfAHo9nveemjylrjKVNkn8x8o+3SEnS3nGkmJxmh5JjC6wez
	 O/eEKwtO5SGJUgVkziU+AYoGpkmOaneKhp6dXMIg/EJd/hS6OL10TMjYXiYWJkr/Wc
	 rdTB/Sa8InlJtcGIulkg5XXF0HoQ4Zc+Kq9j6p34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 0064/1376] ceph: lock mutex in ceph_mds_check_access()
Date: Sat, 12 Sep 2026 08:41:30 +0200
Message-ID: <20260912065608.987794958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

commit a61c6ae1dae2611082b831b4aaa780878099c012 upstream.

MDS session OPEN handling replaces mdsc->s_cap_auths under
mdsc->mutex, freeing the previous array and its strings.

ceph_mds_check_access() traverses this array without holding the
mutex.  A concurrent session reopen can therefore free the array while
it is being inspected, resulting in a use-after-free like this:

  Unable to handle kernel paging request at virtual address 003aaad64b2c8bb9
  [...]
  Internal error: Oops: 0000000096000004 [#1]  SMP
  Modules linked in:
  CPU: 56 UID: 2953037534 PID: 1253231 Comm: php-cgi8.4 Not tainted 6.18.45-i2-ampere #1146 NONE
  [..]
  pc : ceph_mds_check_access+0xd4/0x550
  lr : ceph_mds_check_access+0xc8/0x550
  [...]
  Call trace:
   ceph_mds_check_access+0xd4/0x550 (P)
   ceph_atomic_open+0x138/0xbe8
   path_openat+0xa24/0xfa8
   do_filp_open+0x94/0x158
   do_sys_openat2+0x88/0xf8

Cc: stable@vger.kernel.org
Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    4 ++++
 fs/ceph/mds_client.h |    1 +
 2 files changed, 5 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5795,11 +5795,13 @@ int ceph_mds_check_access(struct ceph_md
 	doutc(cl, "tpath '%s', mask %d, caller_uid %d, caller_gid %d\n",
 	      tpath, mask, caller_uid, caller_gid);
 
+	mutex_lock(&mdsc->mutex);
 	for (i = 0; i < mdsc->s_cap_auths_num; i++) {
 		struct ceph_mds_cap_auth *s = &mdsc->s_cap_auths[i];
 
 		err = ceph_mds_auth_match(mdsc, s, cred, tpath);
 		if (err < 0) {
+			mutex_unlock(&mdsc->mutex);
 			put_cred(cred);
 			return err;
 		} else if (err > 0) {
@@ -5821,6 +5823,7 @@ int ceph_mds_check_access(struct ceph_md
 	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
 	      rw_perms_s);
 	if (root_squash_perms && rw_perms_s == NULL) {
+		mutex_unlock(&mdsc->mutex);
 		doutc(cl, "access allowed\n");
 		return 0;
 	}
@@ -5835,6 +5838,7 @@ int ceph_mds_check_access(struct ceph_md
 		      !!(mask & MAY_READ), !!(mask & MAY_WRITE));
 	}
 	doutc(cl, "access denied\n");
+	mutex_unlock(&mdsc->mutex);
 	return -EACCES;
 }
 
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -540,6 +540,7 @@ struct ceph_mds_client {
 	struct rw_semaphore     pool_perm_rwsem;
 	struct rb_root		pool_perm_tree;
 
+	/* protected by mutex */
 	u32			 s_cap_auths_num;
 	struct ceph_mds_cap_auth *s_cap_auths;
 


