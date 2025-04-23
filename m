Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E5229C346;
	Wed, 23 Apr 2025 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422002; cv=none; b=IvH3yf4sXcSN3iposAXRGkU7iws/nA+1ZKPq/AeVFRplHcTsP8tgi3PS0XZt8JAinCUzzifwx5BK9TeUXIAJWM2WHyEibcBsl4igE61k0bxmXDptzYYWU67Ww0AmUx7r3RGCXUhxnZphwQ76KYzhoP7J0e9IQQYrlA9ddbGxgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422002; c=relaxed/simple;
	bh=Jms9kSzbSX23joVlMl7toMxBSJnNRoivJCYHmjBoUQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQ+mgXwhtP2NUqkuvKUGCV5Cuvhui3VHsa+K0Ve/QLNbt2omLYm0WWitow213Xzb54SSBYbg03TNqfXlN75WWhY2cfnH2z+Dw0F4MiCUSy0lMRwRnnIM4G9TYZLRM7LHqpLPP1vFmOrkM0suZQYCXSrD4sOpw/TthwESQBjjfFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFfkzuBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFfkzuBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28831C4CEE3;
	Wed, 23 Apr 2025 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422002;
	bh=Jms9kSzbSX23joVlMl7toMxBSJnNRoivJCYHmjBoUQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFfkzuBjq3h/7TC8d6wwlBYXzeO7rP6q/7gX4uU5R2j4qrqyfcsyBIirWdmfq/EEV
	 pbBcaDKSD+2MvZBkeOxM94XW8DK1t010ASOEnh/7flOEcXBmxFANfmwFv5qEkvh1Vx
	 Z9oQs1bwdWh46+7b01w6R5QJEqbDER2Qt+/5NlsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 216/291] ksmbd: Fix dangling pointer in krb_authenticate
Date: Wed, 23 Apr 2025 16:43:25 +0200
Message-ID: <20250423142633.219607233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Heelan <seanheelan@gmail.com>

commit 1e440d5b25b7efccb3defe542a73c51005799a5f upstream.

krb_authenticate frees sess->user and does not set the pointer
to NULL. It calls ksmbd_krb5_authenticate to reinitialise
sess->user but that function may return without doing so. If
that happens then smb2_sess_setup, which calls krb_authenticate,
will be accessing free'd memory when it later uses sess->user.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1615,8 +1615,10 @@ static int krb5_authenticate(struct ksmb
 	if (prev_sess_id && prev_sess_id != sess->id)
 		destroy_previous_session(conn, sess->user, prev_sess_id);
 
-	if (sess->state == SMB2_SESSION_VALID)
+	if (sess->state == SMB2_SESSION_VALID) {
 		ksmbd_free_user(sess->user);
+		sess->user = NULL;
+	}
 
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
 					 out_blob, &out_len);


