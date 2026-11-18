Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052008;
	b=T6ZsttV+Holix+KSy1qU0ELwlGFxqTwqYZJhKataD5RPfe1j9JTFwR+W90zMRIGoBfsZ
	 h2q1kUQXVUqpGmIZz5BAnNnxPlB/4Uecw9RJxrDPEt4RxxbMOALv8s4Rkd+QJq2GzT6vm
	 iSjEJl8Gd8rvaAnchiu+gEjzuFIcf10KcZyAWPQILPA+r0hzTj+qdfCE/5XyOuXRsLVUH
	 lM72as+T57lTlDjmGrroMYRrSvwg+bF16H9hy3qLjbGIOtnIdxIHQc25eLkWmbVg6NTt4
	 ZhVOVyn3ZDaQrmZ6e3oqKzcyf8S3rh3k+2BUL38aeXuYcZ25Pr/8SHxNzvJRL08lS4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUVA/xgdr2RQsU4MvQshWn/n3GEZ7F+Kf8vL4Sx5Mzg=;
	b=M8j3lxjZew2aStCwRl+7ixecA3I51iQTZbu52W495itKDvv3ccpInbEp+koH6u2KQbND
	 rrrhlX0VzgUcFNaoe/3cvJ9/106fkD0Md5/Svf2ajoXhLvV8gc8JjnkY9aHoApRLDvjVt
	 /Je01y6B7XIWAyy7pRAZlvcfQPjONLMq29r6GOa5A62A7t6BYUvpZb/6we0ZQ0BvOxb9m
	 C4gnLSW4nUHUC+/zzE7bD7MvA/Msm3avGZzPjLSRQvkvARbJYV4SOctis68nOue4WsVOI
	 1JKHi74w73D/R+S7FFceev6ibG9tieVIeQTRaac5jx876vkxuRcUFP8UJj/LqFqKvbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHKKMNzx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1F606A31C;
	Thu, 19 Nov 2026 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHKKMNzx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A021F000C4;
	Thu, 19 Nov 2026 01:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052008;
	bh=SUVA/xgdr2RQsU4MvQshWn/n3GEZ7F+Kf8vL4Sx5Mzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHKKMNzxkSpH3bIFdVfVSl9GaJGABFq3ePq8Jy6vMPpMDlNJBywcCru4n18nSlVII
	 rUIBTv4qAbLWZopgPJUArRaSN1bguR+QLsRaLjMqyj+IybuHq9FXWjvpxpRSQDnZT3
	 ArQGd6jD8hycIDSP2zoG/kJ/4A8fFOcFTmRbcayw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0409/2214] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Wed, 18 Nov 2026 15:34:45 +0100
Message-ID: <20261118150027.127768726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the installed flag assignment from the binding-error branch because it does not replace work->sess ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ed2b655978d24..98acd2086093a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1710,6 +1710,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
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
@@ -1983,6 +1986,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
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



