Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A712C1F473A;
	Tue,  3 Dec 2024 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239692; cv=none; b=UiIVUDDdylndqZYkSo9Pqjt5+yUhwZT4KNictRwWm3nyOlGknnAAqLY7UEItrU9mhkQTDXCQyWOzs0sLNW21zPDrvq6RgYnZAgLj2YnkKNBGYxt7IfdI2trL0LKuHSZbz5A5jriEDH131zueZ213swQlLelTqlGoG59Nn5BzFsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239692; c=relaxed/simple;
	bh=1Hq2MRV3oQ1to6ALcPXjS8KTasfwbkgqvZYbmZs2pNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzQuLT6WkhZe8tZWKClJe+gdmqdmWXCdXVKOg/qbXJrnx1rJeUTZRc4xzGCqukkBoBzHiREZs41DZmUUJ3/2eShyKrjsa/r9VGvaZoviSeMkDUK7H7jfC9F/s8bUmEPHjufXXgL863ucD+FZh0LHFhHnEIHGZhzoW/gOSPfsdE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2AihQjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2AihQjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE2DC4CECF;
	Tue,  3 Dec 2024 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239692;
	bh=1Hq2MRV3oQ1to6ALcPXjS8KTasfwbkgqvZYbmZs2pNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2AihQjfTdsFMTN2jwUG4p3SqSKYYzUUYtOsrpE7Q4uynWErPlLn8FOlTRsrKEa8I
	 UvxLNNLSsAbpsaeh/YY+7PJoKheFZ/mfdXU6DDXxtcKnwLpPbBwQoJoL/O8Si2BWcW
	 zhxPA37kXpRGxyTC5p5uVNhD4vA5kGJB8ku/n71o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 701/817] cifs: support mounting with alternate password to allow password rotation
Date: Tue,  3 Dec 2024 15:44:33 +0100
Message-ID: <20241203144023.341729398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meetakshi Setiya <msetiya@microsoft.com>

commit b9aef1b13a0a92aa7058ba235afb24b5b89153ca upstream.

Fixes the case for example where the password specified on mount is a
recently expired password, but password2 is valid.  Without this patch
this mount scenario would fail.

This patch introduces the following changes to support password rotation on
mount:

1. If an existing session is not found and the new session setup results in
EACCES, EKEYEXPIRED or EKEYREVOKED, swap password and password2 (if
available), and retry the mount.

2. To match the new mount with an existing session, add conditions to check
if a) password and password2 of the new mount and the existing session are
the same, or b) password of the new mount is the same as the password2 of
the existing session, and password2 of the new mount is the same as the
password of the existing session.

3. If an existing session is found, but needs reconnect, retry the session
setup after swapping password and password2 (if available), in case the
previous attempt results in EACCES, EKEYEXPIRED or EKEYREVOKED.

Cc: stable@vger.kernel.org
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   57 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 7 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1908,11 +1908,35 @@ static int match_session(struct cifs_ses
 			    CIFS_MAX_USERNAME_LEN))
 			return 0;
 		if ((ctx->username && strlen(ctx->username) != 0) &&
-		    ses->password != NULL &&
-		    strncmp(ses->password,
-			    ctx->password ? ctx->password : "",
-			    CIFS_MAX_PASSWORD_LEN))
-			return 0;
+		    ses->password != NULL) {
+
+			/* New mount can only share sessions with an existing mount if:
+			 * 1. Both password and password2 match, or
+			 * 2. password2 of the old mount matches password of the new mount
+			 *    and password of the old mount matches password2 of the new
+			 *	  mount
+			 */
+			if (ses->password2 != NULL && ctx->password2 != NULL) {
+				if (!((strncmp(ses->password, ctx->password ?
+					ctx->password : "", CIFS_MAX_PASSWORD_LEN) == 0 &&
+					strncmp(ses->password2, ctx->password2,
+					CIFS_MAX_PASSWORD_LEN) == 0) ||
+					(strncmp(ses->password, ctx->password2,
+					CIFS_MAX_PASSWORD_LEN) == 0 &&
+					strncmp(ses->password2, ctx->password ?
+					ctx->password : "", CIFS_MAX_PASSWORD_LEN) == 0)))
+					return 0;
+
+			} else if ((ses->password2 == NULL && ctx->password2 != NULL) ||
+				(ses->password2 != NULL && ctx->password2 == NULL)) {
+				return 0;
+
+			} else {
+				if (strncmp(ses->password, ctx->password ?
+					ctx->password : "", CIFS_MAX_PASSWORD_LEN))
+					return 0;
+			}
+		}
 	}
 
 	if (strcmp(ctx->local_nls->charset, ses->local_nls->charset))
@@ -2256,6 +2280,7 @@ struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
+	int retries = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2274,6 +2299,8 @@ cifs_get_smb_ses(struct TCP_Server_Info
 			cifs_dbg(FYI, "Session needs reconnect\n");
 
 			mutex_lock(&ses->session_mutex);
+
+retry_old_session:
 			rc = cifs_negotiate_protocol(xid, ses, server);
 			if (rc) {
 				mutex_unlock(&ses->session_mutex);
@@ -2286,6 +2313,13 @@ cifs_get_smb_ses(struct TCP_Server_Info
 			rc = cifs_setup_session(xid, ses, server,
 						ctx->local_nls);
 			if (rc) {
+				if (((rc == -EACCES) || (rc == -EKEYEXPIRED) ||
+					(rc == -EKEYREVOKED)) && !retries && ses->password2) {
+					retries++;
+					cifs_dbg(FYI, "Session reconnect failed, retrying with alternate password\n");
+					swap(ses->password, ses->password2);
+					goto retry_old_session;
+				}
 				mutex_unlock(&ses->session_mutex);
 				/* problem -- put our reference */
 				cifs_put_smb_ses(ses);
@@ -2361,6 +2395,7 @@ cifs_get_smb_ses(struct TCP_Server_Info
 	ses->chans_need_reconnect = 1;
 	spin_unlock(&ses->chan_lock);
 
+retry_new_session:
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(xid, ses, server);
 	if (!rc)
@@ -2373,8 +2408,16 @@ cifs_get_smb_ses(struct TCP_Server_Info
 	       sizeof(ses->smb3signingkey));
 	spin_unlock(&ses->chan_lock);
 
-	if (rc)
-		goto get_ses_fail;
+	if (rc) {
+		if (((rc == -EACCES) || (rc == -EKEYEXPIRED) ||
+			(rc == -EKEYREVOKED)) && !retries && ses->password2) {
+			retries++;
+			cifs_dbg(FYI, "Session setup failed, retrying with alternate password\n");
+			swap(ses->password, ses->password2);
+			goto retry_new_session;
+		} else
+			goto get_ses_fail;
+	}
 
 	/*
 	 * success, put it on the list and add it as first channel


