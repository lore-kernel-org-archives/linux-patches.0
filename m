Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A342ED85E;
	Thu,  3 Jul 2025 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554612; cv=none; b=FBt04WAn4/VkhfvO3Jf0WpKU+iK5aJEZDvlLh6rtDjlX6CtiPmHi6NvvMY0fzKO3Np1lHn+syl7S5HkkZslr0uzh8Xtor2nFZMkQec55oSymCpUAH+ajTWQQWaHI7+wMgFwunCkZmcOxUUxw2Uoq6vTyqwD33t9rFcO+EJkTeYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554612; c=relaxed/simple;
	bh=bN0UJ+d9hO2R2uoJrIS3WZ8XW6Zb53d4I7ZQsckqyMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCVKEsmp3fF1TkMlKZkPFiwOMJXnfcVRITj9R819xrTID1z1k063KpxYZFeXh6zbOsjBDjEavvwp3oNQwFvF9EGtaINFsuVKniPf9QRE57XxSnyH+2NsWS0IKPUimKr9DnIPYyM9k1nKOCFM9Ujl2INIwkPdbFXiE1HqdNZ+VgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Av6Z35DZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Av6Z35DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C3AC4CEE3;
	Thu,  3 Jul 2025 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554612;
	bh=bN0UJ+d9hO2R2uoJrIS3WZ8XW6Zb53d4I7ZQsckqyMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Av6Z35DZCvF6gcxxwta1W1hrTM2n+8pY1Blo8HXI05PpPI3NLuQLA4rFRfY4NgfWj
	 ayDi0DDGIq0rDHADTsGPewsKJkvfWeXvmQPD1dWoH+pkDQQIJrEKCbuthKx+mFsjsG
	 wvOdJmyt4j+RDhlE+BtqM4/iW9dGHjeSdTE7P6v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 003/263] cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in non-UNICODE mode
Date: Thu,  3 Jul 2025 16:38:43 +0200
Message-ID: <20250703144004.418006548@linuxfoundation.org>
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
index 5a24b80dc146a..330bc3d25badd 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1688,22 +1688,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
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



