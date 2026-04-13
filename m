Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6343148A3;
	Mon, 13 Apr 2026 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098551; cv=none; b=IZQxgbmwlvjdO4YoSEGQMKT6TbsYWYSRV91CsGuK7EnOwT063QGRSMav3o646kxoNsYD+oX3yb6xGUaFYW2hNIzGXSpPYmkyjQP1ot8krAIHWCK/1f73k/8Jo+2FUqCBoJ5LJnxmz+oYwOHJfUfQVWkXLDtzEXikOgEbdRzG4Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098551; c=relaxed/simple;
	bh=1wFqu9JT2joKHekLk5Y8JoDtaCNMIGn2DB8giCMXE5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMkDU1652cFPz/G1J7Dd0RPJpuDffmDPvjA/7X5SVysS0my3kGzqHVMcACZ2lmBvcQ80TdDHJ0sUIS6YGKDHgXvajJcc9lnrkw3j6bi+kUR7ocGOGC9r2h9KDUfR9Uoi9nI8IPA7GaCRm3W7MsUD2s1IEIfiyvaLIQawIpcBUjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmEWA6Hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmEWA6Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC276C2BCB0;
	Mon, 13 Apr 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098551;
	bh=1wFqu9JT2joKHekLk5Y8JoDtaCNMIGn2DB8giCMXE5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmEWA6HxyVzc+Ski51q4RcAanp4pvSj2Sjq416D8UZEm9GzHoe3paUxCj9CzucJen
	 rqgY4VB6LJMgbNLKc04/6k5SKy/lznHWnj8kcz1Vg5aHfGhGtjtqnEpDxWsDaT94DM
	 WQ6+Y8vdHldRSLYzTmQn72Wbqmy9XNAc4Ff+fqkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Leon Chen <leonchen.oss@139.com>
Subject: [PATCH 5.15 568/570] ksmbd: Fix dangling pointer in krb_authenticate
Date: Mon, 13 Apr 2026 18:01:39 +0200
Message-ID: <20260413155851.755021446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Heelan <seanheelan@gmail.com>

[ Upstream commit 1e440d5b25b7efccb3defe542a73c51005799a5f ]

krb_authenticate frees sess->user and does not set the pointer
to NULL. It calls ksmbd_krb5_authenticate to reinitialise
sess->user but that function may return without doing so. If
that happens then smb2_sess_setup, which calls krb_authenticate,
will be accessing free'd memory when it later uses sess->user.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1619,8 +1619,10 @@ static int krb5_authenticate(struct ksmb
 	if (prev_sess_id && prev_sess_id != sess->id)
 		destroy_previous_session(conn, sess->user, prev_sess_id);
 
-	if (sess->state == SMB2_SESSION_VALID)
+	if (sess->state == SMB2_SESSION_VALID) {
 		ksmbd_free_user(sess->user);
+		sess->user = NULL;
+	}
 
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
 					 out_blob, &out_len);


