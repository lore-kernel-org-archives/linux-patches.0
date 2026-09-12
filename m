Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8EF4195DA;
	Sat, 12 Sep 2026 09:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204055; cv=none; b=tpwoj99bGGfkoAvwGbQqNT/Ish8vG7xKT9HeYYq27oG+h3Ag9tL9fVzN4CMZNxOJ7sZKKLmaGWtY6kPiNh+lQHPJSc8lC0sM9SatB3UZPoPoaRrnFEva/Nnbm08IlfIKrlN2dzkmgcC4nEEeOQPmVjFgU272FpRiw01r93t8a+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204055; c=relaxed/simple;
	bh=nEOBQP+ABbbXQO6wCN4RWeaWFPrdUrHXsTRVDFzhaYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRFkdsvtwqvcaPvDzi8opk3cF/rGa/TU5XcbJei9BHX05N8x1fAw5DTp+5WcpIQQmJ2iRPNlvFiQK6ZKuR7YkoGVWb2L2TNb+YGjL1DXPiwxk4c4fXh4HogOv0ioSwh0oD3FsQTFniN62MSqvd6pIDmI6Nxo44SDlnbdJR8axNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6+06gms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6+06gms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4EB1F000FF;
	Sat, 12 Sep 2026 09:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204054;
	bh=MSE1/biUW6n53wqHfZCDU2FcyRlluFaN4Tmmi1GbqOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6+06gmsWLBb1xyC69MBoYzPRkveA9ChJkkn6ktK/7slGfG+fHwqQ10ub/IDbuikL
	 LYnzLRbqDErlydELI0M3NAGEht0kKDa8yH2/jgP4TXAp5pDmdSqdf1YME6xQy6xnrL
	 h9389odtNI6O6gf9p/T37siK+NCFoFfbjnBykMfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1534/1815] ksmbd: fix encrypted request lookup on bound channels
Date: Sat, 12 Sep 2026 08:54:44 +0200
Message-ID: <20260912065725.018835213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 2cbd4a8bf460cdf414a2d7e4912c5bcfe3d0fdc2 ]

An SMB3 multichannel binding registers the secondary connection in the
session channel list, but does not insert the session into the secondary
connection's session xarray.

The decryption path only searches the connection-local xarray.  As a
result, every encrypted request received on a bound channel fails with
"Could not get decryption key".

Use the channel-aware session lookup for decryption.  Also stop using the
temporary conn->binding flag to decide whether the global lookup is
allowed.  Validate the permanent channel association under chann_lock
instead.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c              |  2 +-
 fs/smb/server/mgmt/user_session.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index d51f32095adad..8bcd2a8a574e3 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -725,7 +725,7 @@ static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 		 * that the command can reach the session setup handler. Other
 		 * commands are rejected there with STATUS_NETWORK_SESSION_EXPIRED.
 		 */
-		sess = ksmbd_session_lookup(work->conn, ses_id);
+		sess = ksmbd_session_lookup_all_states(work->conn, ses_id);
 		if (sess && sess->state != SMB2_SESSION_VALID &&
 		    (sess->state != SMB2_SESSION_EXPIRED ||
 		     !sess->kerberos_expiry)) {
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 01c8bfb2606bb..25220371775cf 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -535,11 +535,18 @@ struct ksmbd_session *ksmbd_session_lookup_all_states(struct ksmbd_conn *conn,
 						      unsigned long long id)
 {
 	struct ksmbd_session *sess;
+	bool channel_found;
 
 	sess = ksmbd_session_lookup(conn, id);
-	if (!sess && conn->binding) {
+	if (!sess) {
 		sess = ksmbd_session_lookup_slowpath(id);
-		if (sess && !xa_load(&sess->ksmbd_chann_list, (long)conn)) {
+		if (!sess)
+			return NULL;
+
+		down_read(&sess->chann_lock);
+		channel_found = xa_load(&sess->ksmbd_chann_list, (long)conn);
+		up_read(&sess->chann_lock);
+		if (!channel_found) {
 			ksmbd_user_session_put(sess);
 			sess = NULL;
 		}
-- 
2.53.0



