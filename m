Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4842A3839B2;
	Sat, 17 Oct 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259752; cv=none; b=j1ZXDBbTczDC6bT8NrfOfGQVdSMINhFr21XASvyFQG7YaZT2jDhj8c61qxNd7rK5IPCqiPeP+lqyZmChA5d697bj5qnhNpsJyEauNSEwNVRqWaF1aVXeXFPqGw61VeTympfmhAm9P5e4kBXiWgsTNVbHxVlk5H7CLXUVLX6MWy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259752; c=relaxed/simple;
	bh=P7uL5JOA0PJjmosqSUyHeiNgAQWmu4BIGBgB8+UN0Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=haAOF8NCvUycv5vWSlmFrJpEcH4sLrLPuDezIXTCaPyzJwNNKGS4+iddsXY/IBqsELJsk4N9YA9ZqoA9GMxP9RM6BRDU0Iy825V2F316cYD9o7yOrW+MBdfkHZoSwDZ+NPKwyfCxC6y0tdrAP4Fn44AdZ98lZxaQ6fEkxEyO2mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkFLnw+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkFLnw+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954CC1F000C4;
	Sat, 17 Oct 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259751;
	bh=CoBKY9fHoaxwaXh3zEonAFxsMy8EX4cYtt95iuwtQGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkFLnw+pXbvdtPijz1iPPZgw8yI7TnIvGP2JeRjgGNi3NAjdBUiYAzVzPhi/39ZwE
	 pyYRMl+5ZbnuvN5KL24s5lKwnrsazOGvz/sMIrxQvMm52QA/rKwQzYfICQWg9LuPh9
	 jarYNJZj++/cGF1KYv8gW0PPbT7pPRr8H7hyTi7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1316/1674] ceph: fix UAF in check_new_map() on session freed during unlock
Date: Sat, 17 Oct 2026 17:59:48 +0200
Message-ID: <20261017160504.923778154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ceph/mds_client.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 857bbb218a2bf..a32f6341fbeb6 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4885,6 +4885,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 {
 	int i, j, err;
 	int oldstate, newstate;
+	bool holding;
 	struct ceph_mds_session *s;
 	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
 	struct ceph_client *cl = mdsc->fsc->client;
@@ -4931,10 +4932,13 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			continue;
 		}
 
+		holding = false;
 		if (memcmp(ceph_mdsmap_get_addr(oldmap, i),
 			   ceph_mdsmap_get_addr(newmap, i),
 			   sizeof(struct ceph_entity_addr))) {
 			/* just close it */
+			holding = true;
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&s->s_mutex);
 			mutex_lock(&mdsc->mutex);
@@ -4950,6 +4954,10 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		 */
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
+			if (!holding) {
+				holding = true;
+				ceph_get_mds_session(s);
+			}
 			mutex_unlock(&mdsc->mutex);
 			clear_bit(i, targets);
 			send_mds_reconnect(mdsc, s);
@@ -4966,13 +4974,18 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 				pr_info_client(cl, "mds%d recovery completed\n",
 					       s->s_mds);
 			kick_requests(mdsc, i);
+			ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&s->s_mutex);
 			mutex_lock(&mdsc->mutex);
 			ceph_kick_flushing_caps(mdsc, s);
 			mutex_unlock(&s->s_mutex);
 			wake_up_session_caps(s, RECONNECT);
+			ceph_put_mds_session(s);
 		}
+
+		if (holding)
+			ceph_put_mds_session(s);
 	}
 
 	/*
-- 
2.53.0



