Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A6A377A82;
	Thu, 20 Aug 2026 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243782; cv=none; b=qq73TXsA1F1JXPMZ2YbGbpT2C7aSTQfj6mFASNKNyBb0WLzW4btNpZVSW5ok+69YXGHNI54WPLT0740LsMQBAh6+CZusppRKXpx8Gj+grX33VjG7IeWpw+VrtqTg6HB+kSpl1/gY0Zbdk8NrIb79zT3yoYL9rKcjETAi1LQ/V5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243782; c=relaxed/simple;
	bh=t9gomQYL3zeOEVoKR1FCYCfggDstPwT65IZDFkxeHZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOtxuFFq9Xdfjvg8TTIbzh8j4lONP/wwFfgbDSqAFyh1KHduoeZ3hZmOKs8bvcKdHPTJSsGULvVr6og/wUTGJbgR63ItVMDeG+AmJ2DhQFXbrTdD/GNqxA+5mTjUde5/5gzt20m812ka30vDaYpcPyHFJSU1Kt1E4jMl8eS43fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejzcNa78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejzcNa78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1AC1F000E9;
	Thu, 20 Aug 2026 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243780;
	bh=t21z64gjIbfUYgZkeEwSJVpXCiSc/nIGr36EB2YnVnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejzcNa78jsE6jzPrNSMfiOHTz5mR0Bpj6Iav0AtFnQEUxQSh0SbSX54MuYFAoVGYk
	 WPumrGqGNenUW0YalxOsu7hdQBFoRDu+XfSKkf0JemS6KDMeNw9s6EQfeiQMkXqO7D
	 YoSu41RZzy6mDwZF8rN5rSXR0K4MiM5660pBPjCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Montgomery <james_montgomery@disroot.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/272] ksmbd: defer destroy_previous_session() until after NTLM authentication
Date: Thu, 20 Aug 2026 16:56:38 +0200
Message-ID: <20260820145238.026583760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: James Montgomery <james_montgomery@disroot.org>

[ Upstream commit c74801ee524f477c174a1899782b6c3b6918d407 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1495,11 +1495,6 @@ static int ntlm_authenticate(struct ksmb
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
@@ -1537,6 +1532,10 @@ static int ntlm_authenticate(struct ksmb
 		}
 	}
 
+	prev_id = le64_to_cpu(req->PreviousSessionId);
+	if (prev_id && prev_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_id);
+
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
 	 * that it is reauthentication. And the user/password


