Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257102ED157;
	Thu,  3 Jul 2025 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554563; cv=none; b=GjYXrJgtuc9/O3PwEvgmORcO2wRGTQQyoBAgh+rbx2i2ToyD8sz1V5TGZ0wAYHKDZZUqv4D81LsASTB4HVEZ/DAhEb8KC71v1K7u4y3bgE2kPUiyW9n4i81zXaoHpd9yGRPro5fSerPQ23tIDZGrCStB2Er2pKk5IqwnV++5qnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554563; c=relaxed/simple;
	bh=Ugkfy67WKUwJ+cmdFNFjxC5ZsFZZU4wQyJuX+4E7Yqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdGfUj7LEjnXJPkpmLStTkCXQjh795ueGsVOS4xV5pmEBcG4TfCAs9LU5tuYbftuzVjJQVNmyfTak1rrHP0E7d7vAQR1dYE0nFuGyqsZKsC9aKMQfHz9tkSUzwkIj0XpO4foLEEQFWL8ssHZREd41jDQiGwsov+nLA6w57/n+Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnfjYYKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnfjYYKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF81C4CEED;
	Thu,  3 Jul 2025 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554563;
	bh=Ugkfy67WKUwJ+cmdFNFjxC5ZsFZZU4wQyJuX+4E7Yqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnfjYYKY/+GMuWB4D13JvUCXH/9BVAKm8WPTcICxcg2FdxbkWXePlp6TvAPh1Quoq
	 jHyDiNawieL8igVq7zELS6A+r1Fg7XcPSL2/K5ElM/2M/fsj8M6QZuyvMqKfd7OO6p
	 e0zkvEGsibudJQHd/qiHEwFhL7MQWGSGx88fAUME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 001/263] cifs: Correctly set SMB1 SessionKey field in Session Setup Request
Date: Thu,  3 Jul 2025 16:38:41 +0200
Message-ID: <20250703144004.340301363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 89381c72d52094988e11d23ef24a00066a0fa458 ]

[MS-CIFS] specification in section 2.2.4.53.1 where is described
SMB_COM_SESSION_SETUP_ANDX Request, for SessionKey field says:

    The client MUST set this field to be equal to the SessionKey field in
    the SMB_COM_NEGOTIATE Response for this SMB connection.

Linux SMB client currently set this field to zero. This is working fine
against Windows NT SMB servers thanks to [MS-CIFS] product behavior <94>:

    Windows NT Server ignores the client's SessionKey.

For compatibility with [MS-CIFS], set this SessionKey field in Session
Setup Request to value retrieved from Negotiate response.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/cifspdu.h  | 6 +++---
 fs/smb/client/cifssmb.c  | 1 +
 fs/smb/client/sess.c     | 1 +
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0c80ca352f3fa..214e53acf72a8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -773,6 +773,7 @@ struct TCP_Server_Info {
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	__u32 reconnect_instance; /* incremented on each reconnect */
+	__le32 session_key_id; /* retrieved from negotiate response and send in session setup request */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 1b79fe07476f6..d9cf7db0ac35e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -597,7 +597,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 SecurityBlobLength;
 		__u32 Reserved;
 		__le32 Capabilities;	/* see below */
@@ -616,7 +616,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 CaseInsensitivePasswordLength; /* ASCII password len */
 		__le16 CaseSensitivePasswordLength; /* Unicode password length*/
 		__u32 Reserved;	/* see below */
@@ -654,7 +654,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 PasswordLength;
 		__u32 Reserved; /* encrypt key len and offset */
 		__le16 ByteCount;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index a3ba3346ed313..7216fcec79e8b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -498,6 +498,7 @@ CIFSSMBNegotiate(const unsigned int xid,
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
 	cifs_dbg(NOISY, "Max buf = %d\n", ses->server->maxBuf);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
+	server->session_key_id = pSMBr->SessionKey;
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 12c99fb4023dc..5a24b80dc146a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -631,6 +631,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses,
 					USHRT_MAX));
 	pSMB->req.MaxMpxCount = cpu_to_le16(server->maxReq);
 	pSMB->req.VcNumber = cpu_to_le16(1);
+	pSMB->req.SessionKey = server->session_key_id;
 
 	/* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
 
-- 
2.39.5



