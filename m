Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FCD3403F8;
	Thu, 20 Aug 2026 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247104; cv=none; b=Gxqc2FQMIqAHESExOwJqCk8hpedGqyKCGW++LkX97shNRY2pZpXGngs4XLjhDAtE3PYDs/1QeEO6jhcbI4k4Dlk+Cw9KDDuTKegdjopDe9MHL0i1msNO41ogO4zO0BerWyjSCPu4URiw62Eynmb/tneVRTvE7Hj+UDtEFBpVZes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247104; c=relaxed/simple;
	bh=2UGAVrVTgprJeLhnUA8N7l5eedkJkj7sdwGEzzxTbKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzDd6MQ5kuAcG+iu/1xgpkKIxNuzIVy6ntIQLgMV4D1mizZAg0x52Y4DUDVfxnlutyLC87H9WhTjBH6GLedmE1YYDaaPq4UcOnPKoEZZy6D1lIIcgWZMW87zDDp7TQ5h7HhpGVPozQX4qo8foVfEE+eK7SVdFN1qr55NlMu/in0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYvmo+h2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYvmo+h2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3F31F000E9;
	Thu, 20 Aug 2026 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247103;
	bh=6jNYHvceJFlZoumiVlFPIWUpu/sLvcj03m1dKdie05U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYvmo+h2ahkSMBBd8hPgJqfCx0X8Zonrhkou+LLGsreEbnaw9d2HVix3y0NM/XpoK
	 kcmeEAcYgtuhiay+Bxk8/VIJqphjQMxBwCz1qyD+DhtT0/7oAR1C9dl7cuZN6GXuAx
	 to0ui+IqMD4uRogY1ye3q8rEvfErEG7iJ6mdpj9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/220] ksmbd: conn lock to serialize smb2 negotiate
Date: Thu, 20 Aug 2026 16:55:41 +0200
Message-ID: <20260820145228.011669606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1120,6 +1120,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 		return rc;
 	}
 
+	ksmbd_conn_lock(conn);
 	smb2_buf_len = get_rfc1002_len(work->request_buf);
 	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
 	if (smb2_neg_size > smb2_buf_len) {
@@ -1270,6 +1271,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
+	ksmbd_conn_unlock(conn);
 	if (rc)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 


