Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AEF423E83;
	Thu, 16 Jul 2026 13:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209566; cv=none; b=MS8AGFPIyJRUdhllFtaLv7Q33idN59qm6GPs2du6guD7L5upQIOQF/BhHZFevEdABw0hIgH08S2tBGPHEW/qFtRXLIQj9goYoluKte3QIVqPaFcG6WEL2hGiertDnob86Nqcmg+U3GdxrKOm8WI/Se+vxHP4Ihi9H53Pc4WXb/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209566; c=relaxed/simple;
	bh=V4xt7n/oGQtTDBydxJNt5ZjqM8jq3p4xNGRj1Cktdv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gteZvfIEsc3ymbGgF88vXlZ3j1MyltP2l9UCGE2mtz3a27yyX3YqOYeiYRiI1VP7n80UzKWsb4ZApvGjIRTOQeAwwX+tJQBmcm73aTkockTXnlKsveXrnUDTk8YziHsH3VPFwln8d1iZvlpK9lMtQV/YFDFbuRzCq45dcbAb5yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jR5uck+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jR5uck+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FC21F00A3A;
	Thu, 16 Jul 2026 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209563;
	bh=ESKCmLC/dWe2xsC8pSrhnLgYE/ytPxLGaw3CInEkiDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jR5uck+sNDlP99VfjOWD+8TS1et0oHBM1SONosrzyB5JoHKqMhrzMRULd4FnabP9o
	 b990+14CD1sH6rWM/vNdWMrF6zobT/J5b1Rzrl597tWJgjAcB2A3B7axPSsBD8aPE4
	 y2RXmx7prQPiX/u04BVe6dR1IVRlYAnjfVyBz/D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 233/518] smb: client: fix double-free in SMB2_ioctl() replay
Date: Thu, 16 Jul 2026 15:28:21 +0200
Message-ID: <20260716133052.919401018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit f9bbadb6c94583e3b4af1afc449bfceb1d1ddec9 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_ioctl_init() fails before the next send, cleanup
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
@@ -3505,6 +3505,8 @@ SMB2_ioctl(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


