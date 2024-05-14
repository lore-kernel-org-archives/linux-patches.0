Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546A4CB2E;
	Tue, 14 May 2024 11:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687517; cv=none; b=D5s+2flbn8bzZLyIPbfinaqr3wwCmnFlcJz2Q3axjhj8uqCabN0Gu7agiIt+GywbD9sV648UPV2Lg9doagEH1cnABke8TyzQYLqU02yE9o+js0F8N2HFi41uh5klcWCe6YtCHTaTOtAP6b3V2fEbzSwqKilsvrnCILa7n1Pzfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687517; c=relaxed/simple;
	bh=GXSqg3PQAF+dXeTcFqwoknT+3eOd/U6cznlAN4Sv3JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiJlGjx6k04aYNFWu/O+2b9O3oRYnSFekWskd6VMWVxpGy4TD4jDrMKYXzLgZHQCIWfy0m0wMvgk+9azDDZCzgltKv6GkniJkgy2fko3dWBmGanPIeyR8O8yljnCnKWmc3EGe+gfIimNO+0j2nckIxqte55ckEjZ1QtukqdUGCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/wig9HI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/wig9HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CAEC2BD10;
	Tue, 14 May 2024 11:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687517;
	bh=GXSqg3PQAF+dXeTcFqwoknT+3eOd/U6cznlAN4Sv3JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/wig9HIXCd0tVXqvEOlQmCTSl/iUBSy9Bph0oZbimgNq2XScKr/0gyZe2/V7a1eY
	 EgNZ/CvXIc6A668SV2+WAH8UdY0ZU2gO5vV/w2PbXJqztLt5YvHQvkXsEVA+jJ2nxG
	 KURWpTE7WL4rvm8UQMuEFckYXyq3CZ9YZ3TSzxKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/168] ksmbd: fix slab-out-of-bounds in smb2_allocate_rsp_buf
Date: Tue, 14 May 2024 12:18:22 +0200
Message-ID: <20240514101006.851265248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c119f4ede3fa90a9463f50831761c28f989bfb20 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/server.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 11b201e6ee44b..63b01f7d97031 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -167,20 +167,17 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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
-- 
2.43.0



