Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D992C35B142;
	Fri,  9 Jan 2026 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962301; cv=none; b=g15ydx9T4oe+a6/Bck4fyZexThkNwloaGAk9xpvQMilVwkspD0wJM/kf9Toh/PIBwOG1xdxXbeOdxe83yg5yyvA5XtXheOsz4uVwZ6e4AbjcBhtzO8FrHhUH5kvjPlRfqIAkiqA+kIHCr7puAPAfWFeotMHLegXrgSxiwYXxXpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962301; c=relaxed/simple;
	bh=+mgWIkuZ+pkr9nh5RMgkrNMq2/WDu8ZtEa0NR6SN3MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEY5ZfRyLbnjQKqWuBSoY6npzjARAuG7Yvbn1z4lYR+nYm5kgHLhkPwQl5ytq90wCbDxW8L7RpjenZ+bzlpg4WVbZMIUh4SlJVqrzweJa7+mXkiLYAMpBXpaNhyDo60+OWlYZ8KAnVzJtYqkH0fGem7P1O3j3Xxaeyt8d1UqDj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmJqCWot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmJqCWot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F392C4CEF1;
	Fri,  9 Jan 2026 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962301;
	bh=+mgWIkuZ+pkr9nh5RMgkrNMq2/WDu8ZtEa0NR6SN3MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmJqCWotIllNEzPPO41bGgeZAU+kG+RA/ed3RnVGhslenaTgsMCdxWCV7k8MnOpXR
	 /ZOg5SImYNyxVVPVWWbO3mBAimKrjojnZZv0UcSAabXebCAEBvdV5UHQ9Al1Wps9G9
	 HyExUAGYxmVWgtEWxux7FZAS3wVxt8f7ErFZAPkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 284/634] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Fri,  9 Jan 2026 12:39:22 +0100
Message-ID: <20260109112128.218425721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit cafb57f7bdd57abba87725eb4e82bbdca4959644 upstream.

When a session is found but its state is not SMB2_SESSION_VALID, It
indicates that no valid session was found, but it is missing to decrement
the reference count acquired by the session lookup, which results in
a reference count leak. This patch fixes the issue by explicitly calling
ksmbd_user_session_put to release the reference to the session.

Cc: stable@vger.kernel.org
Reported-by: Alexandre <roger.andersen@protonmail.com>
Reported-by: Stanislas Polu <spolu@dust.tt>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -312,8 +312,10 @@ struct ksmbd_session *ksmbd_session_look
 	sess = ksmbd_session_lookup(conn, id);
 	if (!sess && conn->binding)
 		sess = ksmbd_session_lookup_slowpath(id);
-	if (sess && sess->state != SMB2_SESSION_VALID)
+	if (sess && sess->state != SMB2_SESSION_VALID) {
+		ksmbd_user_session_put(sess);
 		sess = NULL;
+	}
 	return sess;
 }
 


