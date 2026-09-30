Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED1C51121D;
	Wed, 30 Sep 2026 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784872; cv=none; b=bzPrgehpr69DvO0e0yLEkQnFjq4l+Rcrs3Vob6UYIIyThkZW6r+E5Q298AvtlOYLeJoAVF5mn/rArEac4t1ptRc+SMtL7EGP4wd3vx0uJKueFnsbsVYgd0/FzO7Z+Jgb5p6bDdDaXxZbsF78jHQJ2nDUe4LJUj565NHEMg/QV7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784872; c=relaxed/simple;
	bh=Rw/o969bAB3/AayVaczztELKBxISuEyNCbJMuz8tZ3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUjG0UFcHES7cGJJIrPrZmzOjSWruuHqwymz3nagcOgh+wHXTxeZa4tNEUvDePSfngXzVlLCXN1KQv8vaVnpeA45yrDzUZgTJhQmBmq03oPRuwPyGbPU6+tV5Fe9ZtxKMgvKavn17hXxplppcWgwnfvzq/EkyVsuj5hyNDlo/zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAcq/wnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAcq/wnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C941F00893;
	Wed, 30 Sep 2026 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784867;
	bh=pG9UWoN93NE05WVnS+IEjslfUyU05lP1g6yxRfID95Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAcq/wnf0fdhT+wQ5BNqUEasAVFkzfFAS6S8/p/xNPg8LQVELSh0T0s/V/Jgx8j9t
	 A7sBn/CcIAT35IVkDRPmfTCZjuSMBxIzf3PNQUaMT9cZs8QBH3dYcsZYvf5viK+Lt6
	 ewu36ECcIeBM8quQi5j3VKO6pDstwx1neVJ4yKA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/982] ksmbd: find bound sessions during reauthentication
Date: Wed, 30 Sep 2026 17:16:28 +0200
Message-ID: <20260930152422.206559851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

[ Upstream commit faf8578c77f3d846aca9cd882c293e03eafcc6df ]

A session bound to an additional connection is stored in the session
channel list, but it is not added to that connection's local session table.
After the binding exchange completes, conn->binding is cleared.

A later SESSION_SETUP reauthentication on the bound channel only searches
the local session table. It fails to find the session and returns
STATUS_USER_SESSION_DELETED instead of processing authentication and
returning STATUS_LOGON_FAILURE for invalid credentials.

If the local lookup fails, look up the session globally and accept it only
when the current connection is registered in its channel list. This keeps
unbound connections from using the session while allowing reauthentication
on an established channel.

This fixes smb2.session.bind_invalid_auth.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1f903350039cf..b5861e830aba3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1788,6 +1788,13 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	} else {
 		sess = ksmbd_session_lookup(conn,
 					    le64_to_cpu(req->hdr.SessionId));
+		if (!sess) {
+			sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
+			if (sess && !lookup_chann_list(sess, conn)) {
+				ksmbd_user_session_put(sess);
+				sess = NULL;
+			}
+		}
 		if (!sess) {
 			rc = -ENOENT;
 			goto out_err;
-- 
2.53.0



