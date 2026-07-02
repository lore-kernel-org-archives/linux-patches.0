Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4BC33689F;
	Thu,  2 Jul 2026 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010880; cv=none; b=FM3VJRtyAr07I42DBIlVfbLh2K0MBJnZxygl75Wye0lNdGFfTObY4EK/gqX75jGVMhpgJ/sdwvTuLxwG01r+DV5J0Eip0lXXbQe84rxTnu0Sr9viJnqWZpObjq5ZRzOGTq4XGB5Dmx2hRJ8tLo1R5gTQF/K8MPVdLwAX8i00x30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010880; c=relaxed/simple;
	bh=9pHRMdXnVh/EziBr+yl0epYdvjl6rMwtfvxnRaFkffk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3LmSQt8YCx6ovQq5q2wF10oPwAxPBFx0h2jZBChb0vidsJ8kUmGyMNLPsKkuDuRridLq1IxEl6Xu/Ggq0TSnu8tqSQD7LxHWqe5YPHNuRSVAWVWsxFFviiJuBrBqNI8ddHR+z3mq4/+gk9sDBQtS8KQqXRp589jinBcVH4fD2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCjEzq1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCjEzq1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBB51F000E9;
	Thu,  2 Jul 2026 16:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010878;
	bh=VEbWg2xOe9r5yEiBdEk0n45vx6k1IaQ66ZqOmx32PLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCjEzq1m4vGTeG9+/rowVyxIjnw9aBp+Mn421UtH86punicmXFXiuR/Wg/ewkx7hf
	 i2GsUHZgC8oHBEYf7IPajd+SiapYdMYMOm2WgGtj0vV5EUJlHgpiJKvQAzBxdn3Eok
	 65PG2P8pS5GXYmGVlVUPYH8ghKQ7CuWmVxSlYMJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 072/175] ksmbd: reject non-VALID session in compound request branch
Date: Thu,  2 Jul 2026 18:19:33 +0200
Message-ID: <20260702155117.308708921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

commit 609ca17d869d04ba249e32cdcbf13c0b1c66f43c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
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
 


