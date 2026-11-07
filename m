Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061834;
	b=cs3K9HmwioCxVleT6GUzxv22BpuMzO4qlsTa9k0ocV3om1oB7wn6010QTRDKbTPSETAe
	 pY5KCLmWxDAtpHREi9i9hjMHcLdW0eao7sZdJuwpPwNSWA1uMGkMmCq57lOK3ry2caanA
	 u/BpQfwLs9LfMleGluHHFGJmbSV+IbFUhJ5QR6/zsYV2ZogVvw4Z5RJS2eluwZm+qrgCy
	 /N65oqmZZArJI5586bczbSi8QXjp3iKbdlwvWAjjnzFD/wK8b4qMqt7pniKnEqycBTwSn
	 gztNJL3Ve9XXRkih64FyZYFvotmEwRZMeDgxk8twoUruPbTCMkcMwZGMVeEi1d5SU5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=osCJSW680TgngsfLj/e7xN3PQ87p9ln2386Oc1Hpcug=;
	b=J5c1B/TL0xcEgmkPqIXGEA/nFwVZyggQfEif3JJvdsj08/n60XYTE6En8sM0w56FSyvD
	 zg+Ef+x8OFvSTXkTrk2L3JsC4b/wqTNtafusVrSro+FKHWLptCBST6xfDYI5atDko+RQn
	 Z8eS0XWx2dKNOaz24QgMrZnQ8T0mO8at15c66d0AiAjSjjRIx02AIXLumsmXFoIOo5CNr
	 OAPx+hY0Jl8kWfPDO+OYoTdtyW5e4lzefRiODUx/xczZjkNaAof9RA20JEdQIoqk1MfvO
	 Y5HxKlTUgza/ixw4vGzf/qwBcOgXFVtzHg8ZPwonbgAJPTKPSH5SeyPRcx9T31YnmAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASYjZ3Rx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70B606A326;
	Sat,  7 Nov 2026 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASYjZ3Rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057BA1F0089F;
	Sat,  7 Nov 2026 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061834;
	bh=osCJSW680TgngsfLj/e7xN3PQ87p9ln2386Oc1Hpcug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASYjZ3RxE5YScVeRvElKqx0xoF+ise3InZNvmrdEfjpWlR6XxTKCflWh82oaQ0vV+
	 gluTJnfmMxN3oPqM1fqpYbTsMlASVqeGKH9V3bucLHqWldrIBOjlYbvKDC57dyT06B
	 kOwEX0IubUIo+AXqxFa863Isch/HCEbwCKRUZEyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0854/1536] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Sat,  7 Nov 2026 08:47:50 -0500
Message-ID: <20261107135021.534423765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the installed flag update for the absent early work->sess assignment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b5a71ca407b65..2219bb6b73b29 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1714,6 +1714,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess;
+	struct ksmbd_session *prev_sess = work->sess;
+	bool installed = false;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
@@ -1851,6 +1853,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		conn->binding = false;
 	}
 	work->sess = sess;
+	installed = true;
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
@@ -2004,6 +2007,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
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



