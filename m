Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F1C3BBFD2;
	Wed, 30 Sep 2026 19:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794828; cv=none; b=Lw4DhyIccoff/B2WQpLC6gU36C7EaKGQcP9LRI+YkJ7gST47PZq/SVayoyEEzOMLj/Kb2mcYFgQFLExwJ+DIlmP6kV5ePtACtT9zSqgR8CGTaEtngptUGuPvjj6XXmtkiXNxINO3LwxxG7K0GBWSBouxDImEPo2OhAPQOzyU2mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794828; c=relaxed/simple;
	bh=5GtNmR0f59KBchxCw0J7H2Tv07mBOttCALHe5FX72lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdTJrndlkqxo11n8HZg6Mlt6v+NGC4X7vZQN5nQ1fxBucjy29/KtbaXuGHNMoX0LuTEPar6CoflXBbed2clFrHWTQLzmEgoVY9szm92375lQfrXPRectd0QmRro1rmYn1dW1lkt0SgV17xKGbOOAoet0j15qq8FN2wW0tutQAWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RK7zSUZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RK7zSUZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9F21F00898;
	Wed, 30 Sep 2026 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794827;
	bh=Nccqrrvq4nI68c21tGDyTfmnRc+OUbTvo7R6pKnhWSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RK7zSUZUC2OplTGxjXxxPKWN9dWF8C0VPdV9V3cXbO+vhE96FygNRMSWFP14uisOZ
	 bBmDh+3yBSacDlDeyeixYmNgf6A+dRjT5sARE3AQX8ZD9xFPWZc6WX5YijI6Ndovfq
	 IElv9BsOueILuYDVRyfcjlq5VQBK9b8UCBxUZcEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0347/1193] ksmbd: remove stale channels from all sessions on teardown
Date: Wed, 30 Sep 2026 17:17:11 +0200
Message-ID: <20260930152441.872178587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8423568710e76..64f6ff2a7a8b3 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -232,22 +232,19 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
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



