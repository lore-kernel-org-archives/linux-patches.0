Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418937F48C;
	Tue, 14 May 2024 11:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686833; cv=none; b=Mcx7SX/TcDbjXx2WvW0N+jkw2p7nzltWKhv5srIhbqYUYNjCm19shsFww4SOHEoLt3LkDnnFqFjlnEnFjQ6eXlR7nzL9zUQf8YwSmgbrhhWkpKEwanRq1XALuxbKY/QPU9Pz9A16QPyeWnRzdj1nxVl1I28iqxVcCoTzdOMbJZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686833; c=relaxed/simple;
	bh=/r+3WtJTy6MbVhdO6Swo+TJmrfK90+5WtAHDfuhihlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhk0gzXExcVqpkaaBHycfTtO3ipxMlIWnJE4Mb5FuQIkzrHWN4VIUfNoaCubgbWehpcArtRUJyIEHfxQSn12V7YamcfB29JC2oDqtl0YepNLT4ge4QJchkzATpDbLY10eoJG1yzGS25w/kIfbze+7Lolp3R3kJ3wu6i7ti5fI3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSQvrX2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSQvrX2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1935C2BD10;
	Tue, 14 May 2024 11:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686833;
	bh=/r+3WtJTy6MbVhdO6Swo+TJmrfK90+5WtAHDfuhihlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSQvrX2EqKcnueQWRNfFGm1Ac/TXA8c1V3tlVDWLgrG6HfEsCFVzKi61T/0WE9x3r
	 Krmp3ws9kxURxhHSDdefdQfJ+9ScQ26nIhybciWgJnZkj//SX3FmTDG7y2hFI23jmY
	 ptMVryUilM/XdMuh7NcfuHQAJIohEYlos9syucBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/63] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:19:58 +0200
Message-ID: <20240514100949.415069095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit cd25e15e57e68a6b18dc9323047fe9c68b99290b ]

Garbage in plain 9P2000's perm bits is allowed through, which causes it
to be able to set (among others) the suid bit. This was presumably not
the intent since the unix extended bits are handled explicitly and
conditionally on .u.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 72b779bc09422..d1a0f36dcdd43 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -101,7 +101,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
+	res = mode & 0777; /* S_IRWXUGO */
 	if (v9fs_proto_dotu(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
-- 
2.43.0



