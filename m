Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5A2690D5;
	Sat, 30 May 2026 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160415; cv=none; b=nB/QAQrorYhdTDZqQ0fYCD9Jk/e5TJEpgJiWnbVDYTcnWVIOa/g61wp+DeV+CrZeEjgij9yp1T9DL/RbLFIBPng+LzCy47w4sQS5J9IOUJa4OP3wpLqgWiwMZULUuk8qrtU5aCjdcWYW/ybmi2gzSB4JmEoInYgA5ou7QDiZ20M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160415; c=relaxed/simple;
	bh=irpIlgnaVHAPO7a5fZtfJnKlDLByA84ZpjQOy3aivOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCD0YOyc0pp0OL8tyT55PTIdx8LOHiKkNx0FWEyTU0z/KrxNNlawNZO8IuYyy4pVcWuNLLXUwh/1f62ct02plRRDFDFnHIABRbk17cQkV4AT9+nTZ7WDxHoeEoY40QrRSQ+6EMww3UP7+pGh7tU2dIuKMtLYpG9NfZM34+mMBoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9IC5Ago; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9IC5Ago"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254E91F00893;
	Sat, 30 May 2026 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160413;
	bh=OxU3zjOEtvGCIyvmPOHcypM5dpvYzH4buy/vnjR3bAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9IC5Ago1z7fI8BqJFpJf+xqj5d5dBTBDRCUueOSxgCdWbHdd8yo93/f4JDDBXjrc
	 lPwjyktWgUCJgN+FwaHgXoB+ErTT2x/wAjPMZvPXdComD9QYqSXkLvmhBWP5PMazol
	 53kJEzdua+KbY4rzBoN8D/wd0VFcR3Aq1CsSYhQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 331/969] cifs: abort open_cached_dir if we dont request leases
Date: Sat, 30 May 2026 17:57:35 +0200
Message-ID: <20260530160309.521844920@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit d68ce834f8cf6cb2e77f3331df65166b35466b53 upstream.

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -228,6 +228,14 @@ int open_cached_dir(unsigned int xid, st
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "%s: Oplock level %d not suitable for cached directory\n",
+			 __func__, oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));


