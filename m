Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAC6424651;
	Thu, 16 Jul 2026 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211057; cv=none; b=oLRyQL40AYqYQRtUNGexK7zl+EJA4YWh7My7TjebnUHSsin7Z3k3phw+5n95oxy6Ozw+i4IS/jk1V3geTvtsN777w2abvB+ESVZRcy2oFYyiCSOHzwMmSf8PV8owk3qGC8AHNuWSM/8h/H82JFZHw2XKvl3mtQrfehqdSynkHv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211057; c=relaxed/simple;
	bh=YuaRpMkS5E6IJxl/RK3Bae3JoccImfmg0fnNqtpUnv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBmb0lxWKHQd+ucXqVab0wJrPhIkM4iuphp2VB5V5VTrOvsv0b7ykqR7XP3StPokhwG0IC4JRcEOYBMG+KuC1BetkTOqz4f4u4U9oIw0H4Tuq9pT/FIRZpSJznHNzSgJKld+Zg7URaWKmWos0VLbn+j/xA/hBPqSAXmSU5o5rJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/UYzvuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/UYzvuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC331F000E9;
	Thu, 16 Jul 2026 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211056;
	bh=yxdNcR/0sm36T5HVacev2Uwo8DUTAsGRDtBcVyDnWQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/UYzvuG+1dD3PHMyMHLtUd2KEBqjKuZp+VC2bvfOE6UxwNIeSHCOp0/pBv3VmZeJ
	 1+PkWj32tUH67lQc7fbsziccgoY1W0Vc3yCJI+ph5Te8ZiipQrmF6VslWvmepRLVep
	 fUBJwovr4DghFBLBZL3s5AyC3FLUS4W/2XPc7gAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 229/480] smb: client: fix query_info() replay double-free
Date: Thu, 16 Jul 2026 15:29:36 +0200
Message-ID: <20260716133049.769513877@linuxfoundation.org>
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

commit 2a88561d66eb855813cf004a0abe648bbb17de5e upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_info_init() fails before the next send,
cleanup retains the previous buffer type and frees that response again.

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
@@ -3821,6 +3821,8 @@ query_info(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	allocated = false;
 	server = cifs_pick_channel(ses);


