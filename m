Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075E742CAFB;
	Tue, 21 Jul 2026 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665142; cv=none; b=PwyK7phbIlUNlmlXlcedOWiSwD99O7V9EXPATrqfRudeuTEHWBYN46jOPs6HF1RM/hniKTI0p4NEI+ZVdjlQbVSBBBNjw2hxnUHk0tz8V9tu1RDA6MD8BBFA0Qb+9ga8g2lnPZstWA6t4w8EKpsidE8chHeaj7cyvR1rosAcCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665142; c=relaxed/simple;
	bh=IIKKuFCcQP1ccEU150Vr6mr7ZeO2UWAdp1u9nIw3gsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMdDx8IiJduAk+Z+xQEDpGMHGZKyYaG/RwCgFu86S9m9CWDHL2X3NVPZRPdun4bwlxPhIJvWbxXdEKZ5VL9n7ZyXpSz/6m5ZgpaFstrvDSDvKI6D35GjpAsUDcrMB/EzQNNVmnsDDjQ1zklschT88gknXN+sVSbMNnQEoBD9iQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPKqSwQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPKqSwQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEBF1F000E9;
	Tue, 21 Jul 2026 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665140;
	bh=+EdhtOmNt8tBj8i1pLHb/3CJULT82vhM8OpUr2Lpc1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPKqSwQouS4JjzY4iPBO4giKXWvaO2fv7gCFo3JwA75OeJFHUhITqJOfqrveooR9o
	 yUWqJCTi7xDErYlgu+CFAME61kgWhOJ8c2aeD4ZYJKGkAjBuqxXS8nf1dFlE5is8RF
	 UJurZhg7UpOSNtlTtKGUUe0KPlN6D5Mg3/xN+WJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0193/1266] smb: client: fix double-free in SMB2_ioctl() replay
Date: Tue, 21 Jul 2026 17:10:30 +0200
Message-ID: <20260721152446.124278011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3437,6 +3437,8 @@ SMB2_ioctl(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


