Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826984;
	b=CT5VjNQd03f+KuRZJcpl6e+huYURyW3veQodT4nQg8e3OBwLmr2IG3jtxEt1zWxVZLhA
	 2346TRV97uU/qRk10exbXMYJgra7HQyXS9lp4PpFDurviZyB+2HpFG/D86H77bP7DUE4K
	 uTfirbpH9r/KADfrWUQFZB/W6uFHxHaWQix/1NPy+zGFKpbyY6kdf5uGssSTrJxYRCUiL
	 z/NUD/w3n/CRDpXbX86LVK5eX08RrkcVnGnTDZnlS9jnZg8BzK5cnfnb2z8lazysWrWoT
	 T/lP/Hfun6nhsV7W+XHbAzSVbdhJJZyPH/L8BCctaHiLLyIrNUEPyUnvF5U89g9vHMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4OTb0FV553+gfRS47gi1NH0x0rQJsBDduIlEahIhwEA=;
	b=1KIiL5FuGzHSukhc27LADa21scsb1P+D81FEHmufXQfmIbOSonFtzUqMYAOP1kZBF2Z/
	 NW0HfuTzT8HQ991gywCs2k558STMGMNq5tgWuPWSvLl4qOYJz7pnmSgLE1BwjGCqhRubc
	 QFhdkuCYRlpMvjwaKOescl660k8kTXXFByQOMAnjOBTBD0CmSouAMRTgb/Goz4olYZwkS
	 JeZ3wZygtcMvbEQJeT9HKDk7TN9lKjfjGowUaYCjzcIdM5kH6ln6Ed91cA6QV4cLMkh1R
	 BbEi1fEVJlc/AGrQG4qOCI8CqvuWkgWwiQJlhYShRBfRXvpOMBHkbI8LHaw2bv0dG/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZUYtDK9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4253D606A33B;
	Wed,  4 Nov 2026 21:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZUYtDK9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BAE1F00A1C;
	Wed,  4 Nov 2026 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826983;
	bh=4OTb0FV553+gfRS47gi1NH0x0rQJsBDduIlEahIhwEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZUYtDK9qXU09awip2P2crntq8lpLwF5eTS3XGPUMBz3WPQsYb7ZufTVSUtoe+iIf
	 lqJNCwcpzMMQkvyjwC1c2AcWm9AzHbMTJ5uGt+Mv90GKF8jDRVPlJEoB2p7MLwzC5G
	 LwTB2IxY9HdhxXfImcn+4OGP8043tfd32WP/3TtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 123/547] ksmbd: hold a connection reference for each session channel
Date: Wed,  4 Nov 2026 16:05:07 -0500
Message-ID: <20261104211041.684934002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit add8d7fb04efe564193df73581889c62fc0016f1 upstream.

ksmbd_session_unregister() removes a session from the global and per-
connection tables before dropping the table reference. A concurrent
reference holder can keep the session and its channel list alive after
those removals.

Connection cleanup can no longer find the unpublished session to remove its
channels. Since a channel only stores a raw conn pointer, the connection
can be freed while another session reference holder is still accessing it,
for example during SMB3.1.1 binding or a procfs read.

Take a connection reference when registering a channel and release it on
insertion failure, channel removal, or final session destruction. Keep the
channels and signing keys until the session is destroyed so a response can
still be signed after the session has been unregistered.

Fixes: d7fd1f98607f ("ksmbd: follow SMB2 session expiration semantics")
Cc: stable@vger.kernel.org
Reported-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    2 ++
 fs/smb/server/smb2pdu.c           |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -273,6 +273,7 @@ static void free_channel_list(struct ksm
 	down_write(&sess->chann_lock);
 	xa_for_each(&sess->ksmbd_chann_list, index, chann) {
 		xa_erase(&sess->ksmbd_chann_list, index);
+		ksmbd_conn_put(chann->conn);
 		kfree_sensitive(chann);
 	}
 
@@ -601,6 +602,7 @@ static int ksmbd_chann_del(struct ksmbd_
 	if (!chann)
 		return -ENOENT;
 
+	ksmbd_conn_put(chann->conn);
 	kfree_sensitive(chann);
 	return 0;
 }
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -116,11 +116,12 @@ static int register_session_channel(stru
 		goto out;
 	}
 
-	chann->conn = conn;
+	chann->conn = ksmbd_conn_get(conn);
 	memcpy(chann->sess_key, sess_key, sizeof(chann->sess_key));
 	old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
 		       KSMBD_DEFAULT_GFP);
 	if (xa_is_err(old)) {
+		ksmbd_conn_put(chann->conn);
 		kfree_sensitive(chann);
 		rc = xa_err(old);
 	}


