Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AF947F2C3;
	Thu, 20 Aug 2026 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248490; cv=none; b=tjbaLSKEpYdBIHcZjBB4v7FxWEVV2+h2rMz1vULbpbx51tKUDZ7Gl5QQYxjhzFtxBMPWcyOOc06cVPDxj+htUA4ukU9/4sYRef8PKp3NcIJcJqWV0QrwL+EojLZhrWayYD1Vky9XDcDg9i36xfF+QDtEQOB3yCTHhI0sTw+P3AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248490; c=relaxed/simple;
	bh=d0BiYZFq1MiYIHarsnFJp6Btnpw5QwefTNNt1aTPa4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6yjSXesiiRk5an4y5yOQa0iyjw34IMnCeE4HMpE8N98c7KvDc9gOuv8o0Av0VCF/6IfhOka9NhGnaCvqikdq2snvDE1T+i52t/INC4mjbv+uUAfZSwm3rZc6Yfc4DIskGp7theB8373DWf6FNamEuN1scMLuHrfzeH/rLsSRBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhxo8iF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhxo8iF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AF61F000E9;
	Thu, 20 Aug 2026 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248489;
	bh=MTXe+J80niaNhZYoJn7NCGn1VfkKwrgLkKawGquq5gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhxo8iF8bh59PzqMgN8r9d8qmSj40GgPooBU+jxmULYeThecu4CwtR2BVCu/8mG03
	 Rv8bCyovBzG2xN2gFHofnr95zyQtwex4YCDC8nUF66Eu9CtMDc/O2fVyHyB/3h9BDR
	 iR5CL0lbyTckB6buzK9LCczUr9//I3HWTqS6ADU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/303] ksmbd: conn lock to serialize smb2 negotiate
Date: Thu, 20 Aug 2026 16:56:22 +0200
Message-ID: <20260820145300.841396171@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fe4ed2f09b492e3507615a053814daa8fafdecb1 ]

If client send parallel smb2 negotiate request on same connection,
ksmbd_conn can be racy. smb2 negotiate handling that are not
performance-related can be serialized with conn lock.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cb469993b3a6 ("ksmbd: reject repeated SMB2 NEGOTIATE requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1126,6 +1126,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 		return rc;
 	}
 
+	ksmbd_conn_lock(conn);
 	smb2_buf_len = get_rfc1002_len(work->request_buf);
 	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
 	if (smb2_neg_size > smb2_buf_len) {
@@ -1275,6 +1276,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 	ksmbd_conn_set_need_negotiate(conn);
 
 err_out:
+	ksmbd_conn_unlock(conn);
 	if (rc)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 


