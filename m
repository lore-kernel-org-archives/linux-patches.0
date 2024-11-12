Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C0B213125;
	Tue, 12 Nov 2024 10:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407745; cv=none; b=iVchJpNeVyT+NzEuF3JUqHFAUaS1QE38GhbZkFtfEWy6u1i0jE89M1CdPdJlf41BzI+2qIWeffXmgjwffaYrbJSz60KarSUVqBziqUX5dHH9gadyjz3pH9NKaXYajcg/f5m7MkXwQFV0CFwsLi5a6rczao3NMTAmHSewNQLEvqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407745; c=relaxed/simple;
	bh=wbLDc1TTxbkNWdnMRiMHrrVXGJmh8U4wutQ23d+i+cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiITHGLUXBJ12vmfeOtZsm80iQvLWpjjm2GGaYQvH6zqgC+QQTAINgpzh4cLVPDpiPaFij+wTVE1F9jnQs+gL8YCqnO76VZvApBazswdElGlt4LFTBQeAHwFz+88mR1TD3T8sFU4umzXnttPCI3rC5yVLyufOSmCLwS9YMOAB6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbb8kRTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbb8kRTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28AC4CECD;
	Tue, 12 Nov 2024 10:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407744;
	bh=wbLDc1TTxbkNWdnMRiMHrrVXGJmh8U4wutQ23d+i+cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbb8kRTLbjC1jxk2GHsHRp5RZOGa7zeMp3NQEt/72oWpOrkyI9wcHNAnomPueuSpC
	 R4zNu7K/G3v36y0swPE93S7sjQP0z6Q3ZoTm8sLZOl4h7PfwThr/N4985e/9Mus3vb
	 rMgRX9Eudut0r82PcxGVW7j7DStqaBKM4T6kfjaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 070/119] ksmbd: fix slab-use-after-free in ksmbd_smb2_session_create
Date: Tue, 12 Nov 2024 11:21:18 +0100
Message-ID: <20241112101851.389109384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 0a77715db22611df50b178374c51e2ba0d58866e upstream.

There is a race condition between ksmbd_smb2_session_create and
ksmbd_expire_session. This patch add missing sessions_table_lock
while adding/deleting session from global session table.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -174,6 +174,7 @@ static void ksmbd_expire_session(struct
 	unsigned long id;
 	struct ksmbd_session *sess;
 
+	down_write(&sessions_table_lock);
 	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
 		if (atomic_read(&sess->refcnt) == 0 &&
@@ -187,6 +188,7 @@ static void ksmbd_expire_session(struct
 		}
 	}
 	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
 }
 
 int ksmbd_session_register(struct ksmbd_conn *conn,
@@ -228,7 +230,6 @@ void ksmbd_sessions_deregister(struct ks
 			}
 		}
 	}
-	up_write(&sessions_table_lock);
 
 	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
@@ -248,6 +249,7 @@ void ksmbd_sessions_deregister(struct ks
 		}
 	}
 	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
 }
 
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,


