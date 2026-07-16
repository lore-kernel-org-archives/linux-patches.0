Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD54306754;
	Thu, 16 Jul 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211052; cv=none; b=dzoFbhcST3FhU8yfcrz2uD9IW/+f+WC3hkaB6kzcv32h/dUSr2ZMELfAl7D2KQBtQW8f4qC8yt3IjQh6+wAFQeg4YDZNVgwTpdhdazHLhctUokVb3wGZyVSyJ+Pj8fDrlOVvIFsTfAEg6Z/7P496jle4lAmHfCVjvnXaLOioxeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211052; c=relaxed/simple;
	bh=Vihzv90okVGC22qRsSyPY+xWAVHi6fMEtJwiU3XifCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQwXL6+SHU2iNgGXMKxPseJgj5ZOSynrzcZh9kZMrI9Ild7Tv9Pvq/rex0jb5esCDnBCbp2a6el+TDMGE7cL51xr3sM1k7VMStVotI8RqTIYflZZn65rqpzekoQ/1dFLCbGweSTtFzBTaPCXlT9OzDQw7mHrxMHOXZFg9LHBTRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7sRMgWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7sRMgWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267271F000E9;
	Thu, 16 Jul 2026 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211051;
	bh=KPkmzBSUrpxbTuwusLwDD7HCMW2tD96LeFO+czCKLag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7sRMgWLUbNxCX+Ei00qTXrjpF1HpdZ5CiXHFmO9NzoDyFNJ9oQ243SruxdCx9WeL
	 5Z6KXecYNEE7tiXUalsY3HPhrDr7pC0zcrLUonc6/uH8BD0acprXNh3kJ+unE2xnTH
	 4MYx74bWn6DUBi6pBC9tBR8Pv5eg7T+oh7MJYvAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 237/480] smb: client: harden POSIX SID length parsing
Date: Thu, 16 Jul 2026 15:29:44 +0200
Message-ID: <20260716133049.946817258@linuxfoundation.org>
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

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit 7ad2bcf2441430bb2e918fb3ef9a90d775a6e422 upstream.

posix_info_sid_size() reads sid[1] to obtain the subauthority count,
but its existing boundary check still accepts buffers with only one
remaining byte. Require two bytes before reading sid[1] so all client
paths that reuse the helper reject truncated POSIX SIDs safely.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5230,7 +5230,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


