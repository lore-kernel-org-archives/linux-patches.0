Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0594423EA0;
	Thu, 16 Jul 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211044; cv=none; b=Ti2sFFhw5Ari2l51gHnoBvEB6Y/D9tZ7dEyrZDRodsk2XLPMoA3ImL6f5GBn4+m2LrjhOlTNWIfmY6ZRlbXQWq3FFq0Qmaar/lQBhqmaKPtzxV+hn1fRGP0cuLldHtQFQ/w1bCuyDBKxRqqIqodd/0aLUIYhqhQ09R0XJ912+q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211044; c=relaxed/simple;
	bh=M+Qr9YpNgk5wxoYmL6o+Voxq2wWAHCEO2POPWCSPoEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU1xT2YR2BRQP0/QLu+YQroltRWNcFvIN7S+Yfow2UALm4iemTRpILG2QFFqVQyaPX7PfGKB2FLpTpR+rrHggQbI72HsUCTTtiE/kt6d7IpcgU72XhMUQzr0OzKqyXE8qSoyyGebuVS737EC+X8XcSUfweI+cxlxBYDzcl1kar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft0XjmFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft0XjmFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426961F000E9;
	Thu, 16 Jul 2026 14:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211043;
	bh=TkTUTSd6NOXto8SQ0LGTuw6melZV0rEYM1PsmPWkPW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ft0XjmFZjlWGfFNT+2Os+P74SbdMHBg2wHNB4oAJp2KI/PlshVi04NnAauhDKmeFB
	 MGlAfNyRWS4IULT/l6e98pbPTN7Sx++ck+fNTRZbvIMGWtQWCOWuWLn3C75QAnQYFv
	 S746tD1SHpaQOEsjXUss+WGwi+npEUWcpG0js+qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 234/480] smb: client: fix double-free in SMB2_close() replay
Date: Thu, 16 Jul 2026 15:29:41 +0200
Message-ID: <20260716133049.881750199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit f96e1cdcb63ed3321142ff2fcdf784e32cda8fee upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_close_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3617,6 +3617,8 @@ __SMB2_close(const unsigned int xid, str
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	query_attrs = false;
 	server = cifs_pick_channel(ses);


