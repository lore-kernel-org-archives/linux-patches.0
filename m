Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044827;
	b=MSTvWMhRyZ9MGLMTQu0wq8HnAlx+AzJkLA2Zli5gEiYg6Cd9mAkf6p8B7NsM0wcTJYlF
	 Uq0epg7gQKpEMLOZf8mtSMQcZ64XFtFydS+d2UypFsGnq6Jt4PwFHz0BsWsiNSCGOjxOe
	 W1xMP1ZnXndq5NszkviMkH7W3RZzsXEHVOZTfy8YYNuCKTz0r7KlxU9k/fJGAtGVV5HRd
	 T288AI9mtpiDpNU2NwEEq8vwmY6ctOHqTfifyQUyHtxkf6fyj5TAoPz7f9z5eKOeBldG/
	 QH8nE8Vv6DOi+QZF2Dl+tzXva2aMZR5T8h5CuBS7RXQvqfcghnwq2V4dPam61g8D2Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3KvzklE4R0vBUBghDgA5W+j9O2tHNN/kLMC7qXJFcJ8=;
	b=iMc7obuuYFctCxmNojNRV74F9wjYtmjpK5XAP/i1nRrAs2l1paIsqIf26vVigsE/lqxF
	 oXEgx+0rOwBWDNYUdaAXOBD6m6nAuTVdDiCOBKF27rYbuM4Kjh563DPTu3ehBVnVppw9J
	 OCMZx7C5vYqxP+EiRkbntGLyqSXhyuZIGif8cdJjodRtTtKV8ISd+6UwXLnvzUZl5yYPZ
	 hE7MNL1SHb7A2yeK3MtixlldqVNoJroEF1Sye+xpWFdBpGrX5ogcOXo08KdrPY17pbsBK
	 hsa0l44ZAJga1YfEMfJGNzAvsztGAgCovNTI1pFvkdUF+nv7S3YcN4CGCbPPxpvOBdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJBwrzci;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83952606A9C1;
	Wed, 18 Nov 2026 23:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJBwrzci
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30ED1F000C4;
	Wed, 18 Nov 2026 23:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044827;
	bh=3KvzklE4R0vBUBghDgA5W+j9O2tHNN/kLMC7qXJFcJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJBwrzcixqoZze2r78IuorkeYw3TxDFxDUgZ7btfGlkaK0f5I0QlcteKqAU98AVf3
	 vXlYHmd7qboWdQD/GCskEPoPEJQ2tHVmLub91ZvpR9akh0+f3xsSz1GmNfOOaqPa74
	 9CVgW8w7ajQ3z7H1/wOOUKQ0VxeP6k5b8FRjLQWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0679/2857] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Wed, 18 Nov 2026 15:28:33 +0100
Message-ID: <20261118150226.008722476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 03bd8f5279e490e15e0c0f0fa388ffbd2fbacd65 ]

A compound request can place SESSION_SETUP after another command. That
earlier command leaves a reference to its session in work->sess.
smb2_sess_setup() then overwrites work->sess with the session it looks up
or creates, and the dispatcher later puts work->sess only once. The
inherited reference is never dropped. That leaks the session, together
with its setup connection and socket, and every repeat of the compound
leaks another.

  unreferenced object (size 512):
    __kmalloc_cache_noprof+0x32c/0x3a0
    ksmbd_smb2_session_create+0xf6/0x9c0 [ksmbd]
    smb2_sess_setup+0xda4/0x6280 [ksmbd]
    handle_ksmbd_work+0x88c/0x1cb0 [ksmbd]

Save the inherited session on entry. After the request has been
processed, release it once, but only when smb2_sess_setup() has replaced
work->sess with its own session or cleared it. Do this after
ksmbd_conn_unlock() so the put does not run under srv_mutex. An error path
may instead leave the inherited session in work->sess. Keep it there, so
the dispatcher still puts it and the error response is still signed or
encrypted with it as before.

Fixes: 7aa8804c0b67 ("ksmbd: fix user-after-free from session log off")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: omitted the installed flag update for the missing session-binding signature-check block ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4d4271956492b..ec0ca117ec70a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1721,6 +1721,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess;
+	struct ksmbd_session *prev_sess = work->sess;
+	bool installed = false;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
@@ -1843,6 +1845,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		conn->binding = false;
 	}
 	work->sess = sess;
+	installed = true;
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
@@ -1996,6 +1999,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	}
 
 	ksmbd_conn_unlock(conn);
+
+	/*
+	 * Later in a compound, work->sess holds the reference that an
+	 * earlier command took. Drop it once this request has installed
+	 * its own session there or cleared it.
+	 */
+	if (prev_sess && (installed || !work->sess))
+		ksmbd_user_session_put(prev_sess);
 	return rc;
 }
 
-- 
2.53.0



