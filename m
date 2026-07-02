Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC42344D9F;
	Thu,  2 Jul 2026 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009815; cv=none; b=M4VtW9bPgDbv4cfX2Xf+gQVbBymNFbdP/Yt6ahEIgKaGc3BFu+lEGxR61Ze7l214WgPYYKAuXAePXVp/KnHkJ6O+iy/XGoJSPxeixai3TJZMX60Qt81x0xpiZOoOiapJr/fa9qzlNjGK0MtD2RYemlwBDcckqmYz/7dGqi6ZFH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009815; c=relaxed/simple;
	bh=OO0v9GxZPN/rj3FvCIIHmiUfHNM4ncdHaRtyqz/7aGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpAY5y0Q0+RN6n88FyU4tA92U3FbIHuNBpwJrwpKuMnxW+c/d2rw6DvE1Vcdva+cGflAEhpunSjis3iE9LAdDsNDq6B2X7NuPbPnxXb2EevARXvykk8V/YB/RAhkJajNSJFg6GdFuo+PxrwkBQ9hpZK9j7LXqYwJ/hGCu79rj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVlHcBq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVlHcBq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E401F00A3A;
	Thu,  2 Jul 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009812;
	bh=ruWZ15Uua4w09kN/5XZEqIsgW53eewcjxjxQ9HCNrsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVlHcBq3Gmi91avgWXTb2DMfZEZDJaXmkOloVWtRwoSpeEbXQgjy/LtyKpmrV+d8b
	 C9FQG4GNtTs5CIFigB2sRsefRg7kwHAHDue5CJH47m0Bs86XE3hHEXLarqR54kxt2S
	 148nGoCWHEYwqOunEWD+EOL7jrtajB65N9vVLmLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 90/95] ksmbd: reject non-VALID session in compound request branch
Date: Thu,  2 Jul 2026 18:20:33 +0200
Message-ID: <20260702155111.102668428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

[ Upstream commit 609ca17d869d04ba249e32cdcbf13c0b1c66f43c ]

smb2_check_user_session() takes a shortcut for any operation that is not
the first in a COMPOUND request: it reuses work->sess (the session bound by
the first operation) and validates only the SessionId, then returns
"valid". It never re-checks work->sess->state == SMB2_SESSION_VALID, and a
SessionId of 0xFFFFFFFFFFFFFFFF (ULLONG_MAX, the MS-SMB2 related-operation
value) skips even the id comparison. The standalone path
(ksmbd_session_lookup_all() plus the SESSION_SETUP state machine) does
enforce the VALID state; the compound branch bypasses all of it.

A SESSION_SETUP carrying only an NTLM Type-1 (NtLmNegotiate) blob publishes
a fresh SMB2_SESSION_IN_PROGRESS session whose sess->user is still NULL
(->user is assigned later, by ntlm_authenticate()). Used as operation 1 of
a COMPOUND with operation 2 = TREE_CONNECT (related, SessionId=ULLONG_MAX,
\\host\IPC$), the tree-connect then runs on that IN_PROGRESS session and
reaches ksmbd_ipc_tree_connect_request(), which dereferences
user_name(sess->user) with sess->user == NULL (transport_ipc.c:687/701/704)
-> remote NULL-pointer dereference and a kernel Oops that wedges the ksmbd
worker for all clients.

Reject any non-first compound operation that lands on a session which is
not SMB2_SESSION_VALID, mirroring the validity the standalone lookup path
enforces. SESSION_SETUP itself legitimately runs on an IN_PROGRESS session,
but it is never carried as a non-first compound operation, so multi-leg
authentication is unaffected by this check.

Fixes: 5005bcb42191 ("ksmbd: validate session id and tree id in the compound request")
Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -606,6 +606,11 @@ int smb2_check_user_session(struct ksmbd
 					sess_id, work->sess->id);
 			return -EINVAL;
 		}
+		if (work->sess->state != SMB2_SESSION_VALID) {
+			pr_err("compound request on a non-valid session (state %d)\n",
+					work->sess->state);
+			return -EINVAL;
+		}
 		return 1;
 	}
 


