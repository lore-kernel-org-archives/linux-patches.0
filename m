Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C674633123A;
	Mon, 29 Dec 2025 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025239; cv=none; b=epDShIi+eOc/WzmTHkhq8X2glHkrDsvgIKlIWDYFLv9gWtdb/KRFnEXhqGSYKkmRn0WKn7qhwzjt3YnkUar3WSYYMnLq0arKIHsC5dWLc+lDSdn1tUdqAV0F33T3Tota4dsM3t6JdafS1pGyXJ4VkdcFAkE7Wx/JdtVZoRAJ4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025239; c=relaxed/simple;
	bh=G7VuWFA09tjW1LMJu7d/WQWAHqr521scszayic61Imw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzF0FGtnZyeJsP8OQ0xIR0LOo2NwCaNOW3HFF6x0rqzpUUjoYBE8rnu5IEoQ/Z6hJjOubp2wTxqNMH3UpFqq3HMldaW7TC763c0Wjry1v4mdgvZ/HynS+F+5oGvgai+Zk3w/uU5HInsp32pn5kEuixTa9ATYjiUC5YtxWf8935Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI8hqUQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI8hqUQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A74C4CEF7;
	Mon, 29 Dec 2025 16:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025239;
	bh=G7VuWFA09tjW1LMJu7d/WQWAHqr521scszayic61Imw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI8hqUQTFXmXh7vCwTNM9KlCOCEiydcZ6pWutZ3VWeyWThyXZh/Eewwi6s43PyTiY
	 N9mH0rVIwJNSffEZXEULJA5v5TypTcoSZywZ6jhvFjNUX/i81qvgAlN+5rx1E7US4i
	 +BUuCcStGtRtSfT1mRNzPovYB/gzHlseysyQMfXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 144/430] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Mon, 29 Dec 2025 17:09:06 +0100
Message-ID: <20251229160729.661862411@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -325,8 +325,10 @@ struct ksmbd_session *ksmbd_session_look
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
 


