Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685BF35BDDD;
	Wed,  3 Dec 2025 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781246; cv=none; b=HMTf/g3txYl95ngmZDm61wlFvS11JptLThYLL6RbO2Xt2MIUbIA6XA0Am8jGxlbwtAm07o1DiPp0W0OWsu7ixZLJwSimMHdvbirjujZyZuVPAt4sG4qe2cmV0IM6f3llrVq6XnAKVn1OHNgImK41ALdg0emdObsyOO8E5X2pB2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781246; c=relaxed/simple;
	bh=7ojcJ8v1ZHLbDYnEUKqDnAWybzDjeh1J9hww2SbRyYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQgwLrFlkcwjnBzE6A7QnE+ZGEC8sKEPizCrMBOFUl5njBKP7Vdno/dFfMSLofFWaTD8zbnnjcKFw5WzAEyclcAvWKTcXRg0uEL+jPqtGmZAu9x4EI8hsyWa76fNNZ9nNJjOsLaN7HxmZh7vmjbsyhxX8KfO3I3z087AQeNc1cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KOpjnCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KOpjnCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C3FC4CEF5;
	Wed,  3 Dec 2025 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781246;
	bh=7ojcJ8v1ZHLbDYnEUKqDnAWybzDjeh1J9hww2SbRyYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KOpjnCa9F74XgqpjN/7IwqMOfx51mki/2ndFCQkzYdGwQK6WuQZ3oBTcYSE8NT7n
	 KSLybXpzAUh2iQgHJSLVljFeGgGM0NhtrsgKzKclR/Lw26KUNlbez9AOdKBeHSciBp
	 DtjA8FVsRiiKnhf/5xAOv6f4hYoq9M2xGkJLZjo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Nazar Kalashnikov <sivartiwe@gmail.com>
Subject: [PATCH 6.6 90/93] ksmbd: fix use-after-free in session logoff
Date: Wed,  3 Dec 2025 16:30:23 +0100
Message-ID: <20251203152339.887030489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Heelan <seanheelan@gmail.com>

commit 2fc9feff45d92a92cd5f96487655d5be23fb7e2b upstream.

The sess->user object can currently be in use by another thread, for
example if another connection has sent a session setup request to
bind to the session being free'd. The handler for that connection could
be in the smb2_sess_setup function which makes use of sess->user.

Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Fix duplicate From: header
Backport fix for CVE-2025-37899
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2255,10 +2255,6 @@ int smb2_session_logoff(struct ksmbd_wor
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);


