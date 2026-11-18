Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035620;
	b=WSQZyGJRONfQEB2eFw5DofUIrcFbVJI0EVeQPcGLTpSzkRgl266PnL161LtPSkTu8r29
	 3+FStugcI9H47dvnZbWNTEQGJGMs6nonZhGv6ck0SA7KkRVhoHTBAI/ue2BPVfBfuovw1
	 trA6RhgeIYcBsixyZjLcDIctykqberYL5FIP07EcTxQyWhhoMlnCYshF341tsiPhiXSWc
	 3OraO+vHJH2RqwXNAoaZMFlbRnEP8teKKM2l83WhHa3OGjLvaVqru5GnJmcE+wsc7s8Cu
	 8VlbzWba5jCCV52OqdFMG3rtg5SuUaPFLo3zBu5Sil+hzcdgzlHhVbUMfX7QNeT+6/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vbUfW+ZpkeEZUHTKZdpJ8j7Cfe/VQe/mzrVxceW0WOk=;
	b=cShHgeqV5xNm6a1vY+FRviyf+rfQb/SpLhuIb88JBm+ybR2L3/B5Zy14iUcpkPC2qgqk
	 WJE/M5tBNFRSRxN6GdImpSLGBWw7dpUXBvjFs063yPsnpbWVQXW1SITrJo4pCAC6oy63f
	 7p8PP0vi5VQSJ1KDKcuQHvQ4u7qyzS178yeO0MHF0fFnmMj66VrWraR318N0U2Wr4hAAO
	 1gZLqZ4aJ/k9rTWvhNKhJwIEOdKK+RHKWldeEdFDUj+XTO9oWYKfmkHFryIb8aMeJm7m7
	 vNo08WuL3sGcyqGquFF2Plz4l94JsvsRhT4d+oMDpBCWlrRU/67ClfwqjhunucBIAVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7Iq0No7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D706606A331;
	Wed, 18 Nov 2026 21:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7Iq0No7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4027B1F000C6;
	Wed, 18 Nov 2026 21:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035619;
	bh=vbUfW+ZpkeEZUHTKZdpJ8j7Cfe/VQe/mzrVxceW0WOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7Iq0No7WbV88yRqtCrcIbKQCYi98sIzR+fZlokjSiDKsA3Ho6viWObZuVhAeV7Ni
	 Jj1uJFnsUUD5/vOpTuiKbi0CHbThE3PC0hC0kfsvnoGtbP0S4W1dfKKo/4MvvXBjW5
	 b/+l1o1ZnjGnN2shnsDNTPEpd0386vKxAtOJhK1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0768/3318] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Wed, 18 Nov 2026 15:23:10 +0100
Message-ID: <20261118150341.790285840@linuxfoundation.org>
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
[ sashal: omitted the installed flag update in the absent session binding signature check block ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index be86f1fbde1fd..a454663bc538c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1704,6 +1704,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess;
+	struct ksmbd_session *prev_sess = work->sess;
+	bool installed = false;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
@@ -1826,6 +1828,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		conn->binding = false;
 	}
 	work->sess = sess;
+	installed = true;
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
@@ -1979,6 +1982,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
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



