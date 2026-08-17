Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606582E762C;
	Mon, 17 Aug 2026 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979572; cv=none; b=FtTU5H6r48+fFTN3MD8OOzkuTbG1QIvEvuKiqP5R7EOer7guchdnCLNc5/5LGWOYVcY8MFjx//YISMEGJGP2e/Mmjbr4t+p2zFfHbGtOwJDH2Bq1BdpeUjnyDd0uz1NZ7uaWeaxiaK8rxABAg65EMl5ZRiz0fayQpHQIlxebdhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979572; c=relaxed/simple;
	bh=N5K4sqSjjiHb4Gm+162Xr1MTlOqWeoefwc6qXl8OEwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4fNiBg6Sq8NASdPA9ovqGvP7v60P7lOrOtUIgiJuwkj62FacqKCJ6Ir+0u9+VKff2GbcRGSRggS/oHyTLSTLX12272d1SBQAq/tpKbvl7Hs/NR/g1X0cPto+joy6HneMV+uykgvTwFDUENplGO5PP0IYJ3h/RkXEsZg7p4AAOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVllhP+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVllhP+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76451F000E9;
	Mon, 17 Aug 2026 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979571;
	bh=OfD5x5jV3QB0JqMjtRScn5snKwP8seUZUA2ycB0fZ9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVllhP+/yO0shjZQ9wywNzrE/ipeLhivGx6V5NZXzy3J198GQr7oGSDYvBkFidIV0
	 DIiIXSJ7wdvbR2jE1f27bF9id5FDRqtBluGzH4ZYr/dyufH9NR47KsLScX798JN2pX
	 Xk4aBsYIej9H+xt7QQZP7A3Jr0YBkbUV8ZRTTel4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Montgomery <james_montgomery@disroot.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 271/609] ksmbd: defer destroy_previous_session() until after NTLM authentication
Date: Mon, 17 Aug 2026 15:29:27 +0200
Message-ID: <20260817132553.195141480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1491,11 +1491,6 @@ static int ntlm_authenticate(struct ksmb
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
@@ -1533,6 +1528,10 @@ static int ntlm_authenticate(struct ksmb
 		}
 	}
 
+	prev_id = le64_to_cpu(req->PreviousSessionId);
+	if (prev_id && prev_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_id);
+
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
 	 * that it is reauthentication. And the user/password


