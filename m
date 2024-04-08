Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD3F7D414;
	Mon,  8 Apr 2024 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583795; cv=none; b=FUbni7hkmwIRFef0vk9XnxF3tIsQNs7XyhZMHrsuI7VVE4dxfeZ/fgB+IfN1irBUMkSKZGj1zo2kHS4Cylul7QzV6pE4qFGsThY9Utl0TK1vSP0j8hNZS0zoW9pCerNb02GjmfUEY/eGxHVTFmdY3C7/Q+IHVlcTTB+cPeBEF2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583795; c=relaxed/simple;
	bh=MbDm9GNz0xx20jrp5tLnIXPyOVqS26BwuTJKeMLQ6Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBciqDcRvsqMjA834nlGyOaS1ldTONabWelbFjbW+nnsXhm36WH8Ku7M41MbyYUaHmhwbWWWw0XFI7q8O4ZA9zfk7jCzBbtNwjARFv9Iufw/lfL2N+CSR3dtXgZVXAGSAgX3FS1AjisSPl3KPe/YFpq9QZebkLSAhc90SNjSXD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRzObNjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRzObNjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC5CC433F1;
	Mon,  8 Apr 2024 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583795;
	bh=MbDm9GNz0xx20jrp5tLnIXPyOVqS26BwuTJKeMLQ6Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRzObNjyYhaCwNbm0FAMF3EPdqLq3WUqauljSzOEcwhGgDHASF+dKY9FTY45KLxmX
	 iJmNUCfaQzFotvFCUoE5gdUOmcSEFCY/cIGNutccjFiMlZx3MchTXQQzfNZZbgtxJ+
	 WQVjPYVk3WfiG43VEVKlhSJKLXC3FIyKZc6uG0t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 234/252] smb: client: fix potential UAF in smb2_is_valid_lease_break()
Date: Mon,  8 Apr 2024 14:58:53 +0200
Message-ID: <20240408125313.917050937@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 705c76fbf726c7a2f6ff9143d4013b18daaaebf1 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -622,6 +622,8 @@ smb2_is_valid_lease_break(char *buffer,
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			spin_lock(&tcon->open_file_lock);
 			cifs_stats_inc(


