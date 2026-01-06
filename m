Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948D034B414;
	Tue,  6 Jan 2026 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719968; cv=none; b=U4chTo4+u6bs4+8+VNUgk2AnA3v3J85fBBXqx8oA+93SrpPFG9BzDCBITXtCpy30p2evucCcngAdcxXR9OKF7AE40ahAwytW4uPA9v1oA54mdmv2nfkjXBCrshXFH8f4O9AiumXKJDN99hK5ujwG+VaGdmLBXGdU9FuEjLaICss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719968; c=relaxed/simple;
	bh=rqzJUACUjKXdC+n1lr6MqGo3omXmMqS4fuEk+rbpLBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEe32/zQaXcgXlqKLmhI8ST3uBOdwSYsdCu4Vu5flCHasHT1AhbD6EsbG9SdfF24SCSJVGGVMqeRWJrq0xCgNWJqOt+f3lQeIyXD+moytxWyMOgxuDRU09erfTATtT6F4FyfJ5yvzE7BPIDZqff4X+17l6wdn3TVenT2K1u7ckU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkdvIXgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkdvIXgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051EFC116C6;
	Tue,  6 Jan 2026 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719968;
	bh=rqzJUACUjKXdC+n1lr6MqGo3omXmMqS4fuEk+rbpLBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkdvIXgyM0LcZWdPWcXpH6j5pFqjHOtAP9aCZVOm04qonFUBkSQeUkoWNUIqHvZAa
	 O0hfOnhP8bXjiR9AArCYytj2pmTj5y8CXoCB/KLovEW0rzyYrT/OPOm+AtEz5L48b9
	 ifL2n+Vs+PD3BKhTQ2KL8m+R0C6/gUS8dapZE3EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 094/567] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Tue,  6 Jan 2026 17:57:56 +0100
Message-ID: <20260106170454.805421685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


