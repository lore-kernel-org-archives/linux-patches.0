Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4435D46D0BD;
	Thu, 20 Aug 2026 16:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243802; cv=none; b=ND47bMEMzzf98ASYNfKhQJVrzN/rPhgP8+RfPn8Xuw+O+Hlyfw1RApDvqCTFKrwnPdeI/MzN4TyZL9SksB6ptpasXqdBgX5oXZWLvVD/geU46B2Z1pxpYC3VQsEBZzjxL3DFVxmQWIXV8uck6gen7zq/i8PcIwLnjXQNl0bOo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243802; c=relaxed/simple;
	bh=8Lx3V4mg8mJPWAdntzid4NvmUL2CHNsQsCihnjq/QaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muK4ekdyWwgW7gEAyB+2mmHZ3C1ColE6hrZQDCQFgn+74hOsO0E6cjMAKN0SZRYEUN1v+7NpEpWQy6N89D4fh30hyBWbafaeWSR7/v9kC+2pW8qowBLk3VXLnlor6qeeetPRBR7W6ZiAkhM0CXEw8q0bwYh4ogWn43E5el5AOVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUxCNVMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUxCNVMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FB91F000E9;
	Thu, 20 Aug 2026 16:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243800;
	bh=NMI6/+8SGTwjuqDYZfneRA3WaD8Q21MzEEbrUQwu+bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUxCNVMAovRONwumuoPOYBF/IXUjjGX3zoVcseUCY4nVJm7eR1BalvH37S4V7tZJm
	 WTWh85WIQO9+uQrj61x6wLPhdVhY72Iu4Gsfs2HAG92ER53dYdFanwa/E3dKhjS7C7
	 EzUZnNEAg4UIwiextKZNy/lqA803TIF1moqAyCmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/272] smb/server: fix minimum SMB2 PDU size
Date: Thu, 20 Aug 2026 16:56:44 +0200
Message-ID: <20260820145238.204172818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/connection.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
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
 


