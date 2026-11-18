Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034239;
	b=YCOVZO5AaGzJj79uE0XeuVPKf6rnRYsUcW+ccOUVnXpYW83jQZsGSxpo9Fc7BwBVmBON
	 hU2ahvB3Mb9716Mt0v1Z0csm5VycNK8hy/zhrE66yZXCbj7dMBOJcr7TLq7azFhQ5oSz9
	 Jpvu5k7qQABD4bh206zuE+6HcavnIBWoJ7ZOA/tsspsOU7ciO35Vhjg93gm+ozykyT81E
	 MQ54W4TJFn9xm45TfHnquqbUf6e59VfnkS2UaB7wNDT0lgiyIgGrZd2iXtP9g6r6Z7gyZ
	 smfGvCgBwfOvNUY3NwFbAo5yzU4a98rPEy8FhaK/giWHWWtwy2W4Y4sQ47k5N+8zixQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KpNo5ZmSTOz7Zwly+4eoDyYqChmjIZM83cN7/ZGND04=;
	b=D2MRwdVWtJQ7K6NAX6n8TrAVv7WslO5wfMdNmOhKUkRB+o7mv6B+qhCT6nWi70Gn69//
	 Yo2jua6E1npPRM0kghOCE8ngdZQ6gjAb568ZIC2/61dUSONhzrLCNpdFxnzBHKyKm6zPe
	 2/u6A2lQ5ZiEdt/0wDonxVAmI5XwETyJLcgKMJYtdd7aKUAZcYWTfc92Eo0mLN7Y+2Ds1
	 PVS4xE9KI1afYDIcoZoqMPUgz/mEc47EqdgAvGdG4V1B9gPfx09NwaqUibF8sL5GSJEnN
	 VvRjIC7DPk2/K8V0jQ6IQEA678siR4jfW1POIeB+a5eSfGZSubj15safaiwUw7/tmsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXw0qLTW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984CC60A2613;
	Wed, 18 Nov 2026 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXw0qLTW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BCB1F000C4;
	Wed, 18 Nov 2026 20:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034239;
	bh=KpNo5ZmSTOz7Zwly+4eoDyYqChmjIZM83cN7/ZGND04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXw0qLTWT98gGpjThZZ05K56BKaSojo0ZT+dg+OjirA1N7ZtekQzCE0kTyPZsIjCO
	 OAvNAs0R46iHz8XbeL1tKewMsuKmtqjdIfDqsFq4GET/j8oKvs5hcp4ueogwgtAtSW
	 hSJfvdi7BlKYqYU5ajs5fPFpB/FUM14JCOMKMiBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0300/3318] smb: server: Make sure that passkey is not leaked on the heap in user_config.c
Date: Wed, 18 Nov 2026 15:15:22 +0100
Message-ID: <20261118150324.703124187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6d51ff79ba0d0..70d47d15320e9 100644
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



