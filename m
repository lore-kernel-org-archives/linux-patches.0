Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0772EE29E;
	Thu,  3 Jul 2025 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553920; cv=none; b=YUwHk6YioBcXxjL/hVKnetxkRnR0lL6uwBQQwyVen5TP8GEtjl6EF3HcPpYGGohjb+g2JrvOZDspZT2asOgsBzGsr24uv9pmJqJdUn01we2dKNjmGRGPDN39JDpaj1JipWaRHupjPcER9DyCZpztU4fOIHARjeyprBhTh98pnB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553920; c=relaxed/simple;
	bh=nFStz9c8ztYQNVijCtf9Y53vwH+vCbzsrAUOSkwojj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJhxiRrOGqzpCjtwH0WW0ahYBShqHfPLMYfQdYfkXugHjsSQ5P3nZ6jFAz9wVGhR1jZMvnX9HXpPoU/u5ocFwqsRLRDURwVyFH/DRcL4i6jMcJZV5xjdNDRRBQvoJ4jIrCAC5xPwLQhSv2eKXyH1Ee1ZsDcPM5UO90ChL1oGvNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlFIHjLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlFIHjLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A346AC4CEE3;
	Thu,  3 Jul 2025 14:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553920;
	bh=nFStz9c8ztYQNVijCtf9Y53vwH+vCbzsrAUOSkwojj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlFIHjLYWXSN41G5khGQvSA/or29CVoJSls6Cz859MqXgoVgDnpw4qbLtLLjcqLS+
	 PcBu9hqB0nSYYG7ujoey7OiZNEr9tow683qhbTA9sa7lt3JlHQRdtCFujaabOp+GNK
	 nLzVp44nAt9WxxT46t0AIZtp8R1trx1A1FxZC2sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/218] cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in non-UNICODE mode
Date: Thu,  3 Jul 2025 16:39:11 +0200
Message-ID: <20250703143956.097771325@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 830516a9e03b0..8be7c4d2d9d62 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1715,22 +1715,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
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



