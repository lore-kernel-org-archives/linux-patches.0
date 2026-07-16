Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C142A172;
	Thu, 16 Jul 2026 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212053; cv=none; b=MswFm6PYG2wyN7MT8CHiHUoEKvDQULqQ/gwMjmk+J2VVxC5RSElqpzMzGe/806SqsJYdEN49RlPYiyFdcgdNfpT9JKbNCyTYM6/Z6peCOKOUXJ+Dt7B71lzS1tDZTfYFCelOO9hW0Axnjrdnz99J2Fq12+KM5lKiC+6jyMExE9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212053; c=relaxed/simple;
	bh=NGP8kc1tEN0irJPzo5uHuohg3bcKmTYSPQvu/isZ42Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez/1iBbjxTs30IH+9raBEFEEabGscUF5vgtV7JPU5Il7nWixNnQ8cklHapAtvfqiTNLitJExUYpIws2GnuyrG6iOfRw5FtTkRuP8Zxr9Xkx42X4Ikl/t00tzABd3GHOHwOMGiJnR3bRBbvyehZaTevOZD18G3KLoLEQWPyvEZY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjcMQ5UN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjcMQ5UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F363A1F000E9;
	Thu, 16 Jul 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212052;
	bh=l1lhn8wrfnU1dx8D+0Mvvo2+7C+m+h6Wpjd4FNBgU/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjcMQ5UNmOf4VASviiMl8/9KZK+QSqvi0980DsRp6Zoa8J7DMgnbaTLPhPZWnPYJn
	 Kmo8HTKpSB3bVcas5+T9Sil0DeJP+hzTFQwy/Ti+/UMAAV35mrhTELEDcvUy9iszTd
	 9WBN5vyGO8K+ff05M3G3yaJzB4AtRtqH16diVoLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 180/349] smb: client: fix double-free in SMB2_close() replay
Date: Thu, 16 Jul 2026 15:31:54 +0200
Message-ID: <20260716133037.406028925@linuxfoundation.org>
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
@@ -3635,6 +3635,8 @@ __SMB2_close(const unsigned int xid, str
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	query_attrs = false;
 	server = cifs_pick_channel(ses);


