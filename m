Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847D468C16;
	Thu, 20 Aug 2026 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247568; cv=none; b=dpn6eSDFZqlwp1XyVNxycGGKZ1d/wq/cOZ28bhnEHUsdu8EOJcDA69QElhTLWlZ7VmgdbiKsYs9Fjkznil+CyMc70nqS4O1Fg4ZkD4eU47UeuIn1Tyw74Xm/0752mZBxT6vYIapJ5YMycLvV4osCtUpygoxp9hUEeKNEu68wGxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247568; c=relaxed/simple;
	bh=KNGGCGuVn2CViKrdjrCj2yxW7lo4Hy1qm2WH+7Ky9fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2LDxAuwxFNwKl0ov0y+utyd+ze11j2H2AY9eQ0RGiLko5YCHqmEshOgxLGdWA9yIJ8P6r9Q4lkEGr/bYW5anuaBZRVsudn4D3ZmrBPmN3wp6Zd1ftbsj+lomof+4jLce6EO5q1WmeBBZWsieyafhJKqSyJrntjN5ZVOjCcB6BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ovb3kpyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ovb3kpyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A081F000E9;
	Thu, 20 Aug 2026 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247567;
	bh=A2GIwM2iAubAloMPmRYrqiUTeK5aimPJRL6zL480OEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ovb3kpyrq/tr/kpV8zG/qQ48rV8PWKcjh0WPdrKxUdM73UWGspa+b00pYdVqzRbiQ
	 or5IasXPoTJjgmC+m2NofvXoYglrn1WFSRm5ybhMK7wSFcYjIX9BHQwh96a2wdb9i4
	 NcOwQHIH9+FNzx8iA3+EYJravuSXYvC4V7g9ZMPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/166] smb/server: fix minimum SMB2 PDU size
Date: Thu, 20 Aug 2026 16:55:51 +0200
Message-ID: <20260820145213.921128110@linuxfoundation.org>
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
 


