Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2081419AE;
	Tue, 27 Feb 2024 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040680; cv=none; b=hRvEhuCEWOSUh0g7BltrJjta/5sE9UMeaQmB+612jqS7z95i5FfioqmO1PMAJa4UrjD03g4fP2Qa7INne0cjU/BJ8gJdYWEwc7OqKWeeX8PvsfGkfj5Xqd9K8GCmg78tar18u1epzE84N6WgMbdojaGKPkI3k1k8vxQhDJQi+Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040680; c=relaxed/simple;
	bh=6potrDcIGso/aUjKqj5yxFh0av21AYaJvlLCckl2JrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WScEJr6AXHrTVhLS1OFnVcWxxbgzCaZoKBfvrW260QnLRzwZDxUFf3RF4iQAsxMhQ2eRCR93fjYt8HuQXxofRdFKBfNNA9Kbafk+vLqSSAlEhvCtaLvaBwXNgKtPwTOTIyoe6nyL8NG1S2WyKzAoSiKQta7Dzq0Nv0ULT+4Rzmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1ORVnT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1ORVnT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBA2C433C7;
	Tue, 27 Feb 2024 13:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040680;
	bh=6potrDcIGso/aUjKqj5yxFh0av21AYaJvlLCckl2JrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1ORVnT9snijEno8Yqur5FkeVliro19lZl2dCaVajFmYt4cOSk1l0bc6CNZcEN4Bk
	 qBrnr88rWazcVDy/M8glGzB1RPWdSHi202gAl86H4ijSrbX0L9aDug9GZS1z9l+Lik
	 mTEt9qyJZWKoYg3PD8W+9HHP3MHzWVlRaIJlRfGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 072/334] cifs: do not search for channel if server is terminating
Date: Tue, 27 Feb 2024 14:18:50 +0100
Message-ID: <20240227131632.871577992@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index a1b9734564711..3b07f54a8567a 100644
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



