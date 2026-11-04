Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831953;
	b=OO8ulAuu8DJOyUOOx12QtGvPNoD+2kWHhMDw95/rghS5kIio+8t9KT+8hRzvzDqXQpzt
	 OhUVCoq898pQ2uI2aZNAszVniMhzZZQvjS9I42u3tN+sgG9ZZw1va70ZCaR80/4wYeCZD
	 7kTVtnuTq/MzoJy8Et/xgedbAY5jbXgvvnN7SU5LPvA5WCA2DYFyV6a1bytCthOD03V2n
	 pfIvg7VPQH6hv48PfmDtDjkCQGt3PPdkSAaSodPlQJnndiT417GU47lUDsGGUDTcnn8Wl
	 mY0+w1qmuBR4AYJrdk7J/A2c4kBve1S3WQJmFAC5fJkPhOw0V43RjVKJpXl5MriOx2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=26v9iSkZGOfuWbkYVb0zVmZl61VGyt0wd3I9/D9M5zA=;
	b=TFb06AKMS49r3PPt+WslqEdWrzMbUxZJG1x4q1ywz3Rsa62HP3cXV9nLMIPRRaqGdfJQ
	 f2bAzjcSF1X8dpogLdYPu7Qy2Q9dQ/8ge1BMWot8TEOGy6yyutIMKrWyAKOih8rChrB0O
	 YyyDv4m1VmqAnrDpgVwIV1bF/npTcRSkIS25c8qSKc+SsA0vmQAh7re5iMndterpkpPna
	 IUqPCJ/pcF32Bm19/h85PKjhnELRsvYWnROooezSEz/G1QpWtb3sSOqkVT3K28dolnErr
	 OHVwYuHAWcCQAlHUOyw4a7IyrfBbi/xdi6J7uZlgzzD1G04AQ1Z4SI0OiVYz0aMgvtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXHdh66x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7053E606A332;
	Wed,  4 Nov 2026 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXHdh66x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C41F0093A;
	Wed,  4 Nov 2026 22:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831953;
	bh=26v9iSkZGOfuWbkYVb0zVmZl61VGyt0wd3I9/D9M5zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXHdh66xbKCam/L3lXDHWKErPEQWrgDaOy1GBrRLOOTjm/AxpxKswUFoy++Np0zrI
	 1rP11ezpe39ZsRQFXUSyDta8YIVZu67SxLasG/4DRJ91PSEfzx99MryijPI6oVVGzz
	 Vl3IrkaqhOiP62d4G6OtxXwWOkACu3KjWz+jeua4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0987/1005] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Wed,  4 Nov 2026 16:12:00 -0500
Message-ID: <20261104211110.685582284@linuxfoundation.org>
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
[ sashal: Omitted the installed = true assignment for the absent rejected-binding signature-check block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1698,6 +1698,8 @@ int smb2_sess_setup(struct ksmbd_work *w
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess;
+	struct ksmbd_session *prev_sess = work->sess;
+	bool installed = false;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
@@ -1835,6 +1837,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 		conn->binding = false;
 	}
 	work->sess = sess;
+	installed = true;
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
@@ -1988,6 +1991,14 @@ out_err:
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
 


