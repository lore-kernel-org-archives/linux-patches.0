Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F032DE1E2;
	Tue, 12 Aug 2025 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021443; cv=none; b=LsJNdaaBse6JVYdXSZrYDyADVxxhXdkSk1opEZV0WQ1q8xYhHzNovgNBN6qATK+2VZaxgzAaCU0iRv0PvfBtFZTP1kRoCRLU4Aa9XlTG+aC3VTn2w0/ysv/DB/N0HFYwg662FizlJM/U3leN0dV8l2cwXsiqIEbPdzDc4ygqkD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021443; c=relaxed/simple;
	bh=ZhiGlbMeqE+4xpIbtIRHcbE98ddUs7n5TTLQ7r8DQpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNhERgDxXXRBGfLhw5UkE1GafOb4bQ0epEuvNpYUyS/kYXk2o5q29yQK/gMwLSGt9jqt6mA5sGdWEWSIwGnEdK420FDUud5tJV17jtiQEe1sHY+Y/QcuSnHydk0AQoW2/j8atTMa5F+qwBJgpJZAS4PPluulW789tGJvcnu5PIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxI2vk0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxI2vk0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E963C4CEF0;
	Tue, 12 Aug 2025 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021443;
	bh=ZhiGlbMeqE+4xpIbtIRHcbE98ddUs7n5TTLQ7r8DQpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxI2vk0Edu75+Qzb88ZZgfdvS835zTDZoQ+XU9UcySVWcAYHbyGvRq9mhLsOee4DK
	 JOq0opLvtMc70e0ydHknMF4TPfk1x78fdNRp2M4xwjz05Gwss+KaCMpMINxEk2Y3NV
	 Z39M+z2QV6PnsiDwpW4WIVxHuaczJdv0coUpyiec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 240/253] ksmbd: fix Preauh_HashValue race condition
Date: Tue, 12 Aug 2025 19:30:28 +0200
Message-ID: <20250812172959.052498540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1842,8 +1842,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 				ksmbd_conn_set_good(conn);
 				sess->state = SMB2_SESSION_VALID;
 			}
-			kfree(sess->Preauth_HashValue);
-			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
 				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
@@ -1870,8 +1868,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 						kfree(preauth_sess);
 					}
 				}
-				kfree(sess->Preauth_HashValue);
-				sess->Preauth_HashValue = NULL;
 			} else {
 				pr_info_ratelimited("Unknown NTLMSSP message type : 0x%x\n",
 						le32_to_cpu(negblob->MessageType));


