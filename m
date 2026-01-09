Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751ED33D50F;
	Fri,  9 Jan 2026 12:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960340; cv=none; b=JtmffgEzyuLvsc9I1PZDWciK5c+mDzn5eT8SuYIqz6tMhDN9JmWEcOMW1ff/lKC5guskygxFy3YG8RYC10aF9PpsMNXBRPZgZTbBO25989UEf/o2mTG+foaxfsHnBea4OlKlyoBDfwi4jpXHRY2OOioiPVwiMxa79gcnU6Zdvnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960340; c=relaxed/simple;
	bh=yNDRWy5kfg4Y610swwFa99+RjlnQJmuQR1ALI8WEI4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dii37VGV4UvlrFeoOzgbaAbBdOi55tkkH4az6Xzy6vhN08hWN56eZSzbSTIlUVRXGdAJJau4oR53t8S5PgEof51Zn7NtNLu3G8NmDwb/UikVLJ1kr+hHiCxoQ1dG+AKooBixBXx1glPlT/ZrdzcMSW+N4yDmGYpagmK5JlBNwd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kACVhxuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kACVhxuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D7BC4CEF1;
	Fri,  9 Jan 2026 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960340;
	bh=yNDRWy5kfg4Y610swwFa99+RjlnQJmuQR1ALI8WEI4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kACVhxuWA5cVbrMvSXHsId8rrU5+TNVqv8FT2lisBWfbC9yq2FgawI6loe0vsXnXq
	 6evhDdUo8XviRz6bRAF3XuXeiDVUFRt477Fl7Lq06xY3ESSIw9BpioaP5Dr9ywbRBG
	 Cmqa69TSsU6WWJ1Pxezj2PSHHs8mgXZACg4+yfc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 370/737] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Fri,  9 Jan 2026 12:38:29 +0100
Message-ID: <20260109112147.912959948@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
 


