Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5472F373BF2;
	Sat, 12 Sep 2026 11:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214295; cv=none; b=d+GLR6zGUFkPoZ+fB3UGp/wx80utbpLr3sQkGPkQ3v+6+GFdtHsnrDXp79z7RHDCzRNSD9kyAMZXfmYk203l+j6jC3+F/Mtax3hN+uSg+nL/DBUy8RCD2l8pkoOdj0eIFYnyVUydRkubQXwiFVjPb4SELuzHrEIY8C9ZIUhdDjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214295; c=relaxed/simple;
	bh=zwDzZUEvqDk/5UZq4Dmxgz0XArynymDiDMDVM1CXxGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXsqcQ/GI3wJ7ZSZ0Fv0i/ZI4IWjvtkVuolo7fmCF4Zmge/i7ebs/eTLs9nd6nqq35UJFX3tw59unHSkWoEabA/zmzv/ZjnUqjdnFmdYdcdlS+q2zjCd66yh/TDeZEVWv2vsdc7MRO9QNTDf94BTquL6/EQ/mznwdoNzpXJTru8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5+t3oXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5+t3oXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EC81F000FF;
	Sat, 12 Sep 2026 11:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214294;
	bh=w8hXNIBm11od8Xy7tetLvy/m4RzSqj64T3EgB/QvqoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5+t3oXJVjfcO5jGyxUyC//33azMfxuH+b6i3YK4mRdUtaZysGa5PMa2erVhmzje0
	 T4Lle7lLzPUGStVDefg58kZdeR1Vp6saNFTTr9F/bv8aAcpQnILSBmxEOpJy+rkGjI
	 Qe3RVR9x8nU/l4Zlucnh/2h59t481lTnbawUJqSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akif <akif.sait111@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0298/1376] ksmbd: fix use-after-free in smb2_open during durable reconnect
Date: Sat, 12 Sep 2026 08:45:24 +0200
Message-ID: <20260912065614.190622645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1dee4b59a22f7..1fa6e701f817f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3018,29 +3018,23 @@ int smb2_open(struct ksmbd_work *work)
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
 
@@ -3810,6 +3804,9 @@ int smb2_open(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
 
+	if (dh_info.reconnected)
+		ksmbd_put_durable_fd(dh_info.fp);
+
 	kfree(name);
 	kfree(lc);
 
-- 
2.53.0



