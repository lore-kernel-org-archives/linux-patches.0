Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B52853FF;
	Wed, 23 Apr 2025 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420411; cv=none; b=HG6HHljdkezylL0fdJqZHCrqh7hwHIFGl5Bqcacsa90xunnR9r2x424VVV9oYvqGp4XKA5RI902Av24a8YXrgH42JPED//mcgmho8fHzUyjqXcjqJHiOUWecgb+TzNQYuo229xdljblAgTJvt5Xppb0iKul9/PR5VdBLSBwp01I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420411; c=relaxed/simple;
	bh=9ChyvPN8c1vIKpvUnBh13sVga4V3Q3JSE0+k/EVPI8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld5xDXoQI4ZdvhfTuTPPs6jHnACHhoaaocWB+SUwSl0Yu2EtoaQFi6tfSwAasL4aqyegU4qZ7S6kwu2MjmfItelp1qXrgTDRrZKg/Bf4lseEWzYSvjimkNYsgzNVwlvRG3w5jGhl+MUKGMj2OdPhEPAQWz2pNJzOcLz6lLn2GGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mN7HFEcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mN7HFEcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF23DC4CEE3;
	Wed, 23 Apr 2025 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420411;
	bh=9ChyvPN8c1vIKpvUnBh13sVga4V3Q3JSE0+k/EVPI8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mN7HFEcm3OMmKQ/5XHQ1nn4Yo4ZXQREIElwaaT5FX5mkWPzetWPH5/RwAVjfu178U
	 wsC/x5KLLBeB+9cG4zgvMj/KMSd+YtUnl+g9+xftHO3LauUa27DezUXFQ0SU0ppMKc
	 cfS9mtCODP6Q53LYHfZ4C1mWVlwC3QRvfWmVydt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 122/223] ksmbd: Fix dangling pointer in krb_authenticate
Date: Wed, 23 Apr 2025 16:43:14 +0200
Message-ID: <20250423142622.076303781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1599,8 +1599,10 @@ static int krb5_authenticate(struct ksmb
 	if (prev_sess_id && prev_sess_id != sess->id)
 		destroy_previous_session(conn, sess->user, prev_sess_id);
 
-	if (sess->state == SMB2_SESSION_VALID)
+	if (sess->state == SMB2_SESSION_VALID) {
 		ksmbd_free_user(sess->user);
+		sess->user = NULL;
+	}
 
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
 					 out_blob, &out_len);


