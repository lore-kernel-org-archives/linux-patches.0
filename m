Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D5143C5F;
	Tue, 23 Apr 2024 21:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908763; cv=none; b=SXMaZ1d/UdmyuqaSIvojh9BKGgS7y++DWIW7O+vTugA7Al5GYZIesEFtMMJVY8W+r6zRDalyxLSshcr+/u8UnJhbE4BG6JlMetMciq0FiGGKbsjhmArcvv4oGjSrWsuKo+41D+GeschyvhotBs5UKdise8JJp0ukhauz3yDiK00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908763; c=relaxed/simple;
	bh=be/0zsiL/AEMbZE7NEPIAtOGv4jyn3g8tCEhDQN21mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN9WNZdf7/VjC2sALm3udx8JL+sX+UKDkFE8jSBCs2Pl3P9KRHe7p6hN0FZCfy+R2AiL83iieXl+atcoViot4eeqw5Agckp5YNv7gYcpELrDIM6V1Yxjfv8ohUZANdiSZ4g2wAFHZLgzqLkzV1D0SucBAv85Bu1Fn2KGyNz9Ymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pn8lsG0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pn8lsG0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDAAC116B1;
	Tue, 23 Apr 2024 21:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908763;
	bh=be/0zsiL/AEMbZE7NEPIAtOGv4jyn3g8tCEhDQN21mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn8lsG0FkE6px7pJWbo0niDYLQ+7JvhyZ80xom3l8irNQhjNFKCPZRYHqOKxWSlQe
	 0x7ODDdXmNvvTbA0qAwAPJv40kYhMEgAr9g5nDBkJEmzSLFiR90Va2qm899AsyyB6v
	 1o6GHBbRhyX3tEBSGaZEq+AArjsT8esdT2zYZanc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 137/141] ksmbd: fix slab-out-of-bounds in smb2_allocate_rsp_buf
Date: Tue, 23 Apr 2024 14:40:05 -0700
Message-ID: <20240423213857.667932968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


