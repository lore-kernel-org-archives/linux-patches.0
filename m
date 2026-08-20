Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE9E307492;
	Thu, 20 Aug 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247565; cv=none; b=AJdtdF3VifVlQo7Q4OKWwNn+oTnFxbenM+wDx9rqt1DOoA5l8bhPaXrSillXizdXJhE00ebKCmddz5/ZUuMLIFSYMr5Rux1DplDLEabmdhryeeQXEoTMCsBKDSz6NistTAa7zp0dReSGOnbSMJ/Y9XomeU1lKrMYuh8l6v88C/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247565; c=relaxed/simple;
	bh=OdpzGTat7bv4F2HmJAMMl50qmCdP7A4dBQjdGO9Dyms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKWMDNRmIMwOztzEUX9UX+TszyTdPoIoXFaBl+xHLy2WAaRpQ3QBcQMi+xzdWQoTzy4xYfNQkEY8NxiuiyT0GF78gFHM8iS3sUG/YM9s2kCPV5JmeNFFCVKiLSezeQiqBcPzBjRPoUJHbeJPNRRK+siZJvxwQNBX8kqGDe1C5Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC6SbHVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC6SbHVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2C81F000E9;
	Thu, 20 Aug 2026 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247564;
	bh=zxqVMU/+IUfESF/I00B0VTvUkJzf0F1j81nP1aZkKTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EC6SbHVIW+AtuQhCDn3CPqlxUg5kf6uq0UWuf8w1HeED0IN1yVUFM1WeuepiTkVbG
	 C5FUOBXWGco0bzpx/H+DiBtpMSVgegCPO1Kg74BKMQIulsuiyp8DsfmgDbFvRp6Gh5
	 XRoyDy7cLSjV5mu7VWWyJ9Hrr4nIRBsXOx7NV1c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/166] smb/server: fix minimum SMB1 PDU size
Date: Thu, 20 Aug 2026 16:55:50 +0200
Message-ID: <20260820145213.890879118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 3b9c30eb8f5aaad4a54cdfa470b74c0467cc71e8 ]

Since the RFC1002 header has been removed from `struct smb_hdr`,
the minimum SMB1 PDU size should be updated as well.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
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
 fs/smb/server/connection.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -376,7 +376,8 @@ bool ksmbd_conn_alive(struct ksmbd_conn
 	return true;
 }
 
-#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
+/* "+2" for BCC field (ByteCount, 2 bytes) */
+#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
 #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
 
 /**
@@ -444,7 +445,7 @@ recheck:
 		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
 
-		if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
+		if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
 			break;
 
 		/* 4 for rfc1002 length field */


