Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C52D394783;
	Tue, 21 Jul 2026 20:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665148; cv=none; b=aTntVYGfoL/E7Kt6Wgz9moqhx2kaMa0l6zx5RwWZRL2xzGRK44i+V0eqAcERj4uuXkiN1LRyFAbMR8fpHqmUbipYE8orI62JSPqR4q2Ng00RNKwQgeyXb4n3SEnNxq6NtHXcUnSCktStUkcikTOWHa6X6It7S1EACwGTJuen8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665148; c=relaxed/simple;
	bh=GKO/NB4qVsGr8FMlVYvGvEE4FbPPZKsI0F9mkLh7g1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAcI+TJlXs97woBKH9BdQ6vxAieFu94sofKW7JZz9Yh10ckLkkhmeUyMpkIfCVYnQoP2yJirshaHm84E89OY42VDJVyfhr19OL7C7S39mkR6wMfpNriaDwl2HoBp9x+b+k1Z5+IK90/MzJrT+cqO+RAQ1n1fO5ccq90/I5nYW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsmZOMfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsmZOMfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760A31F000E9;
	Tue, 21 Jul 2026 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665145;
	bh=Xo2elYBE3gkn3St4X/Yr+9zBRmuUr8PLDJ3bxP81Gzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsmZOMfOhNjvuxwC33IfUA0tb/FwUb/RLMFiNT/qXWnS/p9BDNcgAj6ZLDSgpJgHJ
	 QexIZof8M/U1NFXb7vVv3wrqQFX5t980Q1M56opwM08ahK+HhDZ1HfHPmtdWkxziJC
	 RDvDnGt4BKBgzb80SO/N8nNxQYmhyMuobczjZesg=
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
Subject: [PATCH 6.6 0195/1266] smb: client: fix double-free in SMB2_flush() replay
Date: Tue, 21 Jul 2026 17:10:32 +0200
Message-ID: <20260721152446.170829106@linuxfoundation.org>
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
@@ -4350,6 +4350,8 @@ SMB2_flush(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


