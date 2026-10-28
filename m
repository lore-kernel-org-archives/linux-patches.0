Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216377;
	b=g5Q0mZ4RvE5GnJWC5V9llPrWGDvHDT5mRkU3Cami+hC7OVQgrCKNVoZNc4E6gSYNJ96C
	 pVLzArUqf7RQB2arf4M73VkN1u1S5TBSo+TQ6TQReeJeuKVoHZyIHCWBPGtziApxVzz4w
	 xCE0ktzdBDU2x1+VdeFPjvpi4+vCOW0+k88ThJgvOu8yFiU3UanqeHE11b7GvnoBm2iw+
	 szvWu/qBEmWdiD+cadR5KzJHuk/nFXnMxjWOhbgGgG5FXQYRSLpOYayvxIa7f7LgP+h8u
	 8U5/FIoDQ9Fu78exkQgkkpF1+ew/+UX66rizBrtI13Mvp62TNvCLVK+JygjRQJt0Ksg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7hFI4YvuRMX3JuqXlZzjEw58a+9vAELRluaETu3CXk=;
	b=GIBVh6rUFkhDadiCG7Vb5AmWFEcQVVIWCkIsaRhfE0D4gkFqaq+4jOjp+xZD+e2I3P1J
	 gRjJnpGWPZzGvjZgZpEYM8D6JfQsEsSClIZDgyLB7uT+vWBoChCrOrbFzBTKnwd9uliVc
	 P0VOC4+ZDYjZLI9Are1Q2Ttm7iCU3PSvv2/+P7iajiBQ7UCW+VTlk3/HxUTkTq241M7ok
	 fQbQNMaEx/uNS4O+bq+Uilxze5abg0VvwqlrOJaQLVr3bL37vIr/8tC9j4CweS5i+Ls5a
	 JCCQkayhz+N8haxtMRo1/Us47xY7ItFjQ8diSh+izVrIaa/kMhCgv51YEj2paeEDh2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfVX+1Sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DB0606A31E;
	Wed, 28 Oct 2026 19:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfVX+1Sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF69F1F01828;
	Wed, 28 Oct 2026 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216377;
	bh=w7hFI4YvuRMX3JuqXlZzjEw58a+9vAELRluaETu3CXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfVX+1SmuwN2Ki5Llp18pDb/9beUczg9YNA+YwXX832aO5g1Ei8y9vCcMqAHT70VN
	 W8fRvyqUCQfA+lf3PO8qUVqUeQjlNOveQiC57mbM3xazLj/v7pl1qGE2TnmA/P5Uvo
	 dm6ob66uy7rHaWgQfHTAS50QoYptVJAizDtFPhqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1535/1887] smb/server: fix session leak in ksmbd_session_register()
Date: Wed, 28 Oct 2026 18:00:31 +0100
Message-ID: <20261028170534.396169578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ze Tan <tanze@kylinos.cn>

[ Upstream commit 99b25b046e47e4904373cfeb445c5483f1633d88 ]

See the procedure below:

  smb2_sess_setup
    ksmbd_smb2_session_create
      __session_create
        atomic_set(&sess->refcnt, 2)
        hash_add(sessions_table, &sess->hlist, sess->id)
    ksmbd_session_register
      xa_store(&conn->sessions, sess->id, sess) // fail
    ksmbd_user_session_put
      atomic_dec(&sess->refcnt) // refcnt is 1, session is not freed

Remove the session from sessions_table and drop its table reference if
xa_store() fails.

Fixes: f5c779b7ddbd ("ksmbd: fix racy issue from session setup and logoff")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 33ae100fd07ed..abb5b4619f36c 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -212,10 +212,21 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess)
 {
+	int ret;
+
 	sess->dialect = conn->dialect;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	ksmbd_expire_session(conn);
-	return xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNEL));
+	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
+			      GFP_KERNEL));
+	if (ret) {
+		down_write(&sessions_table_lock);
+		hash_del(&sess->hlist);
+		up_write(&sessions_table_lock);
+		ksmbd_user_session_put(sess);
+	}
+
+	return ret;
 }
 
 static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
-- 
2.53.0



