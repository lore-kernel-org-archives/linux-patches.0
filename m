Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAF120B3E;
	Tue, 23 Apr 2024 21:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908553; cv=none; b=swJgA526BLKusU5D1Ez5/BEODgIwFXXZVjoCyu1z7HC7lab7C09XnQ8RkLCg8ROPY9PXcpxg5HLC5CO9MdejB0T73RBIcsssyPsCMRmA3wV//ur/KsWdiPcW0684DWrecIc6y+KswCrzGe2whbnIKByCpLbErJF0nL7LOVHfDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908553; c=relaxed/simple;
	bh=2Z2sQUj6p+fZJkaFVZEyWEZKoHqqrUM5vwJzxCneUJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiJq1NFMWN4gbeoCK6XHLrEbHF5ruYQ/+zdcrE/kgDHugfW40OPg2dqNn0UVO1YRWFIrmzwkgjxc+2pw/+yacb+9yCyHPE3/GoxIDbtLRMIvEpcY7weHxlvfhzEs5I5fs/vPBXmupnVFU2SH6gWc6by06g3vrmNHkejvXP+8y1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwX/K47S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwX/K47S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511E8C32781;
	Tue, 23 Apr 2024 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908553;
	bh=2Z2sQUj6p+fZJkaFVZEyWEZKoHqqrUM5vwJzxCneUJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwX/K47SnWlAtFkxDj8624u26uwEQ9Vw+n3kgS+gzm8C8qlrb2fEQ5ZUj26opt0HE
	 cF8WLmILGNqJBu7bD63i3+JUxAt/ET2NR+B5pMcn4tvvNRYXDFH4QNipvB9oqJqFn7
	 XqMtcwVHZcicJV2wTdoXpUoD/yR1CM/laSOXQd5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 155/158] ksmbd: fix slab-out-of-bounds in smb2_allocate_rsp_buf
Date: Tue, 23 Apr 2024 14:39:37 -0700
Message-ID: <20240423213900.885703760@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit c119f4ede3fa90a9463f50831761c28f989bfb20 upstream.

If ->ProtocolId is SMB2_TRANSFORM_PROTO_NUM, smb2 request size
validation could be skipped. if request size is smaller than
sizeof(struct smb2_query_info_req), slab-out-of-bounds read can happen in
smb2_allocate_rsp_buf(). This patch allocate response buffer after
decrypting transform request. smb3_decrypt_req() will validate transform
request size and avoid slab-out-of-bound in smb2_allocate_rsp_buf().

Reported-by: Norbert Szetei <norbert@doyensec.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/server.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -167,20 +167,17 @@ static void __handle_ksmbd_work(struct k
 	int rc;
 	bool is_chained = false;
 
-	if (conn->ops->allocate_rsp_buf(work))
-		return;
-
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
 		rc = conn->ops->decrypt_req(work);
-		if (rc < 0) {
-			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
-			goto send;
-		}
-
+		if (rc < 0)
+			return;
 		work->encrypted = true;
 	}
 
+	if (conn->ops->allocate_rsp_buf(work))
+		return;
+
 	rc = conn->ops->init_rsp_hdr(work);
 	if (rc) {
 		/* either uid or tid is not correct */


