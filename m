Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619992;
	b=I0cnClHVues2nY3rlL6S8EpSQJjKwJMR+e38VASAtRcRtnHPOOg3HqahLfFn9MNUUsG8
	 3XK8hyqpQ4J7KqYuCokfhM6P+WmZ/pzN4DTjnpDAwHYzVw1vdNQkTIeckDxlnrTvEWDfT
	 0wj4tFUz6cKQhgHKJyXqx12mORq0FHwXqvgRF4PCFSQksUjBMXwUTi+MiuAy95dysSlPX
	 qoA6NvE6LBXUWpcE2pts9eR7hzAgTm6xV2uDPHS3rFer+0+rVyT5AEsN3z1UBJyDgYyzk
	 YWW5o3Baph01CN98KAWRgFoSaszIXCDOKeAuZL0mwC5RAWNX6XUSe/cB7KX0VBB2XNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/7kcyyPdXqIsMGMqxTm4rbRWazQCRzzXAB6nGjWcBLg=;
	b=Ii8gzZ1CXJn/VgC7NB+4iPCzZpEZERglgexmBj69A/cJVx0lpPdsmYpopVD5cErZs8IK
	 NtqR5w9DfsHUmakQgP/ODQ8eKbhP8yR3L4NRXiUadR6urp5xYVe0VEMiW5hWTAnVojd6s
	 PCyLFYB/xQ0swtLx6r0XtiNUjv6FjixGBQ303IzWFenWs2Tk4Hw6b+NUQ8MiEnVYrNzTb
	 hHz+CN3VBkH3MLlsubTXGhdmD8K7G0P/V8h157TbySvug7g8F4SKqitHYdAWkvOhlnUjJ
	 p6VsOpSF3XmY0pw5LRbrzL3ue+FOtkGJBCKOVtFC69T6aamMj6FFjVxbJ6Q4LsyCiXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMoCCgmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B7E606A31E;
	Wed, 25 Nov 2026 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMoCCgmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68241F000C4;
	Wed, 25 Nov 2026 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619991;
	bh=/7kcyyPdXqIsMGMqxTm4rbRWazQCRzzXAB6nGjWcBLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMoCCgmIDTqWFrlgJD2ETu2Ags9l037yKukBVUjYQalzYNB7UVrlOLU9ghXwqWI2w
	 +SWlg6diyKQL12h44Enfo8KOOP75aag6gu3ao88yCiCAb4kEB6lpWyDc+ge4u+9lqX
	 x0ibWIa3JGMmCrHDxyNs4N5K4D+pRVe1FyECZals=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 0772/1005] ksmbd: refuse reauthentication of an expired session as another user
Date: Wed, 25 Nov 2026 15:35:10 +0100
Message-ID: <20261125143839.829371022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

commit 265709f9dc271693d1a261a62242db652fcc471d upstream.

When a Kerberos session expires, its owner can reauthenticate it. For an
NTLM reauthentication, ntlm_authenticate() only compares the new user with
sess->user when the session is still valid. An expired session is in
SMB2_SESSION_IN_PROGRESS during the reauthentication, so it takes the
other branch and simply sets sess->user to the new user:

- the session's open files, tree connects and other state, created under
  the original user's identity, now belong to whichever user just
  authenticated, and a later Kerberos reauthentication is compared
  against that user rather than the original one;
- the original struct ksmbd_user is overwritten without being freed.

krb5_authenticate() already refuses a different user in this case, and
the valid-session branch of ntlm_authenticate() does too. Do the same for
an expired session: compare with the existing user and refuse a different
one with -EKEYREJECTED, freeing the newly looked-up user either way.

An AI assistant was used to find and fix this and as an independent
reviewer.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2358,6 +2358,17 @@ static int ntlm_authenticate(struct ksmb
 			return -EKEYREJECTED;
 		}
 		ksmbd_free_user(user);
+	} else if (sess->user) {
+		/*
+		 * Reauthentication of an expired session: as for a valid
+		 * session, and as krb5_authenticate() does, it must be by the
+		 * same user. Replacing sess->user would also leak the old one.
+		 */
+		if (!ksmbd_compare_user(sess->user, user)) {
+			ksmbd_free_user(user);
+			return -EKEYREJECTED;
+		}
+		ksmbd_free_user(user);
 	} else {
 		sess->user = user;
 	}


