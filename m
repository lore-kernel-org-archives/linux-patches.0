Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776A2F6573;
	Tue, 12 Aug 2025 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025155; cv=none; b=T5Fs6qzvSRp0PeKBPwFHQpCFfBmVHTTiKaYbQDpUiaCxVDK+mOCNx/gIdpbmBGQZUviEJq2TwHku+UUi4kfxE5WzrMCsjcQUVN34qAclWDoN7pfdF9Srf/qFAIvUTxyjQuNto526CDjlfDgpzHDvPtNGOFo+YekXDHGoaiHGMPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025155; c=relaxed/simple;
	bh=h5J/NGhewVikdEfV+ofKgjUy4xDdiJTP3THT2V9qXpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGslTwqMqNUTgScar0rLPgTM8Q4X8s5H9TXKjJaXjwJUTZXJuPAo6M4aR9mCX0puNrzMM/q4KF0AqjPQR0Qx0CF5ght9ADpvn5SkKzdm7V/qjLKEmwCQkBchHa3rttQLi6eCI9nYJt35elDL4CbINtAbJD3HdHDI69wNsKe5fiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DF64Yh9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DF64Yh9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44593C4CEF0;
	Tue, 12 Aug 2025 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025155;
	bh=h5J/NGhewVikdEfV+ofKgjUy4xDdiJTP3THT2V9qXpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DF64Yh9IDgV16tPTwnYGZLEyOgw5JwUGwNHVrSQOEXCSyZduQY06ybL9k3XJ4LIPx
	 4oA67uzSo6+J9MQEBSX6HvN8RVWy0D0xiXLH4w2LlyxSxkLqGufxJom60dInnrFxWg
	 FALccInoVn48fMTCz8SPj+YOXxz50SCsMjQ97r0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.16 585/627] ksmbd: fix Preauh_HashValue race condition
Date: Tue, 12 Aug 2025 19:34:40 +0200
Message-ID: <20250812173454.124015220@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 44a3059c4c8cc635a1fb2afd692d0730ca1ba4b6 upstream.

If client send multiple session setup requests to ksmbd,
Preauh_HashValue race condition could happen.
There is no need to free sess->Preauh_HashValue at session setup phase.
It can be freed together with session at connection termination phase.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27661
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1847,8 +1847,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 				ksmbd_conn_set_good(conn);
 				sess->state = SMB2_SESSION_VALID;
 			}
-			kfree(sess->Preauth_HashValue);
-			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
 				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
@@ -1875,8 +1873,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 						kfree(preauth_sess);
 					}
 				}
-				kfree(sess->Preauth_HashValue);
-				sess->Preauth_HashValue = NULL;
 			} else {
 				pr_info_ratelimited("Unknown NTLMSSP message type : 0x%x\n",
 						le32_to_cpu(negblob->MessageType));


