Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8752C358367;
	Thu, 20 Aug 2026 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247064; cv=none; b=QvbplxfvWfxLexgdv6k13j1Ra7H/CqtsvlfekNGMfrb/PogTxzIcnl5piDf6fT8/NnKFbKsaaJTETJXXhQF9SpjQlUuoNXH0/MFmmUkZBw1wfjGSgYLcFToxJHcPCefUjSBYt1WVA5RDxoLyLTsGT75JB59YU9Nr5uMgYWo2x4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247064; c=relaxed/simple;
	bh=JAf2Ixo7wOdiW0JA+ePNeaqJ0BVGmyeSJaSVtAOr9X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCcOSGz480LZnXuTn78JbqseLzCRRQYOPxj21bQpB7EjXU072yD+n/NxQp00ONLsnNwhZxvlM0vT/APkztAny8p2rfonnCWBZu20DykP6UFnfAhr5zU67k/qUtdcY+9JDStqBl8vtrndNOfZgCbgek5gv0zXnM7C/mwuMiXUdUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lya11txV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lya11txV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B72F1F000E9;
	Thu, 20 Aug 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247063;
	bh=ania3mIqWnIyYinfoT6mnuMoeMdCpfYfKHI/yqJW5KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lya11txVVLHnOktmbUfYOTUA1mXYcbSL90J2lhWolsHGg3PCGMXd7hcLFw+La0TrK
	 6ERQ38cmDVFZ6IVKzLA7+Yvp9YzpGiQsvG24R3R4a0OoZxe2rC5kYZaNfY2xUS2tnO
	 e3uXOBjH4bQyaczt8/Snbf6+W06DZ0mUIR8S9U/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/220] smb/server: fix minimum SMB2 PDU size
Date: Thu, 20 Aug 2026 16:55:25 +0200
Message-ID: <20260820145227.524968617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 4c7d8eb9a79ae5400eac19c4f6f0815bff674452 ]

The minimum SMB2 PDU size should be updated to the size of
`struct smb2_pdu` (that is, the size of `struct smb2_hdr` + 2).

Suggested-by: David Howells <dhowells@redhat.com>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: David Howells <dhowells@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -378,7 +378,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn
 
 /* "+2" for BCC field (ByteCount, 2 bytes) */
 #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
-#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
+#define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
 
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
@@ -478,7 +478,7 @@ recheck:
 
 		if (((struct smb2_hdr *)smb_get_msg(conn->request_buf))->ProtocolId ==
 		    SMB2_PROTO_NUMBER) {
-			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
+			if (pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
 				break;
 		}
 


