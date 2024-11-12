Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D171170A3A;
	Tue, 12 Nov 2024 10:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407357; cv=none; b=pZ9vUNNvujYFXLTnzrblDNGLGSwKUGQJPemw2qCzTBefOK67ojYt0DEJPNRSpC8U4YUw/8J7+T7kneUxOpnP7Yaw+5zK6ykyTiiMrxrkM4Xbc5XK+ILzyFy0eSFlOab+6GZkccO843z4501M4auxsy92JJwwg4RESlS0AQ8ValY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407357; c=relaxed/simple;
	bh=LIAsy/WC08tWrjNsk88mE2U9VMNjyjuZwbgG7ovoIj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+uGnlxPqt+CTIoCgNV582x6ep9xMb8KsH2a9A6RPGNJAmGdp87u+lKw6OL5m+RBsIHbAWgrdE9hEuM1r2JGIiNGCF8anFlfWvYJcA3dJi+280HM7JF6o/XE25pxc8kt1izZa6BtROBCjieLlNTtPh6oxgUydLTTokD/gvuLhjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4kHURQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4kHURQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD52C4CECD;
	Tue, 12 Nov 2024 10:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407357;
	bh=LIAsy/WC08tWrjNsk88mE2U9VMNjyjuZwbgG7ovoIj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4kHURQZVFGdDmRB2AFv2PLXf7psHSHL1HxjGCTnr0jSZRvfxo3RNv746oSgiEN2k
	 NXA0xc3vgXf4PMmA6hjcuod7ZCaYHOPZ54uaVjfJJ5JiYdOoinzA9AKMtl65D1KqAY
	 rc6qITzAte+PUh/A1VrWbgmnKCiXzAkB8B7KWog4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 52/98] ksmbd: fix slab-use-after-free in ksmbd_smb2_session_create
Date: Tue, 12 Nov 2024 11:21:07 +0100
Message-ID: <20241112101846.249820656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


