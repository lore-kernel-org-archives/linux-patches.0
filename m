Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D95347F2CE;
	Thu, 20 Aug 2026 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248463; cv=none; b=sjAS8jEGG0P2Urrn6irC4MLNoPfHlLBCZhKIS1BFGPF5mceTRZ4liIv4VJ76KgFAyf0WrwXXfmXoYRYWAhq0tFZKxU+BQaIwD5E/n4IVsN7bkf2HLvFuVcs3G7V7dIuB2dG8d7AlPrhygyg9/Ap78/52X9Tjsm4ysKraRhULoDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248463; c=relaxed/simple;
	bh=QfTJCESfLtg4yJlgkaBGH39Ora3Z7/xVDvPMx7C4rcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deGT7GQbe6b8OYv5+WLdyxm3UO4g0NOo3mdQAc+YJ1hadNRSHF997FQh1pc97vPq5rq1Y3Z8/fexikPnswAkC08O5sG3MFA74U9GsXnd/cKgUsiyXsUF2uoDB7RbBuCC0wPtnWZCBMiUqiAO80qmfqorZbGtzU2ut+mNJb71WW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDlvpCCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDlvpCCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066AE1F000E9;
	Thu, 20 Aug 2026 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248462;
	bh=nBt77s5wARhgjv1C9AhJCA1x0ZSPY/Yj1JEJNPhEcVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDlvpCCfkN2apLbDCgjcTsNJDqBiQC/vf2n8wwy4i1UvXOOqARF1rNeQ7RWGxuAD3
	 XbKl1LqmD6JWvoLXlmMa80W9LC3HDhFCXMJA9mO6UC+PAxTC7PQaL28sGEzUv2KUS8
	 GWqITJemC/r/JAvQqbKtwF4Zp1sIzfZSEIUT7O5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/303] smb/server: fix minimum SMB2 PDU size
Date: Thu, 20 Aug 2026 16:56:05 +0200
Message-ID: <20260820145300.334115879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -307,7 +307,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn
 
 /* "+2" for BCC field (ByteCount, 2 bytes) */
 #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
-#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
+#define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
 
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
@@ -399,7 +399,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		if (((struct smb2_hdr *)smb_get_msg(conn->request_buf))->ProtocolId ==
 		    SMB2_PROTO_NUMBER) {
-			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
+			if (pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
 				break;
 		}
 


