Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B642FFF9D;
	Sat, 12 Sep 2026 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222264; cv=none; b=JI7ZKnMiJUHXTctBvxGaz5quwFOXMZ8OoeRSF3Y3gkCGuAvHcfYRoKejIv/VRGBT39TDE5EIq9/fxBy1vtm4v28WrIzwGGZ/m4WuYKlDW+csMJQa317vXgIKGZlOL01FDfzzH3CIIcxdp1cPNkS3tl7/y1RjGm+o/BKlBAkgTrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222264; c=relaxed/simple;
	bh=NxSRaHWhqv7e23NrO8plhcTjgxwqU/esrbXk/EoMYtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFwck8mR1ouqlI6bkbmO5cxxOO3RLM2vvIjBg+pTcG/5V3izOcAsKSA/c4EaFKXFfyeGqegJlEjBWptX+22dkr0V7KgSZisIuHsHg2nuOTEzi1qk5RH6j90ns8S1wrhQqL4/R2gISxgW1azEcaDbg4stwF5dbRnXC93SA0oPN5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAJ8FKba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAJ8FKba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F891F000FF;
	Sat, 12 Sep 2026 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222263;
	bh=MJl5vvS3QfhK6fge0P8BWdfJbgj+BQAU/I46PDz4LZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAJ8FKbabrPuvqhdBdXfnK2nzFYbgceOjeBmtJg8JfaHKrV9UJmFPgIyTCTulI9bN
	 c8KJh+QBXA+XUVFwIMqubRLClh3+zNa8lt8xGnVSBcIwdz8H/YgK2gtlXrFz300Sgw
	 7Nls6KxVn0JWjyjsdR9aE8fiOTfZoLx8E/nlazUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akif <akif.sait111@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0552/1424] ksmbd: fix use-after-free in smb2_open during durable reconnect
Date: Sat, 12 Sep 2026 08:49:44 +0200
Message-ID: <20260912065619.663630039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d97ffe3d2a710..b61b97bb21cd7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2996,29 +2996,23 @@ int smb2_open(struct ksmbd_work *work)
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
 
@@ -3788,6 +3782,9 @@ int smb2_open(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
 
+	if (dh_info.reconnected)
+		ksmbd_put_durable_fd(dh_info.fp);
+
 	kfree(name);
 	kfree(lc);
 
-- 
2.53.0



