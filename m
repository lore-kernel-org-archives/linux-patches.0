Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B064CDFF;
	Wed, 20 Dec 2023 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi4aaREY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDC2C433C8;
	Wed, 20 Dec 2023 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088785;
	bh=va8NEhlxSXzjr0lnzHX/UWE0OROpB7RXquHz7vsmah4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zi4aaREYHF6TfaRL/gFc+ohUkTwa/1rcXX1WOMPQlyCR2IPi6ArFQEmzDF/BzCDBK
	 gI1BELEPOhHkeclhXvADFCdLLzHpPDYdPypoEJYKGgKI2TEsOjQU8lA1/sNc0KmtUX
	 fG9JKtF5zkLX8MmN9KdnDp4n1P0XFM7g5Bn24GRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 030/159] smb3: fix ksmbd bigendian bug in oplock break, and move its struct to smbfs_common
Date: Wed, 20 Dec 2023 17:08:15 +0100
Message-ID: <20231220160932.687857226@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit c7803b05f74bc3941b127f3155671e1944f632ae ]

Fix an endian bug in ksmbd for one remaining use of
Persistent/VolatileFid that unnecessarily converted it (it is an
opaque endian field that does not need to be and should not
be converted) in oplock_break for ksmbd, and move the definitions
for the oplock and lease break protocol requests and responses
to fs/smbfs_common/smb2pdu.h

Also move a few more definitions for various protocol requests
that were duplicated (in fs/cifs/smb2pdu.h and fs/ksmbd/smb2pdu.h)
into fs/smbfs_common/smb2pdu.h including:

- various ioctls and reparse structures
- validate negotiate request and response structs
- duplicate extents structs

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c  |    4 ++--
 fs/ksmbd/smb2pdu.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -657,8 +657,8 @@ static void __smb2_oplock_break_noti(str
 		rsp->OplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	rsp->Reserved = 0;
 	rsp->Reserved2 = 0;
-	rsp->PersistentFid = cpu_to_le64(fp->persistent_id);
-	rsp->VolatileFid = cpu_to_le64(fp->volatile_id);
+	rsp->PersistentFid = fp->persistent_id;
+	rsp->VolatileFid = fp->volatile_id;
 
 	inc_rfc1001_len(work->response_buf, 24);
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7996,8 +7996,8 @@ static void smb20_oplock_break_ack(struc
 	char req_oplevel = 0, rsp_oplevel = 0;
 	unsigned int oplock_change_type;
 
-	volatile_id = le64_to_cpu(req->VolatileFid);
-	persistent_id = le64_to_cpu(req->PersistentFid);
+	volatile_id = req->VolatileFid;
+	persistent_id = req->PersistentFid;
 	req_oplevel = req->OplockLevel;
 	ksmbd_debug(OPLOCK, "v_id %llu, p_id %llu request oplock level %d\n",
 		    volatile_id, persistent_id, req_oplevel);
@@ -8092,8 +8092,8 @@ static void smb20_oplock_break_ack(struc
 	rsp->OplockLevel = rsp_oplevel;
 	rsp->Reserved = 0;
 	rsp->Reserved2 = 0;
-	rsp->VolatileFid = cpu_to_le64(volatile_id);
-	rsp->PersistentFid = cpu_to_le64(persistent_id);
+	rsp->VolatileFid = volatile_id;
+	rsp->PersistentFid = persistent_id;
 	inc_rfc1001_len(work->response_buf, 24);
 	return;
 


