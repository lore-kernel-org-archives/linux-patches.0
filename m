Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68A400DF6;
	Sat, 12 Sep 2026 09:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204075; cv=none; b=ZEfIO7nwVCp8YHFexpKy+833UKqqplgFubAVDaeJzPZQU4iR4XAjG208b9LC+b0LMElKFJgo01f9lvZhbJY2Ineu+L4vM3RXk7vGMcIcrWItrwhzRJ4Sci7oOM2dugMcw4XtwSo8egkZBVirEpe9r1KlTmljfkSvbg2qu9gszXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204075; c=relaxed/simple;
	bh=rI+sSTtactj+uxV9CkUbK+1QqLC9WtQ4HpeJdmo22mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIUKIng8Ppkr8mpKFQunaEvnxZDT+GbfTVxFEOF7Whd567Ols2dubaFrIG87D3AxjTljswCJor+KH3tPQpgu/jPTJTTMhsf2hdTgazt1zU1plxShNW7MwR1JU97nzbPJgIdj+b/dSo33KWDIfV9iL3kqCp/1qsLrBxrwDMfZ+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byhOcBih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byhOcBih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAAF1F000FF;
	Sat, 12 Sep 2026 09:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204074;
	bh=H+08AYmnFCZ3hq6+asjipHgp+45PNybDe+wVvVuuzR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byhOcBihysahXnsPPKk7Zkv/5qwrv1wFogNUfKOqDxpknDN6f7CwtX9kmoQ69Xlqw
	 4qI7yAQJKL/9xvx/BUCA+wndKu8V8LeDrMVav+upLkpF9XNoVB+boXtLPygCl/7gzH
	 SMYQKTVBtg5SqpVCTd+7ikCVJ9nQ7L8rZk8ZtkZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1537/1815] ksmbd: decrypt requests from expired encrypted sessions
Date: Sat, 12 Sep 2026 08:54:47 +0200
Message-ID: <20260912065725.090633830@linuxfoundation.org>
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

[ Upstream commit d8fc4fc7e57fc2bfd45699a10ee0df8ab9dccfa5 ]

Previous-session replacement marks the old session expired but retains its
SMB3 encryption key. An in-flight encrypted request can still arrive on
that connection. Rejecting the expired session before decryption made ksmbd
treat the request as a key failure and abort the transport, causing
reconnect failures.

Allow key lookup for expired sessions that have encryption enabled. Keep
the session reference during validation so the normal
STATUS_USER_SESSION_DELETED response is encrypted with the old key. The
session remains expired and no command is executed.

Fixes: fa9415d4024f ("ksmbd: mark SMB2_SESSION_EXPIRED to session when destroying previous session")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c    | 12 ++++++------
 fs/smb/server/smb2pdu.c |  8 ++++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 8bcd2a8a574e3..2d116d60f7f6c 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -720,15 +720,15 @@ static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 		sess = work->sess;
 	else {
 		/*
-		 * An encrypted SESSION_SETUP request may reauthenticate an expired
-		 * Kerberos session.  Keep using the established decryption key so
-		 * that the command can reach the session setup handler. Other
-		 * commands are rejected there with STATUS_NETWORK_SESSION_EXPIRED.
+		 * A previous-session replacement leaves the old encryption key in
+		 * place.  Use it to authenticate an encrypted request, then let
+		 * session validation reject the expired session.  This preserves the
+		 * encrypted STATUS_USER_SESSION_DELETED response without reviving
+		 * the session.
 		 */
 		sess = ksmbd_session_lookup_all_states(work->conn, ses_id);
 		if (sess && sess->state != SMB2_SESSION_VALID &&
-		    (sess->state != SMB2_SESSION_EXPIRED ||
-		     !sess->kerberos_expiry)) {
+		    (sess->state != SMB2_SESSION_EXPIRED || !sess->enc)) {
 			ksmbd_user_session_put(sess);
 			sess = NULL;
 		}
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9c9af31b8d1ec..6e1fb37452b42 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -995,6 +995,14 @@ int smb2_check_user_session(struct ksmbd_work *work)
 				1 : -EKEYEXPIRED;
 		}
 		if (work->sess->state != SMB2_SESSION_VALID) {
+			/*
+			 * Keep the reference for an encrypted request so the caller can
+			 * return STATUS_USER_SESSION_DELETED encrypted with the old key.
+			 */
+			if (work->encrypted &&
+			    work->sess->state == SMB2_SESSION_EXPIRED &&
+			    work->sess->enc)
+				return -ENOENT;
 			ksmbd_user_session_put(work->sess);
 			work->sess = NULL;
 			return -ENOENT;
-- 
2.53.0



