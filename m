Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1C576EB0;
	Wed,  9 Sep 2026 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963516; cv=none; b=MFw5dQp22Ry7hVj2rdN57JCGVDUY/j17MyauVAJbTa32mONcgnllIr6lLf9psyieUQo7rYwtDKuxcsHbD6s3QBECJNlDWKGhg7PCCN5QCpdNalcFIxwpNXeKxRqO43h1CFIbirQV60IhNRvXFHpIrURBVVfRO9aXyLv2ILgivZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963516; c=relaxed/simple;
	bh=q6PbE29ljMt2El5rvaZZVia7uJIZLKYekcM1Ap32zss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjCncwPoVppa0FDwy4BbiYfbVd+sivakQ8SfhbcjrWY7tLMpLg+IWfP1sPbIgiqjJkLBphrppV3g9lgsHiXVO21uGW+YusS+eQx1VzxTIlD9H6oFUE/etcJbCCx7HzOJD4bNuu47Uirk4ilGn+23Cztlpz+x2KYoWuUz4zyrsf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLEDGe0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLEDGe0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84D21F00A3A;
	Wed,  9 Sep 2026 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963514;
	bh=wPZwZD8XHv717e8viEv+zeehl+xytorjsi6dRykT4e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLEDGe0pPmz0FYXaZmUK3q+m7x/0MidpRUAUZ5CCPIWPPt1erkmLxk3TNvg8n/KBh
	 bFbxGcaJnzuH0QECQe+8aiWeVSKjR56xBPmWuLa3VZP0uHU3zJlSQSeTAwoK1bsTw5
	 U2n4no1tJRwmVeapRKq6P4jVkb3XeUAIaf9FS+lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 078/583] ceph: lock mutex in ceph_mds_check_access()
Date: Wed,  9 Sep 2026 15:36:03 +0200
Message-ID: <20260909134240.793789113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -5798,11 +5798,13 @@ int ceph_mds_check_access(struct ceph_md
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
@@ -5824,6 +5826,7 @@ int ceph_mds_check_access(struct ceph_md
 	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
 	      rw_perms_s);
 	if (root_squash_perms && rw_perms_s == NULL) {
+		mutex_unlock(&mdsc->mutex);
 		doutc(cl, "access allowed\n");
 		return 0;
 	}
@@ -5838,6 +5841,7 @@ int ceph_mds_check_access(struct ceph_md
 		      !!(mask & MAY_READ), !!(mask & MAY_WRITE));
 	}
 	doutc(cl, "access denied\n");
+	mutex_unlock(&mdsc->mutex);
 	return -EACCES;
 }
 
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -545,6 +545,7 @@ struct ceph_mds_client {
 	struct rw_semaphore     pool_perm_rwsem;
 	struct rb_root		pool_perm_tree;
 
+	/* protected by mutex */
 	u32			 s_cap_auths_num;
 	struct ceph_mds_cap_auth *s_cap_auths;
 


