Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A88A225417;
	Mon, 23 Jun 2025 21:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715521; cv=none; b=Js90ZzT7cBZTJuOliBjKo/yWi3wG7wAlwgPlNrPoZaC1pY5xAQ5GS2aGzUcPDs8hiaXBjqtIxXk1lX/imgX1eGekNDZvvkepqit2kOKvShxysx4tLrkbYVJAm8PYThmiCUtTFZ12Dfoyl0zvj/JtSQxQLG860OyngbXcLHA2imU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715521; c=relaxed/simple;
	bh=oK6bEiBx6V3pwlnfFDWbEcR5UjCwgD8YlP/emdQ5Co4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCgxHY2Hjd2gKi2/WsSMlD83M/StSfIftDI6jAP6spBxx7fI4CEcU784nby2vB6E4U5ukpRF9QQc9VNsyZwE3Dqr8HlcgWhUGKAXERo1vHuBwYD3nckTwTMc7Ntb4E3G+u/8rID760N5w5szBw29Qk+7yRJQf9w0T0ucZLIghHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYDutQD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYDutQD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DE4C4CEF1;
	Mon, 23 Jun 2025 21:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715521;
	bh=oK6bEiBx6V3pwlnfFDWbEcR5UjCwgD8YlP/emdQ5Co4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYDutQD6P4YRlVRsKbzfzpOPY3fdngKeL2D6lLSG4LABwXo/u+V/1bW1v0GA+FP5G
	 NVQEtZ/7GY4qHL1BoOi0OWdVLnouNhFqQHBhlmXDbLVfc5QtpSD1kWS38RD7alCCSJ
	 zIvLomXyElMi9I612bbA29ne+WJ/C8bLH5S7Y4NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 225/290] ksmbd: fix null pointer dereference in destroy_previous_session
Date: Mon, 23 Jun 2025 15:08:06 +0200
Message-ID: <20250623130633.697013202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

commit 7ac5b66acafcc9292fb935d7e03790f2b8b2dc0e upstream.

If client set ->PreviousSessionId on kerberos session setup stage,
NULL pointer dereference error will happen. Since sess->user is not
set yet, It can pass the user argument as NULL to destroy_previous_session.
sess->user will be set in ksmbd_krb5_authenticate(). So this patch move
calling destroy_previous_session() after ksmbd_krb5_authenticate().

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27391
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1599,17 +1599,18 @@ static int krb5_authenticate(struct ksmb
 	out_len = work->response_sz -
 		(le16_to_cpu(rsp->SecurityBufferOffset) + 4);
 
-	/* Check previous session */
-	prev_sess_id = le64_to_cpu(req->PreviousSessionId);
-	if (prev_sess_id && prev_sess_id != sess->id)
-		destroy_previous_session(conn, sess->user, prev_sess_id);
-
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
 					 out_blob, &out_len);
 	if (retval) {
 		ksmbd_debug(SMB, "krb5 authentication failed\n");
 		return -EINVAL;
 	}
+
+	/* Check previous session */
+	prev_sess_id = le64_to_cpu(req->PreviousSessionId);
+	if (prev_sess_id && prev_sess_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_sess_id);
+
 	rsp->SecurityBufferLength = cpu_to_le16(out_len);
 
 	if ((conn->sign || server_conf.enforced_signing) ||


