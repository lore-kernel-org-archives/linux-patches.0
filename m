Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A1221543;
	Mon, 23 Jun 2025 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717568; cv=none; b=Qp4+QrQSmcOONlonie49BE3yR++2glxVuEVjozghB9iA7jh0JVQUOX1OWiTZ+2QxommVjBnNO63WMeeeWttYuvde8Jh2DtbNbh/74cWfMswfiaUduBtCTuS8DejleW1h27SrFGgrSoX7ROINhwim4G0LvGiGThxfaFPihRWlBUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717568; c=relaxed/simple;
	bh=DTprlywP+mMIOaBbe4uZI+w9Kmq4Cp45tsW5ePyHL6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftUoaYub+dB8XFq4JlZY5zUD4t5MiXbTyI0DRod18Im1GfKwKZ+K4+eFjwqnYjmu2uOXACGBsMIs0nV/WMvhTq6EdeWm/WAz/gnkomyHyuEXbZFYm5h+uNXtI7KePNFpbcEtwXgYTElttstrqx4V3iX+zLwHfpyo5EeTsKUYqg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVZc2Doc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVZc2Doc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B613C4CEEA;
	Mon, 23 Jun 2025 22:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717567;
	bh=DTprlywP+mMIOaBbe4uZI+w9Kmq4Cp45tsW5ePyHL6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVZc2DockwNoVgAQnfDpEHmVXXjJh07MsJou2kV4DK6WSDhU/jZcZYAIOGPSOvKDV
	 SslKb29B2dcRxn/o+O0bo8fdt10IhNZ0BiFL1V+oTJ17FiNN46o6taQntNKfQzc8n+
	 OejewLTx7PniBYz9zrPAG/6VR2nEC3Iw1mJP9F2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 454/508] ksmbd: fix null pointer dereference in destroy_previous_session
Date: Mon, 23 Jun 2025 15:08:19 +0200
Message-ID: <20250623130656.309667489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
@@ -1610,17 +1610,18 @@ static int krb5_authenticate(struct ksmb
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


