Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D44F19AD5C;
	Tue,  8 Apr 2025 11:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112466; cv=none; b=t0v/qHOz2g0JkIKbCuhwLuUEP8j/oeUBwKyFLilnKg7YoOKGKPHTDYfIQ6f41/yD1imHqAcNBgOpLhCBPN3nTIXJtcugxHldESNjOJlqMEnkbaMfi61PNiDK1ZfGx9Q8hgQXo53F/Cj4NxXyt+cXbNCv6DAVzODJ2nB84V3sKOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112466; c=relaxed/simple;
	bh=YJExC8rur4smSnTmJcXRjlwp6mSYn1d1yAyqs/+6wrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9jSxTlDndKMYI4PrdABWIZAUlZQWd3DEfv/JGsd0cBfMJf1zGluAjuZdzcPUHDH6lRWd0ER7BV7r5DI54RO7Gn57MzM0WJwKNFtrZQjfSFrLz9GHpf1AG4eLweTE1XmpAxjmm37ygIOli+HFDB6a9KGP9op2jn/ECEGM7yFlZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njVgJa90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njVgJa90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB9DC4CEE5;
	Tue,  8 Apr 2025 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112466;
	bh=YJExC8rur4smSnTmJcXRjlwp6mSYn1d1yAyqs/+6wrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njVgJa90fIU3HFrC6w95V6V2h/S33hIUXKHsFHHyN3fSDdIOUDsJu2Y13dWwVt3gu
	 b8a+biHe+KVBdpzACc+GQdWYYXZlBxUBfpiIqPLkMEUdoM1ArQJmtjsjGErp8+YrYW
	 DyPkcnquwseTlAJ28rN3RDd5dzcXdJg4kBBsdVR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 077/279] smb: client: Fix match_session bug preventing session reuse
Date: Tue,  8 Apr 2025 12:47:40 +0200
Message-ID: <20250408104828.425071529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 605b249ea96770ac4fac4b8510a99e0f8442be5e upstream.

Fix a bug in match_session() that can causes the session to not be
reused in some cases.

Reproduction steps:

mount.cifs //server/share /mnt/a -o credentials=creds
mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l

mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
mount.cifs //server/share /mnt/a -o credentials=creds
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l

Cc: stable@vger.kernel.org
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1582,9 +1582,8 @@ out_err:
 
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
-	if (ctx->sectype != Unspecified &&
-	    ctx->sectype != ses->sectype)
-		return 0;
+	struct TCP_Server_Info *server = ses->server;
+	enum securityEnum ctx_sec, ses_sec;
 
 	/*
 	 * If an existing session is limited to less channels than
@@ -1597,11 +1596,19 @@ static int match_session(struct cifs_ses
 	}
 	spin_unlock(&ses->chan_lock);
 
-	switch (ses->sectype) {
+	ctx_sec = server->ops->select_sectype(server, ctx->sectype);
+	ses_sec = server->ops->select_sectype(server, ses->sectype);
+
+	if (ctx_sec != ses_sec)
+		return 0;
+
+	switch (ctx_sec) {
 	case Kerberos:
 		if (!uid_eq(ctx->cred_uid, ses->cred_uid))
 			return 0;
 		break;
+	case NTLMv2:
+	case RawNTLMSSP:
 	default:
 		/* NULL username means anonymous session */
 		if (ses->user_name == NULL) {


