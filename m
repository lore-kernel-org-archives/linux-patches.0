Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77BF28C5AB;
	Wed, 23 Apr 2025 15:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421004; cv=none; b=VvyXUKT1He4TbV/lW9r9pSspH931h/HjlRsdIhi5Tmbehb8w1NCdi+zbinwN6n1/VsQ/u5I0O204dw/VfDSOeBPX3/izHy+chP9RB+vW5NU+1CLVqdA3fZsUIYbQa0e/2z3Z5FSTijDJHuUdp48s/1nYgJrOlTdKKveyKa6m8mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421004; c=relaxed/simple;
	bh=mU4fDwBCYIxyUzqnU5mVEz+RBqOFbko7fJ58i4wjfbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGoUU85cExYpjFIjQspRryK0Z04h2Ks/x3gTe9Az0+7dc+GJdsiwhdw1a3MtNNXBrWWq1pcgKyALAEvzCIHlY+0r9EMjgzWD3HzBBJSc2NIqs6jHNy5w29I/UajwqQCZLoZ+2P/QbmZuuy4LM9yyl46RReC/aIgdypra0+oEXDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcCWRRUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcCWRRUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C2EC4CEE2;
	Wed, 23 Apr 2025 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421004;
	bh=mU4fDwBCYIxyUzqnU5mVEz+RBqOFbko7fJ58i4wjfbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcCWRRUB5A/OIWF0sWNKyFk3NWf8/jh+3qr81tlCN/60yCtn3vpjS9uMz/GYGESVM
	 s7pFK5JDctrIT8QJlkMUl8KwGv5EyyMwTRW2gxpt1OWdCkKcTd4v3QQzvPNsG8SWrV
	 qF1e/BuQAeMhs56cstO6EFCEVItaXgpA1W3iwL/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 143/241] ksmbd: Fix dangling pointer in krb_authenticate
Date: Wed, 23 Apr 2025 16:43:27 +0200
Message-ID: <20250423142626.399808290@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1602,8 +1602,10 @@ static int krb5_authenticate(struct ksmb
 	if (prev_sess_id && prev_sess_id != sess->id)
 		destroy_previous_session(conn, sess->user, prev_sess_id);
 
-	if (sess->state == SMB2_SESSION_VALID)
+	if (sess->state == SMB2_SESSION_VALID) {
 		ksmbd_free_user(sess->user);
+		sess->user = NULL;
+	}
 
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
 					 out_blob, &out_len);


