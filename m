Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B513C3F4C;
	Thu, 30 Jul 2026 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423121; cv=none; b=pkqhoPW8ufq7NduxzNSdVFKTX6Qx57FNKG1972WXD+Nk1E1IAmrX5XkmUEGuzuIUOzPjAnaXRLgxhe9k4eVrD2lUtoSXOsE4Ue9UY1pihvrdGjBamP5b9o1U5OLR7wjXmmVMWiRhLXW1QrtFfwy/reGmkhjLAeCSV2S9ph9kyNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423121; c=relaxed/simple;
	bh=79lqkEh8O91KQM2A9eaT0UM8PG9IlQI3QYp30NBB790=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAMFimW+hoP8i8LA3aF9Pj+IbD8VpxwZJelOXvf/L5RcX5WVJ/06GUtzFHd/vBm2GYrqs9VypwJnaDhtdBWzOe+flSTZ1LZfuc82CKw7zFOJPOGSE0bfA14dWLsOtdLTKkbIS6E8bWAsyVvZmWB/zz0YyaerFd70Ywyx59jwjUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tj6V4qb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tj6V4qb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE941F000E9;
	Thu, 30 Jul 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423119;
	bh=2vzkAZ5hnlntjTqN2H6Q9vaM6KG7Qqp08GCvIfJ/Fu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tj6V4qb9+tLDIb39+QYZoIg+7s6zz6cFd2nxQ9RZPxcYhVVsyA2NilP6KkI7X22TA
	 UJroEOVNIW/0W1BKsQgA19IFPfw74EYRK7e6rTTztV44sD46MjXbfk7Hta5Mtf574Z
	 en2dvy2wefTNKd+r7iewfZzxP1NQ88RaDFt9V6Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Montgomery <james_montgomery@disroot.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 673/744] ksmbd: defer destroy_previous_session() until after NTLM authentication
Date: Thu, 30 Jul 2026 16:15:46 +0200
Message-ID: <20260730141458.567079103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1535,11 +1535,6 @@ static int ntlm_authenticate(struct ksmb
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
@@ -1579,6 +1574,10 @@ static int ntlm_authenticate(struct ksmb
 		}
 	}
 
+	prev_id = le64_to_cpu(req->PreviousSessionId);
+	if (prev_id && prev_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_id);
+
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
 	 * that it is reauthentication. And the user/password


