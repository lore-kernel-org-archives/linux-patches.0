Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7BF19F120;
	Mon, 23 Jun 2025 22:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717107; cv=none; b=cEzb91cLX9KfBvpGErv2+tQwa5jm+vA5NECh7rl8LuseSuMI81MyDDVpZHQxvSgfauMHt+ZHSVE6CKo+wtxDRfYTjJ3ldk0JpNvFqNiHiadQUj4g+aZrtQBsWG4iVfQPlpCdeobqvRBpdqhhlXJVN8jH2M666kNqoP+/b4qla/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717107; c=relaxed/simple;
	bh=KkkBPCKvGpxLWNiZOcN1CwDLRofOEFtJTJCwH582aCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDWTXD+gKdT7HopOWJeYC+rIS0A8VczvnfceL19BdO8vfwGp2dDEBVRIafPvH/NaUbeqszjSwa0oAzKNZCxUDhb55ktJmAZwJ5otzk72Atu5wAjiB/L47cHabCypi+Tt7/PUYMgQOJOe3iYlKrOMA/Zp3aCw7hKBFPhLHl9i7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRd7F/A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRd7F/A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6DDC4CEEA;
	Mon, 23 Jun 2025 22:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717106;
	bh=KkkBPCKvGpxLWNiZOcN1CwDLRofOEFtJTJCwH582aCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRd7F/A5lzfrmxRZQ3KAHFYpqcKJMPdpgXJuz4w2URzE3wALjkXfuRWRPlI1Mwjhr
	 nAkcr0WDUXkRmKPCy3xxXMpJIDtxx9vPYka3SjWkvt7fZI7L1ojWa2Rs+j6Oih/npd
	 7k2GntNs6sbMzDuHP+BBg2ww8H0qSawaHCijwljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.12 319/414] ksmbd: fix null pointer dereference in destroy_previous_session
Date: Mon, 23 Jun 2025 15:07:36 +0200
Message-ID: <20250623130649.971028081@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1605,17 +1605,18 @@ static int krb5_authenticate(struct ksmb
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


