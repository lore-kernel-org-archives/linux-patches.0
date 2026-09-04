Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA53F7AA9;
	Fri,  4 Sep 2026 05:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499019; cv=none; b=BbgE9g0EiJ4G233MPA9mzo4Abqta6t4/M0PpvA5GK+Jfzh8Q143pwXoKM2Gw5Yzz4+Ewy/JeJfw7yh8hvOxtu6CAkJxT6kOEDKhqvGHZf+axSb2C7dKL1XZ8nsUD/c6SdYPxzrjiMxWxapddh4JARgvFCxfx4TJ3Yuk2T6vhLUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499019; c=relaxed/simple;
	bh=9o5PKwtvaZTkOROPQi5rVy8zIyMs8/umCPN08Btd6b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ha6Q/LAJRjSKjJAdxObxGSh8hfetlhBHzbnChy5CB2LSCZ92EIlPMU2LiLwqcNbJ7m3/ltN8scAWJ3r/lNmH4Dck21QxIlHd8GRUNIDc44I7/AuJmBozVdDqp0Miai5jo8guemA9dSmci4AvarZNs6P3AHEr7MRnNBLA5QRLpeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEd6X4O9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEd6X4O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBEE1F00A3D;
	Fri,  4 Sep 2026 05:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499018;
	bh=g8nZbeNo8HZSUi1JKSEJTsRTgQkAqDFdkpwc5couVXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEd6X4O9+dEHiEiOy00J8htYsw8cJ3BvFdC5cMLtehq77LErWmJHBviIpNFO01w1J
	 XJpsp5GnI35Rgp0jscX4Jiv76W4aLwl64i3TsPD7+Tm8ddlmPz+aU/GjS4F48QsC83
	 qCS0z+E14fCuPgiJiQbALxlsYledVnqh5RzGyuNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.2 216/713] ceph: fix UAF in check_new_map() on session freed during unlock
Date: Fri,  4 Sep 2026 06:53:04 +0200
Message-ID: <20260904045808.659854002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubo.li@clyso.com>

commit ee611a7509554c4ca1f54f6aefe592fb1df7ea70 upstream.

check_new_map() iterates mdsc->sessions[] and for each active session
drops mdsc->mutex to perform per-session operations.  The forced-close
path (rank removed from map) correctly takes a reference on s via
ceph_get_mds_session() before releasing mdsc->mutex, but three other
paths do not:

  Path A (address changed):  mutex_unlock → mutex_lock(&s->s_mutex)
  Path B (reconnect):        mutex_unlock → send_mds_reconnect(mdsc, s)
  Path C (active transition): mutex_unlock → mutex_lock(&s->s_mutex)

Without the extra reference, another thread can acquire mdsc->mutex
during the unlock window, call __unregister_session() which drops the
last reference on s, and free it.  The original thread then accesses
freed memory via s->s_mutex.

Fix by adding ceph_get_mds_session(s) before each mutex_unlock and
ceph_put_mds_session(s) after the corresponding mutex_lock, matching
the pattern already used in the forced-close path.

Race timeline (Path A):

  Thread A (check_new_map)             Thread B (another map update
    holds mdsc->mutex                      or session teardown)
  --------------------------           --------------------------
  s = mdsc->sessions[i]
  (refcount == 1, held only by
   sessions[] array)

  mutex_unlock(&mdsc->mutex)
                               --->    acquires mdsc->mutex
                                       __unregister_session(mdsc, s)
                                         sessions[i] = NULL
                                         ceph_put_mds_session(s)
                                           refcount: 1 -> 0
                                           kfree(s)  <--- freed!

  mutex_lock(&s->s_mutex)
  UAF on freed s->s_mutex

Cc: stable@vger.kernel.org
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5834,9 +5834,11 @@ static void check_new_map(struct ceph_md
 			   ceph_mdsmap_get_addr(newmap, i),
 			   sizeof(struct ceph_entity_addr))) {
 			/* just close it */
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&s->s_mutex);
 			mutex_lock(&mdsc->mutex);
+			ceph_put_mds_session(s);
 			ceph_con_close(&s->s_con);
 			mutex_unlock(&s->s_mutex);
 			s->s_state = CEPH_MDS_SESSION_RESTARTING;
@@ -5851,6 +5853,7 @@ static void check_new_map(struct ceph_md
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
 			int rc;
 
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			clear_bit(i, targets);
 			rc = send_mds_reconnect(mdsc, s);
@@ -5859,6 +5862,7 @@ static void check_new_map(struct ceph_md
 					       "mds%d reconnect failed: %d\n",
 					       i, rc);
 			mutex_lock(&mdsc->mutex);
+			ceph_put_mds_session(s);
 		}
 
 		/*
@@ -5871,9 +5875,11 @@ static void check_new_map(struct ceph_md
 				pr_info_client(cl, "mds%d recovery completed\n",
 					       s->s_mds);
 			kick_requests(mdsc, i);
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&s->s_mutex);
 			mutex_lock(&mdsc->mutex);
+			ceph_put_mds_session(s);
 			ceph_kick_flushing_caps(mdsc, s);
 			mutex_unlock(&s->s_mutex);
 			wake_up_session_caps(s, RECONNECT);


