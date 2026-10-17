Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516987404E;
	Sat, 17 Oct 2026 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254816; cv=none; b=K+lRsNsAkELF+H7viSsgnlsGQPJXJoS7zMSe80oaS08IE7LL7Qt6z51AcEwPLvm5L8NQAk8yrGcSUu7n8Xj1yD7mP7H8U3FLYDwasNyFnRHidSkdUAIwYvC/S6xycvybcF1FmD5Kwl+gosj9lJyygPD29c6FToDs7OdGA1guQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254816; c=relaxed/simple;
	bh=dkEiIWkNlMG0iMCsneqpGFyHEdJDXM2zza5sFMjaa70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARUC2lkYRKZP8l6iWjk8aGGcokuy/uDmp6SpQUPoSsEtn8i9uTFzOV3Bl/7KEaJJwspZ9+KZ9KoggJzeVS4kGlNfg6R/20FwxpyIVIyMhUpBGLJCCZA0kOY/Zvpx15kkQZEflP2SQFbLiaCjgnLmEQ4HqNRBzKrPGggAvDa9F18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8jd/6uE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8jd/6uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2121F000C4;
	Sat, 17 Oct 2026 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254815;
	bh=3thE/FtDnYH8CGtk7Kshc/d7K5FtlYheBEjKcqVcTQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8jd/6uEwcnxEAhXQnK4AtgtfNF3r8Ul4KsUPKg5G9BU99Kkf8XWRFFkMe8joOBKj
	 Zq7ol0ptNReUTgcahIyIxkciGwCjHhaEyARChAhvv/ZuB0xlZ+DJ7HVdTVVbjvsXU0
	 Z6L4VY5bZsvyeaS/3LUi1SPzj49QD9CTv182FuKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 572/869] ceph: fix UAF in check_new_map() on session freed during unlock
Date: Sat, 17 Oct 2026 17:56:53 +0200
Message-ID: <20261017160051.732896146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 144483d932300..6694aac76a2dd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5219,9 +5219,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
@@ -5236,6 +5238,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
 			int rc;
 
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			clear_bit(i, targets);
 			rc = send_mds_reconnect(mdsc, s);
@@ -5244,6 +5247,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 					       "mds%d reconnect failed: %d\n",
 					       i, rc);
 			mutex_lock(&mdsc->mutex);
+			ceph_put_mds_session(s);
 		}
 
 		/*
@@ -5256,9 +5260,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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



