Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F161474A9;
	Tue, 27 Feb 2024 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041613; cv=none; b=cbtL3x3nPh297WRHIEZAh+NsfMZpNuXurievJ6hynWeT9V9rjruNYIPxh8aeP5ThxkGUuzyYA/qq72K/vUd6AztpayfzZcPpuElfjdBt+pjFHp+7HXjSqfpTvxRQaC0ejpu6BF7Gv4jDwtK59Uf5K3XWKOO2YsyceWZubClHtrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041613; c=relaxed/simple;
	bh=J3f7fBpmu8muekWJUG9X/EvzCmWQcDRtTbcoPvAKkQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj7Wf8rnjrRKspX6Dwn5HYN+j9NxFWufya+zHN6oNWZykbL1W6JNV3fqIZsfv4Zo4l07aNR9cIzHjbkTjiTgjSt9N4DPbBa3nry1zKkQLdnQXYIU1xm1aheR91/AUNgWssRQ8FfZlG9WidLLV4tdABs2H3Y5+eocICRdT+dTlCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYXea9o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYXea9o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28E3C433F1;
	Tue, 27 Feb 2024 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041613;
	bh=J3f7fBpmu8muekWJUG9X/EvzCmWQcDRtTbcoPvAKkQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYXea9o2FPkX6dG84jRPlM2tnGVJnTRagKb6G5DwT2itVu8nuHJN+1CMjwmGYEVTx
	 063dJCyJSoad9QRYzM3pMvHHX3/uU+nKEWU8hOPTYA64vvihI2HtMulES9YXmoJQpo
	 uZmrCoPv1PMZEzboN6vLWcsEQZmuise8f7SZOPok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/299] cifs: open_cached_dir should not rely on primary channel
Date: Tue, 27 Feb 2024 14:22:01 +0100
Message-ID: <20240227131626.171867492@linuxfoundation.org>
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

[ Upstream commit 936eba9cfb5cfbf6a2c762cd163605f2b784e03e ]

open_cached_dir today selects ses->server a.k.a primary channel
to send requests. When multichannel is used, the primary
channel maybe down. So it does not make sense to rely only
on that channel.

This fix makes this function pick a channel with the standard
helper function cifs_pick_channel.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d64a306a414be..9718926205047 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -151,7 +151,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
-	server = ses->server;
+	server = cifs_pick_channel(ses);
 	cfids = tcon->cfids;
 
 	if (!server->ops->new_lease_key)
-- 
2.43.0



