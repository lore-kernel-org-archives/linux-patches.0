Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EB4429CD6;
	Thu, 16 Jul 2026 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212043; cv=none; b=aEB1PyJ9BwYEvk5242AqICXCVGII60OVAwhzZHz/rU7MI5VAxTOcaLTgkTCTx7nLla2+vMOHdBALdkdWzrjMV+yNv/xiptlqx0c5dK4hIP2XpDtrXD+dckDMobdbDI3G06+i2HUcQ+IEvDyumA2GfDGMWZPTLDt6tMhnbnkkMOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212043; c=relaxed/simple;
	bh=VTHVIBycN/wjfmorJIk78726yvdSr6LyaUAvs2nvtME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZQapCI/ctSzWFVAybu3Cq9R9m9lxi1a9PPbo7BbyWGfTGZ7QrVd71yJYa/OJN0QwPMES0MpEY0N62QZKajgWgd9Qt9YiH0JKsnQQbyT0Bpl6fhxtGmOo6t9C+L+oY9L48H27LXaoCTH6RZuLBS9g69/AAK2bQNK9kUOs6P1Dy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTZJ0yH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTZJ0yH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0D41F000E9;
	Thu, 16 Jul 2026 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212042;
	bh=HQZfL7gjX8btJIyhhm2aVXPzOrMknTQW9IneYKyF+Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTZJ0yH+bDQnUHa6pVGD22rutlaL035gPDxNBKHFGiIKOVz+ElCTIYaugcKJXGDc8
	 ZF60YsjVkZmtAGYGUeHUbr4WDGQc8dqZ0HQYhs957TJTReUmIg9RvWpNufMdnR/YcG
	 Sj/H5DMrfhoZIZkYU7PaDZyErMOvrQzbC/EBHNWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 176/349] smb: client: fix double-free in SMB2_ioctl() replay
Date: Thu, 16 Jul 2026 15:31:50 +0200
Message-ID: <20260716133037.316676830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -3443,6 +3443,8 @@ SMB2_ioctl(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


