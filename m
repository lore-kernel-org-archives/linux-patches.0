Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30F395266;
	Thu, 30 Jul 2026 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428009; cv=none; b=KINkCPFWYxQrE/6IeifQLOnKPXfV6jqudvQSorQ2jq4vMJa4NwMy5Q0oiPeS4Giqi5UZNIvJ3NpFdjjEYrpQjNeRF7OIV2x29/4ql3/TsaCZBnNlV2NEXNOeyPt4leuPGWiJoVrP6v5GGcMyRFNF54+aB/r4/o8SDoFS0J90p7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428009; c=relaxed/simple;
	bh=tGogQW9TZYifwBLOInxtRao4Q90Gtf5lOhWDCQS3qlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC7onxZbx7mtGlE46ySY7Vo/6W0MlOyhXlh75cPs9KHvj/IBbhew1+Ew9VBTxcrgkqv1h3tjdQ+LZnzyf8mnrTlLaABM0qdi0APryVN0PaQ2gEjdjiZkIBSQ4gArnTYf/h/seaK/PlMAsXgpkJeSbt+FcK9wXV2huzCOkxhoBl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlFkoelu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlFkoelu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0BF1F00A3A;
	Thu, 30 Jul 2026 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428007;
	bh=JG6jHOq332LxFMxyllhf9/hrk/F+RaP4vhex4ReBPu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlFkoeluELO/5ljnU+/7pnOxR3k8hv/rwFR38UNI6OTVceZ6YmpvUHPAkgD0J3cq0
	 mNkZsY5UvqaV/1+Kl4etlBAz3KzZtEtw32+YZICuTOKkpCo5ZQVsgL/yqQUqJPfDMt
	 VK4+bUfdttkq4tRJxAoWt7zPl1mkd9HXQwwKtYq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Montgomery <james_montgomery@disroot.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 327/484] ksmbd: defer destroy_previous_session() until after NTLM authentication
Date: Thu, 30 Jul 2026 16:13:44 +0200
Message-ID: <20260730141430.590658376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: James Montgomery <james_montgomery@disroot.org>

commit c74801ee524f477c174a1899782b6c3b6918d407 upstream.

In ntlm_authenticate(), destroy_previous_session() is called using a
user pointer resolved from the client-supplied NTLM blob username field
before the NTLMv2 response is validated. An authenticated attacker can
set the NTLM blob username to match a victim account and set
PreviousSessionId to the victim's session ID; destroy_previous_session()
destroys the victim's session while ksmbd_decode_ntlmssp_auth_blob()
subsequently rejects the request with -EPERM.

Move destroy_previous_session() and the prev_id assignment to after
ksmbd_decode_ntlmssp_auth_blob() returns success and use sess->user
rather than the pre-authentication lookup result. This matches the
ordering already used by krb5_authenticate(), where
destroy_previous_session() is called only after
ksmbd_krb5_authenticate() returns success.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-cifs/20260702155449.3639773-1-james_montgomery@disroot.org/
Signed-off-by: James Montgomery <james_montgomery@disroot.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1483,11 +1483,6 @@ static int ntlm_authenticate(struct ksmb
 		return -EPERM;
 	}
 
-	/* Check for previous session */
-	prev_id = le64_to_cpu(req->PreviousSessionId);
-	if (prev_id && prev_id != sess->id)
-		destroy_previous_session(conn, user, prev_id);
-
 	if (sess->state == SMB2_SESSION_VALID) {
 		/*
 		 * Reuse session if anonymous try to connect
@@ -1525,6 +1520,10 @@ static int ntlm_authenticate(struct ksmb
 		}
 	}
 
+	prev_id = le64_to_cpu(req->PreviousSessionId);
+	if (prev_id && prev_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_id);
+
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
 	 * that it is reauthentication. And the user/password


