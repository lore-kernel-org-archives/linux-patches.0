Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13BE1FECBA;
	Mon, 23 Jun 2025 21:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715753; cv=none; b=tbvzKqZTrWK1h/D9aR7zKG1jkT5Q5nKjTGNI2/PXGBOEDZ4GkB+W1a2iEFO82Zqlyr6qLVY2l8P16KNilEqAqXbiPRr4rVCvXeqcfnfRuuYQkUP1A2ZC2F8eoLR8dq238PKKi5YKSBUcV0GG88IciiXVIq42a9QSR//E2NLAKQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715753; c=relaxed/simple;
	bh=i66EsRU/Z9ms5fDypiQlkHQoSgnPo5CxlFLHM4Qdn24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLqZXwxzNMaZuh1aznE+N50tRO8YbEfRO0cnL7EPl/Cye+AKmYM/gcNeKDhaAHqvL5cwsIUeDqv45fNPz7yJaeoGWS8AzjzPeQI0R6fIO4d8ADNpokPO/6UBOT/GeX5JvjVQZYAtQW/Wk9HV5dwWDcbns1XEZhiKOWHBbvEqvWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7OjMLyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7OjMLyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F6DC4CEEA;
	Mon, 23 Jun 2025 21:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715753;
	bh=i66EsRU/Z9ms5fDypiQlkHQoSgnPo5CxlFLHM4Qdn24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7OjMLyyyyZ7KzVKl7b3UzBUHkRPqgQrwep7tJIVm3mjuB8iq8iLQM7XQz26vNR89
	 elt/i/n1YKVOMXuGmwCH09Qn+p/eOCUhfwbGhf0J82GDtbUxLGDqPBqCHqi/KRqyeS
	 FjBrjDsNofD9OrLRmeTSsKUIa8rZ7ERu4i3/3+ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.15 478/592] ksmbd: fix null pointer dereference in destroy_previous_session
Date: Mon, 23 Jun 2025 15:07:16 +0200
Message-ID: <20250623130711.802888025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1607,17 +1607,18 @@ static int krb5_authenticate(struct ksmb
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


