Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4C63E557D;
	Tue, 13 Oct 2026 12:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893922; cv=none; b=V4IcN2KuxLU3+Fnsf0i7L9poVLMuJQZSFHtoSmzLO6zqep28tVvB49gBzQmoGCpltNOIYMsdPM8FD6lf4tAdPwu2e+Emh6Kp++6AdaIUtdDNyremvau+CfHj768RSma5u4JPPwPsHnjE0uNDiMog7W71Ysko0wzM1OyiOImnUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893922; c=relaxed/simple;
	bh=5urF8QUNHz6X8i44fNJIE46wwm4RNNuhi/K6WiUksMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8tQ0feaOfFTeXefZsnMi9ZasSSkfPkcmBBcLfDSHoB1+s6nwhz/uAfDU4eqQKOmOsz8BEw7I99AlbARbcHK06H4J8XU4sX6QlnGKAVqysZ+dC9yaa5vb/h6goda2pKqIHV8zSHiXFvNLSqTXAigDj8zuUoa75Rq4ustodl0PsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLqS+V9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLqS+V9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A611F000FF;
	Tue, 13 Oct 2026 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893920;
	bh=1W47tEbEb1cpKT1JzVMKYp9T6sM+9MD1w47aKw6zcZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLqS+V9XD/eny1Yf288T9CQoLO/uNqLXeYtJt4yxaUsYh8P8yDtIhdbYyaf08CZIS
	 TqAKgxzdcQ99yuWDy7egaX9rXnoRO5zAKchH/M9K3J11RvIuImuedLvYxhH7kiulAc
	 c313+0F2J74wHHd4Y/eZMwu1KRrSle15BQpyXjJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/621] ceph: fix UAF in check_new_map() on session freed during unlock
Date: Tue, 13 Oct 2026 13:36:20 +0200
Message-ID: <20261013112929.981023617@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit ee611a7509554c4ca1f54f6aefe592fb1df7ea70 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a2a63ea1f0ac2..342d8778b69cf 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5172,9 +5172,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
@@ -5187,10 +5189,12 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		 */
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			clear_bit(i, targets);
 			send_mds_reconnect(mdsc, s);
 			mutex_lock(&mdsc->mutex);
+			ceph_put_mds_session(s);
 		}
 
 		/*
@@ -5203,9 +5207,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
-- 
2.53.0



