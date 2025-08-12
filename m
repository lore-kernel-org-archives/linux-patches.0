Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB72FE58D;
	Tue, 12 Aug 2025 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021829; cv=none; b=uLOuezeCMfdvE2ErKw11Bo2rd4ONUilTvD1kljB7opHGOvZLwjsTWjwwMpeXYIpqRSgaCRy7/LRs3jwrLeEiymd5ieg1+Jae0N0vYzGlaQay+8/y6VVJ7t+itFje2Y0nNp0/X+ERt4B6UrYFjTknV1Ph4RX8L2Bg9ty3gVuadHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021829; c=relaxed/simple;
	bh=E7J1euBRx7e5EVs7BjyWGka79vSL/BaTk19glkcgKP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kh1mEplh+FvF+JrkotNSrI63DcS+0iZt0eO8ErR3S8RYsC4/3PfAkYYlGnE5IfmvybFGWtuR5nySSwnhj7ElcEXOZN5EiMS4XPCW+bH4ZwPSq7KSbv72Sw97QF1p7BPchT4wNuIKro62/ZNxSJVo2oTBRbQ0ShOkmZEGlA/tP90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGmxS12h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGmxS12h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE18EC4CEF0;
	Tue, 12 Aug 2025 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021829;
	bh=E7J1euBRx7e5EVs7BjyWGka79vSL/BaTk19glkcgKP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGmxS12hQAQn7GN5/N8Z36tJYZuhnSW4ZK9n9IfHLkiK+n+0oygDOXzBE17V8gmij
	 mdfCirujy9RNZmBgfXi3/HOf7m+lFl2pbK4PZkwKMrsF4Paa87oYWsl4lUA6fvH4EQ
	 u7bkAEa9s+WnbZHZDT3pQjcsl+EjhRML5RbA/qbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 238/262] ksmbd: fix Preauh_HashValue race condition
Date: Tue, 12 Aug 2025 19:30:26 +0200
Message-ID: <20250812173003.291034050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 44a3059c4c8cc635a1fb2afd692d0730ca1ba4b6 upstream.

If client send multiple session setup requests to ksmbd,
Preauh_HashValue race condition could happen.
There is no need to free sess->Preauh_HashValue at session setup phase.
It can be freed together with session at connection termination phase.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27661
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1831,8 +1831,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 				ksmbd_conn_set_good(conn);
 				sess->state = SMB2_SESSION_VALID;
 			}
-			kfree(sess->Preauth_HashValue);
-			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
 				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
@@ -1859,8 +1857,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 						kfree(preauth_sess);
 					}
 				}
-				kfree(sess->Preauth_HashValue);
-				sess->Preauth_HashValue = NULL;
 			} else {
 				pr_info_ratelimited("Unknown NTLMSSP message type : 0x%x\n",
 						le32_to_cpu(negblob->MessageType));


