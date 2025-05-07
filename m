Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F30B2116E9;
	Wed,  7 May 2025 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643864; cv=none; b=omXWZl2tphrqS4UV+nmNSdhskBJUdGZeGCq5FmmsXpJ53Y+FkWWSvDtrBJy0ES7ZXA+Aa5Dy6Twx4UUV+va9XmET1is/3fuz7HTfw6jssEGW+r+Z3AWxhyQejDXQotPTs8GkqUnFczGlh0jVTVVCqj3Cos7gbI7qRaTAepFIjzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643864; c=relaxed/simple;
	bh=W0IHb2pVsmR+8KJ4lxawV4uAF0ACFU3QUGL6fP/J/Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpXG4Cs4/MBCk03MxgmhEJdh89aYn/nwPSeRYftkdQ4Qg3iPGlBqGL6FebKpfenrKVznDXNYtBDNjVtAE9NexzapRRRvjWxu5muEzojckr3c83nNtfoGJj7SGk93LGszZC9Be2fvy/SDsSCMST6/UmxPc889Luv4LMD5/eMvs84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDJc+907; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDJc+907"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC36C4CEE2;
	Wed,  7 May 2025 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643864;
	bh=W0IHb2pVsmR+8KJ4lxawV4uAF0ACFU3QUGL6fP/J/Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDJc+907I5s8Wvk4iVGfNJWphhg2+EYnJoZZ6D1YipmuwCgU5rZ4zUXZi670oNQow
	 AYjMl2UnrDVk0dYodsJ8itMNZgO6gV35dHQMpvXZUdHcs5Pn3lhzaZavUzz5Ym/YC/
	 u1HupmiWLIkMxPTMCJxEdsQB+UTQsCcP3bpqSriY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 042/183] ksmbd: fix use-after-free in session logoff
Date: Wed,  7 May 2025 20:38:07 +0200
Message-ID: <20250507183826.397509217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

commit 2fc9feff45d92a92cd5f96487655d5be23fb7e2b upstream.

The sess->user object can currently be in use by another thread, for
example if another connection has sent a session setup request to
bind to the session being free'd. The handler for that connection could
be in the smb2_sess_setup function which makes use of sess->user.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2244,10 +2244,6 @@ int smb2_session_logoff(struct ksmbd_wor
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);


