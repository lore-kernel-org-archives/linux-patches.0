Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAEA2EE97A;
	Thu,  3 Jul 2025 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555493; cv=none; b=elAokwa0OJ8KbKJT9SyN2WOQdeWQ1SJxkHfF03Icbl7sZxysB3TydI8a/YaXwS04QKQPmrXZgToOAvVrw8ikwFFZtvGa/5HEzRtwO5AmqMhBPTgHQDt12BJdEVYcOCULzobiwoM1R88u6XmsoQYe5Ww+kQ4rSCNqoHlDFCCGIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555493; c=relaxed/simple;
	bh=r2jIh7U2mRvNPdIDNp7I18PD0NWTUZMpWpM0/a+L/es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvSOKZjc9qChxaH2JKzlc6qZ8/ScjhYGZ5RI3a8r9Ixkosb5UtfSinZKsrc0GAp5Bpx76ZMf5GoaHEtpvmruyANvId+yVaq/r99mpSI3icdJKBalVkFbCSlYkkFFpmCKvdMQuTXejZJgvozzazUY57ldaJa//9VPsGgtcUV7hOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciU4nixE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciU4nixE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F967C4CEEE;
	Thu,  3 Jul 2025 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555493;
	bh=r2jIh7U2mRvNPdIDNp7I18PD0NWTUZMpWpM0/a+L/es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciU4nixEl2LqhwJxO2GILQtnGBXPQ0luypE0sIe1yMqBeOoMMjBfxpniyMK0Za5+J
	 VMOF5FnIUaB5mmR97jqQvoGUeMIPkQU/qGgFrMjdvyf6ZPwl5LGBX3iBYY/ADUBZvj
	 0Thfzb//DWGy/tl78h+g2p04Vrr6LSQohE9fFtnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/139] cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in non-UNICODE mode
Date: Thu,  3 Jul 2025 16:41:06 +0200
Message-ID: <20250703143941.317070443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 6510ef4230b68c960309e0c1d6eb3e32eb785142 ]

SMB1 Session Setup NTLMSSP Request in non-UNICODE mode is similar to
UNICODE mode, just strings are encoded in ASCII and not in UTF-16.

With this change it is possible to setup SMB1 session with NTLM
authentication in non-UNICODE mode with Windows SMB server.

This change fixes mounting SMB1 servers with -o nounicode mount option
together with -o sec=ntlmssp mount option (which is the default sec=).

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 81ac4196bb743..c351da8c3e2ea 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1740,22 +1740,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
 	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
 
 	capabilities = cifs_ssetup_hdr(ses, server, pSMB);
-	if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-		cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
-		return -ENOSYS;
-	}
-
 	pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	capabilities |= CAP_EXTENDED_SECURITY;
 	pSMB->req.Capabilities |= cpu_to_le32(capabilities);
 
 	bcc_ptr = sess_data->iov[2].iov_base;
-	/* unicode strings must be word aligned */
-	if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
-		*bcc_ptr = 0;
-		bcc_ptr++;
+
+	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
+		/* unicode strings must be word aligned */
+		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
+			*bcc_ptr = 0;
+			bcc_ptr++;
+		}
+		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
+	} else {
+		ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 	}
-	unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 
 	sess_data->iov[2].iov_len = (long) bcc_ptr -
 					(long) sess_data->iov[2].iov_base;
-- 
2.39.5



