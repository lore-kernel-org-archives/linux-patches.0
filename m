Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C55443A9D;
	Thu, 30 Jul 2026 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424937; cv=none; b=hZXBwDZUZhb5yby0wEOP+SiHcuxpUpBbKT8sxnIBhpyIrLEBr4jTtl5IRXb48lyRaXdV0IXFA/q172V9YeCiPf/XkWkkNhfZgSk2+ut5qXynAoaRB25mZDZhuWOT0rK4+KuzXQBbNLuqHNKsorXOHDiFlAZDy6GJbGbBmFvAfNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424937; c=relaxed/simple;
	bh=ZA+5gtgNMxTCGjDKE4Yl0EfzwQywStyHzS7ZjvwbwTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieIyGanKuE6CUD2hi19okP2gRREbqB7wSsakMXgfglIIWDG0XI5nknQaJGDK5ldik6aFSUurg9jpSYbq2xuKULsJlFnZZBhvMv03x3Ls0QHza3UN7uVFGj15qYlLDz3JVW3owoANqR5kh1LP9EhVtFQZo0XsjytVlan+ZVlt1Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZI1AHAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZI1AHAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24611F000E9;
	Thu, 30 Jul 2026 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424934;
	bh=MyiOYUXrdrzTBDrxnlp6pg6883LRL2u4FgjXTcRjBx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZI1AHAA9neBFn1PfyK24Qf7ja5wG5Ds6tHBRYfxD2Kni62vH2tr05Hxblel/Qygp
	 toHkiTCWkfxp1n+fyaAiDACn/48tCvDlT1C50JaxOQo1HG4EmzdTciPR95wv5CEfT+
	 SOLL9T60cf0keAd2AeS+Py7If6X66CGuu0vOw/rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Montgomery <james_montgomery@disroot.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 551/675] ksmbd: defer destroy_previous_session() until after NTLM authentication
Date: Thu, 30 Jul 2026 16:14:41 +0200
Message-ID: <20260730141456.850669252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1492,11 +1492,6 @@ static int ntlm_authenticate(struct ksmb
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
@@ -1534,6 +1529,10 @@ static int ntlm_authenticate(struct ksmb
 		}
 	}
 
+	prev_id = le64_to_cpu(req->PreviousSessionId);
+	if (prev_id && prev_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_id);
+
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
 	 * that it is reauthentication. And the user/password


