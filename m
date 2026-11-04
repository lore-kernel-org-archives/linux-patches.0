Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826981;
	b=AvQeDlXRsPFYNqcxsibOWn2HPLoDofErQLTprirO8Zs3n7zdpgMTnOt/uM1tp9pLq64V
	 Tbhw4dG+Sku+B9qwWxsiExLoxkLeW/rVjbVqE9JXq0GezVvN6Km7KKyvw6yru4HQs1w7o
	 NFnNZkVq0lesj4d7EvgdrBvF7DeFqICvX22EIFP1Yi5wWjsEQ5GLrlE7OH00azxgvazf/
	 2uHECjqtj+cw4QO/fiz0JRsoPeKAMAQtmH+6Luhmiyq84mag3owRk2CEEAlqz8izB2Bs5
	 rKELIGxx6fkZE7NuG34b3tmYiRzVFRfLorH+fWYzGAR5r7/uQPnQ0CIgSSMLV+5nXSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bXKBV2doVyh0iSUDNhFt8ypmAGksizstQmaLt/jN6h0=;
	b=1o5uBRCX+Dh2kIwuuFLbZO3ZSCltZ06bI8SyT33ZflkBpbCyd+Kmga4+fTB5A7pUvzE9
	 vWV+bLoqH3iOgios63Vrky1mzDmYToBI+pKCuOGgW8y/guwyARJ1glapSEIhGg+GK73bj
	 JfmvRCN5s6L2JQXKKA2bZb1XM2cI1Y3Nq2VQZe4xp7M/r5ErkzKHcZRVy5ceu31tVNyoa
	 F+L5Ixy8KWv2LJzcJRwh1sRyYb/1Qf0Ryxc8WMsn1pxlCpLQ3wifBTovQxFjDfH3zSVGH
	 WYgqpuh6l0q9fD3wjAMitoGOJI8QQbGRCQNVFKbekP1VHOPxtLs+lmFbty94v7Tz8Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XL45A+eF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3596073532;
	Wed,  4 Nov 2026 21:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XL45A+eF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D351F00A18;
	Wed,  4 Nov 2026 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826980;
	bh=bXKBV2doVyh0iSUDNhFt8ypmAGksizstQmaLt/jN6h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XL45A+eFuGVMrixo00Nu+spA+sX5QeA0doPWfKaQp1Ebac3y0uZhKPycBd8CUAkpL
	 8bvAl5JemYiz6Cq2bI4rzS66Yc7BTEYFxzVIeP3dzwQgf8hpHTvoXEJw5I0SoD6i3M
	 CwddCeQ+FB4Pr1hAyFsCoLeeNtvzgEVZjIKcS2q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 122/547] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Wed,  4 Nov 2026 16:05:06 -0500
Message-ID: <20261104211041.658546642@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

commit 03bd8f5279e490e15e0c0f0fa388ffbd2fbacd65 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2438,6 +2438,8 @@ int smb2_sess_setup(struct ksmbd_work *w
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess = NULL;
+	struct ksmbd_session *prev_sess = work->sess;
+	bool installed = false;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
@@ -2547,6 +2549,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 			int sign_ret;
 
 			work->sess = sess;
+			installed = true;
 			if (sess->dialect >= SMB30_PROT_ID)
 				sign_ret = smb3_check_sign_req(work);
 			else
@@ -2599,6 +2602,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 		conn->binding = false;
 	}
 	work->sess = sess;
+	installed = true;
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
@@ -2786,6 +2790,14 @@ out_err:
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
 


