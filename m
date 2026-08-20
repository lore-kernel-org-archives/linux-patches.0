Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87647D474;
	Thu, 20 Aug 2026 16:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243810; cv=none; b=By+w2TSxIUwuhxvZtm8mVXhMvSwkbSP62qfte/t3kW/a8O9gRb9DlWcx+3fVGUkfysCCMb37gudDytVmLQ0SpebTOUV6u+7lZ5JISML/6G8HbDJo6y4v6UzBQPV9AYvDYoggPOwKvLe21SmFnM4Cl8roqIh+ILJTUsEVakUGEzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243810; c=relaxed/simple;
	bh=gyhaFjKzlrxGSS1fiXBdxR3pZFbcFKlFUEQKEat0THE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBZmuXKfsPEP9PlGttkAQzKMzT2uw2fnA/xJzuH7Y1t2qwb2VPTbk2psPMuc5Os6zSzCxy2bifAErlHam1HfMdnG6XNaUqxIo8CANvTob6dLxmgEBGVI6xJBvHjOttrE1K7AMx4JuWVQUbsM0rXE4bo5kKHmWoe3Ewv5smNoD+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSVCpA54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSVCpA54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77681F000E9;
	Thu, 20 Aug 2026 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243809;
	bh=wc5Jqe4eXcrs41fvuvLfQGjW4bqcqasY61aPU+T35vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSVCpA54QGqN06j7TjK/mInhCBDTguQ1VscgCE/iOh3kGCVFWCHgj7AGDfla/Q6KH
	 0R3WV6VjHNwVHHp0oJZwiU9FHuOKtrqqxB2CtJmDSqh8IUCP7Vev2Q1Aa+48f0fZXS
	 2arM/lb3AdVRPTG5fk9kuVTEOhp8bt8aQcfSI170=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/272] ksmbd: conn lock to serialize smb2 negotiate
Date: Thu, 20 Aug 2026 16:56:47 +0200
Message-ID: <20260820145238.290248741@linuxfoundation.org>
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
 fs/ksmbd/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
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
 


