Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032733F822B;
	Thu, 16 Jul 2026 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210995; cv=none; b=TjqgIdxvfkQ8bYC0RtXVJeSxoACKElxDfgFnG4OxPpk3r6vQjTjFx0WO38R10Qdx8inkzOC7a8jWnP5FLqbK3i9G8Akt73aixBG7UFDZFvYD16NKdqxX4JJGY/dvKvTQ+YYKrEbarlDNrcVFZnKVX6qz4vDA6f7L7HV3J0WWA1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210995; c=relaxed/simple;
	bh=wmd8KI2t+3q636G012JokZXKVuSt86BRynTEr6n/89w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LissW/GGNmXu9XQpdV0SIH5TVE3cPmJtfSPnNbEpGBBnD2F4nxP4bZAYEJVSEGzWo+ULavo8OAUZWGmpANGmxqfgD8XiLruGhgM5Qoz0+mIVErPQxmd7Jhxas5Ftx8idBebcSYoEN5GSk8HQi2DEsFWOG4aKDog1kyMVuNpbGlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umlVfhuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umlVfhuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7194A1F00A3D;
	Thu, 16 Jul 2026 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210993;
	bh=R8F/uZImoIAUZeWCwbjNmG7PY5dIFCTjiswXHgS+PPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umlVfhuDDWOZhrvDQjReTQCg4dn1YuP7TjoDwjUNxSXX+moI+3nW7XFOSpm0ytx1Q
	 rNdSJWAZFH73s6rQaOsLu6OU2rqPzEqCCtUWbR6gX6jN1qjCwC0rUUWbL9yJGWnTqD
	 0glIJT0zxMztsQYTYz627DE3zx6u1bUViiDDq3zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 232/480] smb: client: fix double-free in SMB2_flush() replay
Date: Thu, 16 Jul 2026 15:29:39 +0200
Message-ID: <20260716133049.837435117@linuxfoundation.org>
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

From: Zhao Zhang <zzhan461@ucr.edu>

commit 4be31c943a3a27a5a0251dbb8f5cb89059ec3d5a upstream.

SMB2_flush() keeps its response buffer bookkeeping across replay
attempts. If a replayable flush response is received and the retry then
fails before cifs_send_recv() stores a replacement response, flush_exit
will free the stale response pointer a second time.

Reinitialize resp_buftype and rsp_iov at the top of the replay loop so
cleanup only acts on response state produced by the current attempt.
This fixes a double-free without changing replay handling for successful
requests.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4351,6 +4351,8 @@ SMB2_flush(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


