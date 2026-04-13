Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA3230EF6B;
	Mon, 13 Apr 2026 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097761; cv=none; b=H0M0JYvtBr+UqKx0s44yFJwNWGdC7zG+DwHrIg3N6tWS2tMePZ8IYNRQe8AvD3/44Y1AlVndzNV5EgbmzXUYb0eFXVhwi02C0dth6up1Vmu1OeaJECO4rEb3WbcII27oaFUeOpzygLw5jdbqTMJ8yO7Ik8j0swje8oRpRqvXNEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097761; c=relaxed/simple;
	bh=EmOk8IUZwq+uFiFA+Pyabf5UL/3hcUYhHRox9M2pMjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5L8L4+FDUewbSC6stdVaSo4s36ptZFqE63pHU+Q7a34U2hcwqQF2q8lUH8kUs/l0bsj0ZN6Oer4iJzYZX6DUGb8H+pr48cfozvTBwaL8ViwaZsw1kj/MqQfjFVO6R1tD2bcfFUnmqw/7dFtM+/H7+F7N0jEiDBZZZ6N0lbiiyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Fhfu0jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Fhfu0jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E2AC2BCAF;
	Mon, 13 Apr 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097761;
	bh=EmOk8IUZwq+uFiFA+Pyabf5UL/3hcUYhHRox9M2pMjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Fhfu0jlMYU01ZCCyzV90FrNTRMkZqFBdBurPsVHUZWGlX3k8YRTXQJfgqge9Arx6
	 FVSDqSKL0G6dnEK/3h21bh4SNlwaR2k+UXogeduXQdnykuRBB8U2Tlli0r5U+hP6N0
	 q2fZ7aKPcDcEsgZ00OA9IU5vfRgQQQ+T9/qtNyGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 230/570] ksmbd: fix null pointer dereference error in generate_encryptionkey
Date: Mon, 13 Apr 2026 17:56:01 +0200
Message-ID: <20260413155839.075987989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9b493ab6f35178afd8d619800df9071992f715de ]

If client send two session setups with krb5 authenticate to ksmbd,
null pointer dereference error in generate_encryptionkey could happen.
sess->Preauth_HashValue is set to NULL if session is valid.
So this patch skip generate encryption key if session is valid.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27654
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1628,11 +1628,24 @@ static int krb5_authenticate(struct ksmb
 	}
 	rsp->SecurityBufferLength = cpu_to_le16(out_len);
 
-	if ((conn->sign || server_conf.enforced_signing) ||
+	/*
+	 * If session state is SMB2_SESSION_VALID, We can assume
+	 * that it is reauthentication. And the user/password
+	 * has been verified, so return it here.
+	 */
+	if (sess->state == SMB2_SESSION_VALID) {
+		if (conn->binding)
+			goto binding_session;
+		return 0;
+	}
+
+	if ((rsp->SessionFlags != SMB2_SESSION_FLAG_IS_GUEST_LE &&
+	    (conn->sign || server_conf.enforced_signing)) ||
 	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
 		sess->sign = true;
 
-	if (smb3_encryption_negotiated(conn)) {
+	if (smb3_encryption_negotiated(conn) &&
+	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		retval = conn->ops->generate_encryptionkey(conn, sess);
 		if (retval) {
 			ksmbd_debug(SMB,
@@ -1645,6 +1658,7 @@ static int krb5_authenticate(struct ksmb
 		sess->sign = false;
 	}
 
+binding_session:
 	if (conn->dialect >= SMB30_PROT_ID) {
 		chann = lookup_chann_list(sess, conn);
 		if (!chann) {


