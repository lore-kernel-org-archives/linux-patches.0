Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831034;
	b=ad+jX5xsq1NNzgmT0Yeytxht0U6rIGuh/rdPBJa6JmriIkxqF3Rn5P+y8K7VDC9ZNAUE
	 SY6FMp2OLi+BaCMhyt3rot7N13Gs+da7fNPuSZESS7YFRD+l6lhjDuCegLIvvDD2tXDMV
	 Ji2prVFLw9EAbmLaC6On6A7jOrdi4Hr/SJ2syineTBLXeZGKjtChGduEhtEy5zY4+H5y5
	 wwCVqpMm41+jo7keFGGoJf3SF+RGUqG7An09Cmpq4Zl8xijouxxy/szYqcjbUIfYFgu4z
	 4mZvEuRAc01XXq3buYg0x9xgKnh6dEOjsPudLaxzpd60ML+UpjmkAgU1QttdJVuIj3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R97Gw77jkdSOm/J6zBPRSKnolcn2YJY67lKu08jp5O4=;
	b=WrE7sE+BSouepkmGNcyEpQTcYzPMpBX1+22dE18g5Gld0y6uKGYUPv7V0+lB8z1FVOFC
	 DEp/CoP2dm1RpjWqY7xaADAmj34zabT9/3Iz7dFg+w0xMZdP2AqVaMKg3LBU14LeFS2Fm
	 3FhoXRhEWOsShgl6uhJca+BDBKFydJX1f0VssB7vAW2+4+JpElgd741gP8FjJbcJn0Z1x
	 i2gsoF0vTCMulzAolG/wHN/l9hgE4OJEIAmUf43Upvgua0Ucxwvl5rPw0UDnAVTv4SPmS
	 YrkeuytAp+Wtt41VT/0AobzkG+A34T1fiwXnltj7ayiwgXbLGKaTZBcoL7q0FHES7bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql5CPx5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC6606B38C;
	Wed,  4 Nov 2026 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql5CPx5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAFF1F00A1A;
	Wed,  4 Nov 2026 22:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831034;
	bh=R97Gw77jkdSOm/J6zBPRSKnolcn2YJY67lKu08jp5O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql5CPx5HcaTr3PLd5vaAS0Tio3eQxccdwLekt1yPZvgncS8XUZQFRwBlx111+d+VZ
	 xnSnPvxgII2pqtZlsHDWZvn6XyZP3UC3wYcV1HNIBaxyx5hlmxAzpoEpmXnpyZ7Gcr
	 aLWlOL3jlv/Q5U6Pp8ta8Ss49BRvaTI8eHg7lB74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0421/1005] smb: server: Make sure that passkey is not leaked on the heap in user_config.c
Date: Wed,  4 Nov 2026 16:02:34 -0500
Message-ID: <20261104211055.892016127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 2c5a176882695f73b52482df03b0017b006ef2d1 ]

Use kfree_sensitive() to free the user->passkey (and the struct
ksmbd_login_response in ksmbd_login_user() that contains the same
information) to avoid that this information could leak somewhere
else via the heap.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_config.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index 0e5fcd6f95c15..909f219c79faa 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -28,7 +28,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 	user = ksmbd_alloc_user(resp, resp_ext);
 	kvfree(resp_ext);
 out:
-	kvfree(resp);
+	kvfree_sensitive(resp, sizeof(*resp));
 	return user;
 }
 
@@ -82,7 +82,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 
 err_free:
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 	return NULL;
 }
@@ -92,7 +92,7 @@ void ksmbd_free_user(struct ksmbd_user *user)
 	ksmbd_ipc_logout_request(user->name, user->flags);
 	kfree(user->sgid);
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 }
 
-- 
2.53.0



