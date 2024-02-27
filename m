Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDE713B2B3;
	Tue, 27 Feb 2024 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041859; cv=none; b=K9BhahEr4Aq3TaNYI3m+EVbqmhLybKdltaK0LGnALs4a7UNlh7c1cJA6ZoFFCM8qfs/eQAei4glrkX2JeQFFsUI5hv8PV/ciuwpv3RXKhl0hLHPoG5ZbYnSwB8jRTV/nkUPIxspDf2TBT/M0hnYvXa4HRW7w2NX+nxGpil5Lt+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041859; c=relaxed/simple;
	bh=0RYbqvGwM7tPCsedhilQJUamBLwitS77yrIoxYuG0WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sem1r8wEiQ1DvAiP/K+1swESo9ZzLTJhQMfV48t4KVk+3jJrcRyymPaAvIkU/zHrKsBQFYZFfXtYBoExyJEIo9v79XcJNPIib01exyv1lM1kAXD26elD5Vv4MkzEus423ZG1u38FDAoAhvwlUpVfTYBB0AfDyF4G7ZTNYmorngk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvX0rPJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvX0rPJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5B5C433C7;
	Tue, 27 Feb 2024 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041859;
	bh=0RYbqvGwM7tPCsedhilQJUamBLwitS77yrIoxYuG0WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvX0rPJTrWerez7tT0ygMjSr4dM/rR21i4UQxzLbArSx7wBAXHjyTSD/jpO1CHajC
	 VCBedNVEk5t1TrqHXXNhg3r0VvndxfZipPbkteVzY7ZDlQ2ZO07689D/REQrvmUBkv
	 N9BKAypLz/E5aSQIzfjYkCFs2ze8CaSYpsn80xEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/299] cifs: do not search for channel if server is terminating
Date: Tue, 27 Feb 2024 14:22:57 +0100
Message-ID: <20240227131628.072891505@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 88675b22d34e6e815ad4bde09c590ccb2d50c59d ]

In order to scale down the channels, the following sequence
of operations happen:
1. server struct is marked for terminate
2. the channel is deallocated in the ses->chans array
3. at a later point the cifsd thread actually terminates the server

Between 2 and 3, there can be calls to find the channel for
a server struct. When that happens, there can be an ugly warning
that's logged. But this is expected.

So this change does two things:
1. in cifs_ses_get_chan_index, if server->terminate is set, return
2. always make sure server->terminate is set with chan_lock held

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c    | 4 ++++
 fs/smb/client/smb2pdu.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index a20a5d0836dc9..52f7a411e2bbf 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -75,6 +75,10 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 {
 	unsigned int i;
 
+	/* if the channel is waiting for termination */
+	if (server->terminate)
+		return CIFS_INVAL_CHAN_INDEX;
+
 	for (i = 0; i < ses->chan_count; i++) {
 		if (ses->chans[i].server == server)
 			return i;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ce2d28537bc8a..97fc2f85b429d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -178,6 +178,7 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		}
 
 		ses->chans[chan_index].server = NULL;
+		server->terminate = true;
 		spin_unlock(&ses->chan_lock);
 
 		/*
@@ -188,7 +189,6 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		 */
 		cifs_put_tcp_session(server, from_reconnect);
 
-		server->terminate = true;
 		cifs_signal_cifsd_for_reconnect(server, false);
 
 		/* mark primary server as needing reconnect */
-- 
2.43.0



