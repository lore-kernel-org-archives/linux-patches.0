Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19FF168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AEAC4339B;
	Mon,  8 May 2023 10:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541377;
	bh=H31vwZ0XZVomVXa/a0t0cVSLQoLFQwi7q5oYi3uUXrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgAsk27UJX4U9om0PfMK+wb2AtkjNzCFKk27hkYZkmH6P5PnFtp5CixvEI6pS6ATY
	 q3vSa8l50bmNx/ZW8XNLEvAqHlBl4cLTISNtO3hzER1brW9Zlev1Hx6Qh/CBs8NOnp
	 Pxy2FNOlmPkYXIKd4EggiqBHDcGQN6gIPH0q2sOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.2 094/663] ksmbd: not allow guest user on multichannel
Date: Mon,  8 May 2023 11:38:40 +0200
Message-Id: <20230508094431.506208185@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3353ab2df5f68dab7da8d5ebb427a2d265a1f2b2 upstream.

This patch return STATUS_NOT_SUPPORTED if binding session is guest.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20480
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1456,7 +1456,7 @@ static int ntlm_authenticate(struct ksmb
 		 * Reuse session if anonymous try to connect
 		 * on reauthetication.
 		 */
-		if (ksmbd_anonymous_user(user)) {
+		if (conn->binding == false && ksmbd_anonymous_user(user)) {
 			ksmbd_free_user(user);
 			return 0;
 		}
@@ -1470,7 +1470,7 @@ static int ntlm_authenticate(struct ksmb
 		sess->user = user;
 	}
 
-	if (user_guest(sess->user)) {
+	if (conn->binding == false && user_guest(sess->user)) {
 		rsp->SessionFlags = SMB2_SESSION_FLAG_IS_GUEST_LE;
 	} else {
 		struct authenticate_message *authblob;
@@ -1715,6 +1715,11 @@ int smb2_sess_setup(struct ksmbd_work *w
 			goto out_err;
 		}
 
+		if (user_guest(sess->user)) {
+			rc = -EOPNOTSUPP;
+			goto out_err;
+		}
+
 		conn->binding = true;
 	} else if ((conn->dialect < SMB30_PROT_ID ||
 		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
@@ -1827,6 +1832,8 @@ out_err:
 		rsp->hdr.Status = STATUS_NETWORK_SESSION_EXPIRED;
 	else if (rc == -ENOMEM)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+	else if (rc == -EOPNOTSUPP)
+		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
 	else if (rc)
 		rsp->hdr.Status = STATUS_LOGON_FAILURE;
 


