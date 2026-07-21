Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9EB363081;
	Tue, 21 Jul 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655030; cv=none; b=oNBFCLHeSfJjCZfjkyMwcjcNwkySgzCZ3ge1sbRdoIYAN/kejFoeVvNtEBpc74OPXBgXzaeWJOhRxWmbMyejJ5VqdineuB+2RNAw+FA/LehiQVxHj2+rvnmwjPKkDw5YA8yB84p3jwXKGXOc5Ax2e6oeOctzvGZyeYNblKe1r04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655030; c=relaxed/simple;
	bh=+ywA3c1a7pQr4MDfCUXTOd6KbM6uSr6TJUTyhHQxVqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsDxEySiQ/jcPCXtacWv2svZ+4Eleq1S52TZv73uj8UXaQJK53IQ+3JFKM4M6hQGJaECyJKJJFmtmK+HudHBKvtT5X9JYybCSdcv5AeSMhQLzRHCY0XCIqMbfBjw56VCYz9i0xzJ8xFSNCLHeEH04QFyLvxwrjqb6C2+Qm8wRas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEttFA74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEttFA74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CF51F00A3A;
	Tue, 21 Jul 2026 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655029;
	bh=2+FBbFI/19+tBYX5y7a9Oo6oEBoMZGCpVmnGvy0Vj9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEttFA74G+ik6m2DEU7mW4zgOSCpuIjEZ60c2IT3swWfCJfpJAOSGFD+f98HkqRMq
	 9IznG54UqwxvCmddIELsuoL5QwiOsWScA1mPnfIWTzkfvmIk2WVIdldr0VyVuAV0Hh
	 EquxwcVH83p2JH7hTwccTlcVnEhNwR6ssYgT/uks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 1928/2077] ksmbd: fix stack buffer overflow in multichannel session-key copy
Date: Tue, 21 Jul 2026 17:26:41 +0200
Message-ID: <20260721152638.184919663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Portnoy <dddhkts1@gmail.com>

commit 610346149d047a52a92c9a0eb329dd565b8f92c5 upstream.

Commit 4b706360ffb7 ("ksmbd: fix multichannel binding and enforce channel
limit") moved the binding-path session key out of the session-wide
sess->sess_key (CIFS_KEY_SIZE = 40) into a new per-channel buffer, and
sized both that buffer and the on-stack copy used during binding with
SMB2_NTLMV2_SESSKEY_SIZE (16):

	struct channel {
		char	sess_key[SMB2_NTLMV2_SESSKEY_SIZE];	/* 16 */
		...
	};

	ntlm_authenticate() / krb5_authenticate():
		char channel_key[SMB2_NTLMV2_SESSKEY_SIZE] = {};	/* 16 */
		char *auth_key = conn->binding ? channel_key : sess->sess_key;

The two writers that fill this destination still bound the copy length
against CIFS_KEY_SIZE (40), not against the 16-byte buffer:

	ksmbd_decode_ntlmssp_auth_blob() (NTLM key exchange):
		if (sess_key_len > CIFS_KEY_SIZE)	/* 40 */
			return -EINVAL;
		arc4_crypt(ctx_arc4, sess_key,
			   (char *)authblob + sess_key_off, sess_key_len);

	ksmbd_krb5_authenticate():
		if (resp->session_key_len > sizeof(sess->sess_key))	/* 40 */
			...
		memcpy(sess_key, resp->payload, resp->session_key_len);

On a binding SESSION_SETUP, auth_key points at the 16-byte channel_key,
so a client that supplies an NTLM EncryptedRandomSessionKey of up to 40
bytes (with NTLMSSP_NEGOTIATE_KEY_EXCH), or a Kerberos ticket whose
session key is longer than 16 bytes (a normal AES256 key is 32), writes
past the 16-byte stack buffer -- up to a 24-byte kernel stack overflow.
KASAN reports it as a stack-out-of-bounds write in arc4_crypt() called
from ksmbd_decode_ntlmssp_auth_blob().

The destinations must be able to hold the full session key the length
checks already permit. Size the per-channel key buffer and the two
on-stack channel_key buffers with CIFS_KEY_SIZE, matching sess->sess_key.

Fixes: 4b706360ffb7 ("ksmbd: fix multichannel binding and enforce channel limit")
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.h |    2 +-
 fs/smb/server/smb2pdu.c           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -19,7 +19,7 @@
 struct ksmbd_file_table;
 
 struct channel {
-	char			sess_key[SMB2_NTLMV2_SESSKEY_SIZE];
+	char			sess_key[CIFS_KEY_SIZE];
 	__u8			smb3signingkey[SMB3_SIGN_KEY_SIZE];
 	struct ksmbd_conn	*conn;
 };
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1507,7 +1507,7 @@ static int ntlm_authenticate(struct ksmb
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_user *user;
-	char channel_key[SMB2_NTLMV2_SESSKEY_SIZE] = {};
+	char channel_key[CIFS_KEY_SIZE] = {};
 	char *auth_key = conn->binding ? channel_key : sess->sess_key;
 	u64 prev_id;
 	bool binding = conn->binding;
@@ -1644,7 +1644,7 @@ static int krb5_authenticate(struct ksmb
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	char *in_blob, *out_blob;
-	char channel_key[SMB2_NTLMV2_SESSKEY_SIZE] = {};
+	char channel_key[CIFS_KEY_SIZE] = {};
 	char *auth_key = conn->binding ? channel_key : sess->sess_key;
 	u64 prev_sess_id;
 	bool binding = conn->binding;


