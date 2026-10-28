Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216058;
	b=OCfGcyQsWv5BSfF1jWgPNkgTAFLPc5IwdlXgOub0ag2UMclUaImAN2rmg0HS9Olm5eab
	 LrCffIzt1I9RKV44k6DHTlnsoMiukexXoyGlqZAqDbVqnRKsMAnrotfEEydB9mdb7AsTN
	 ilzH2KflGUtxrLJRc2qskD3+AOTjQuoimz2IjL6tkJOEB34pay4rDApblNfxnOWgE5q2Y
	 EziMaWoHR7HJ+9weDl8BtpUCVYOh3QcHdirrdvpp45iSXSkGCQr8LIX2vWUFrCiYB4BK8
	 2LCjfU9Xoq/YJ+Ul8+z2YtLGCSg1ti1oFjgucrXM+2cfkxaWcNzDWtY01bQpVapSACA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=prD/23pS3LP3YCpFEYs5lZc6p9B+tajqJ1xoR0VpWXA=;
	b=qE53FJxGPsDN8tHRPQFt8XOhsbq6HQGbRBGVm6n4G2oz4f/ZsqYkty7yzskEB7CUb+Pn
	 ADSESTz4M9juRYeLiIc7uB84+egGAYcw4rT3cqH200nJXnfYeJki6d+ibKMWb4MvE6m5a
	 urBjDMqjEMLoNKfM7kEnmSyFZKY508oMJEOf2go4eu2Skt6uojzbOqHYeE7TGh/aFC6Ai
	 W7aiwbF/9ZUcUtxzVKIy6cSlEbVkcAHCOF8lA1HzWAp9b07/CJ114It/dld7Bv3I2tlNv
	 wVo6KDEjV7B5K50WjKscvmsGCiW4ZJ27Q4iitjPD7HFyca2yt8jLQS2oHl9FbYj7/rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLCQ7m8b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3C6606A31C;
	Wed, 28 Oct 2026 19:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLCQ7m8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3701F01825;
	Wed, 28 Oct 2026 19:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216057;
	bh=prD/23pS3LP3YCpFEYs5lZc6p9B+tajqJ1xoR0VpWXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLCQ7m8bqxB4mnYG5sPA7VLjzX+oPZXe2aWSrrNqehkpGuu7ibaDD0uDqBeyOPJeQ
	 Kxk8Oc3OXRlzlbtQFy/TBSbwMhF/JTBA+ZSgZtahuY08EymSOgo4L1bH6qTmGhxu9+
	 YrqqKXLyulmZD38dac9/0bIWVTtaaUV7dwnz5yh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1427/1887] ceph: fix UAF in check_new_map() on session freed during unlock
Date: Wed, 28 Oct 2026 17:58:43 +0100
Message-ID: <20261028170531.933041996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 77bb4f7ba937d..0f28aeae054fb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4471,9 +4471,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
@@ -4486,10 +4488,12 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
@@ -4501,9 +4505,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			    oldstate != CEPH_MDS_STATE_STARTING)
 				pr_info("mds%d recovery completed\n", s->s_mds);
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



