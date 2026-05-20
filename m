Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46302F0C62;
	Wed, 20 May 2026 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299007; cv=none; b=eHbekza4jpHz+wqugukfKJkSwTdD2/p7Vn8yVLCBZhzItrvgwgjvFwGGZO/TP3Q3IMVe/lvFnZmjxAreYlTlHZ6WZrLQnSUoqux/ISMcdhwiT3CeiLUO2qaqzP1J9twpYi4wzXM7Tioo0gdA8Ep8rs/5cmhAHlXGKT02w6n8I7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299007; c=relaxed/simple;
	bh=Ubg6B1+Ah9njhMHw5fY19jxoZSvgEQbpYSuguoNa/b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tirDu+bJf8hEnkMneztrznB2OURbwzqxqrDc2+0vTV02b4Kkb7fcFqUzduPXnthpK0rAvyugWzJrjr/1iGW0Es+fbV7gXQLVlcPSfU4ezoAjg2Y3MN55pV8QDpEXwmjJlTfZwiW+vi0RQYt7PjRH/o7Q1wSp0+No5By4sg/Y7ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKn8uRMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKn8uRMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B371F000E9;
	Wed, 20 May 2026 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299006;
	bh=gjb9t9W0LGygYI7U1qgFl7H3srwmGvTCeD05QSLwOU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKn8uRMuZRryInmgw/dkAaRBdVKC0+nnp3booVFrin/x7RA9nxUyJOgrRUfQlCrUj
	 6rYL/UgASuydg+5HqDfY9xS7QhxioccRqKPUj4nWFyTuEVluOcuaKAJ2TICP42g8aL
	 UfHrhv1W2WQyfcE4z/mrnLUhEKFK6Jf9qGjrUCOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akif <akif.sait111@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 628/957] ksmbd: fix use-after-free in smb2_open during durable reconnect
Date: Wed, 20 May 2026 18:18:31 +0200
Message-ID: <20260520162148.148165404@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akif <akif.sait111@gmail.com>

[ Upstream commit 1baff47b81f94f9231c91236aa511420d0e266b9 ]

In smb2_open, the call to ksmbd_put_durable_fd(fp) drops the reference
to the durable file descriptor early during the durable reconnect
process. If an error occurs subsequently (eg, ksmbd_iov_pin_rsp fails)
or a scavenger accesses the file, it leads to a use-after-free when
accessing fp properties (eg fp->create_time).

Move the single put to the end of the function below err_out2 so fp
stays valid until smb2_open returns.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Akif <akif.sait111@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 16ea123f61223..4bfbfe53aa4eb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3024,29 +3024,23 @@ int smb2_open(struct ksmbd_work *work)
 		if (dh_info.reconnected == true) {
 			rc = smb2_check_durable_oplock(conn, share, dh_info.fp,
 					lc, sess->user, name);
-			if (rc) {
-				ksmbd_put_durable_fd(dh_info.fp);
+			if (rc)
 				goto err_out2;
-			}
 
 			rc = ksmbd_reopen_durable_fd(work, dh_info.fp);
-			if (rc) {
-				ksmbd_put_durable_fd(dh_info.fp);
+			if (rc)
 				goto err_out2;
-			}
 
 			fp = dh_info.fp;
 
 			if (ksmbd_override_fsids(work)) {
 				rc = -ENOMEM;
-				ksmbd_put_durable_fd(dh_info.fp);
 				goto err_out2;
 			}
 
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
-			ksmbd_put_durable_fd(fp);
 			if (rc)
 				goto err_out2;
 
@@ -3816,6 +3810,9 @@ int smb2_open(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
 
+	if (dh_info.reconnected)
+		ksmbd_put_durable_fd(dh_info.fp);
+
 	kfree(name);
 	kfree(lc);
 
-- 
2.53.0



