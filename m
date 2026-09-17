Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676E502D47;
	Thu, 17 Sep 2026 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665025; cv=none; b=kKcQSYaQ2XYWdPvA5a1InK+yt2QId7dKObe6Iz9Div51iw5Asx35sWr7pYpvwgV2WgKuBCdrBPS0AEx0yGx8n0q+qcgy3frtORebUws9578xp9V6u+wc4seSeDCm/707KBt0Vv/gylmzHgpbWMuTUq9J1ClW8OyUWbNUIfQz6rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665025; c=relaxed/simple;
	bh=y/bSs18fTjpqfUe7Mm0xkx/s4SvCLsR6fRow2nHuvtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBiIXVk+rK33Q+SSSxazaAAT8fBxP/p8C3t0+OxKBZIxhGX1rmtSPCR3+7PMSq99YdwRbo4RNhvRCzY7LtpCw70gJ2PfHwbnt9yoMmbNMTL/aD7vhqOQz7QRMcelp2BTkj8PdVKOyIy2quEXyvqxIgU6rh0Kb5tIFZhGm69Qr0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQDGypcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQDGypcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9588B1F00893;
	Thu, 17 Sep 2026 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665023;
	bh=DxmvC9WxN9hRpU2Ap48akdnYD/AxLo4L8aomRSWttOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQDGypcnVkq5QCJQqiIgEt2X4Yn9Fe+c4pdWnKe2HCEo2VJ+7WHX3POdHELv+Gnd8
	 WaM2QL/I63MRXFEVsEmDxfrYyAeCWG3x2m4kmoNdQBNxNgvek6EUK7tky7ykXyO3Su
	 zD38I6eG0KdC8YRfUwbf3mlNO5IbTvSVmtS4BASw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0568/1250] ksmbd: remove stale channels from all sessions on teardown
Date: Thu, 17 Sep 2026 16:06:03 +0100
Message-ID: <20260917151607.311533472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

[ Upstream commit b10665730fbf6b5e45fe422badcbbc3f0df96ef5 ]

ksmbd_sessions_deregister() removes a connection's channels from other
sessions' channel lists only while conn->binding is still set:

	if (conn->binding) {
		hash_for_each_safe(sessions_table, ...)
			ksmbd_chann_del(conn, sess);
	}

conn->binding is a transient flag: it is cleared once a binding
SESSION_SETUP completes, and also by a subsequent non-binding
SESSION_SETUP on the same connection (a reauthentication on a bound
channel, or a new SessionId==0 setup). A connection that has bound a
channel into another session's ksmbd_chann_list and then clears
conn->binding leaves that channel behind when it disconnects: the
channel, whose chann->conn points at the now freed struct ksmbd_conn,
stays on the owner session's list.

When the owning connection later tears down, the second loop
dereferences the stale channel:

	xa_for_each(&sess->ksmbd_chann_list, chann_id, chann)
		if (chann->conn != conn)
			ksmbd_conn_set_exiting(chann->conn);   /* freed */

which is a use-after-free write into the freed ksmbd_conn (the same
stale channel is also walked by show_proc_session() through /proc). The
session is leaked as well, because its channel list never empties.

Remove the conn->binding gate so a connection always removes its
channels from every session on teardown.

Fixes: faf8578c77f3 ("ksmbd: find bound sessions during reauthentication")
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index e815915665211..920eb3963ae9f 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -247,22 +247,19 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 {
 	struct ksmbd_session *sess;
 	unsigned long id;
+	struct hlist_node *tmp;
+	int bkt;
 
 	down_write(&sessions_table_lock);
-	if (conn->binding) {
-		int bkt;
-		struct hlist_node *tmp;
-
-		hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist) {
-			if (!ksmbd_chann_del(conn, sess) &&
-			    xa_empty(&sess->ksmbd_chann_list)) {
-				hash_del(&sess->hlist);
-				down_write(&conn->session_lock);
-				xa_erase(&conn->sessions, sess->id);
-				up_write(&conn->session_lock);
-				if (atomic_dec_and_test(&sess->refcnt))
-					ksmbd_session_destroy(sess);
-			}
+	hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist) {
+		if (!ksmbd_chann_del(conn, sess) &&
+		    xa_empty(&sess->ksmbd_chann_list)) {
+			hash_del(&sess->hlist);
+			down_write(&conn->session_lock);
+			xa_erase(&conn->sessions, sess->id);
+			up_write(&conn->session_lock);
+			if (atomic_dec_and_test(&sess->refcnt))
+				ksmbd_session_destroy(sess);
 		}
 	}
 
-- 
2.53.0



