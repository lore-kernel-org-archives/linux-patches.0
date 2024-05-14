Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3422B139D1C;
	Tue, 14 May 2024 11:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687062; cv=none; b=Ve2Y/GXOxnOcVFC1mgeG+GPq3+Upt5vzJzxsS4977T4EhmdGFX2cxWqWrgNny1QN2amK2aYy1n0oWtH6YVwJEWvc4GxM57nmsYHfqgOoUvg57XA+UKHhTxFUg5xoIlF3ZC7qIghEG0XgIPaR4xihW2srP2+svOLceShTTCYSnJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687062; c=relaxed/simple;
	bh=ClI0OR3zPoaBVn/w2zalGJX2bScj3wk5I8uDs9i4v6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taZkImJ+b6EafCpvwO/UKHpVG9IXEMVx9t7Vuft+6N0e3y/gdzi+4Uj7MXc1DGtAMfE5ClkDP7tQ2tW8f+f8WEz0124lSEeCkzY5PuBFIgIJCmVKQaFpkcq5cVCoS9cYLQ+lXxbgmvXleynFVsLrEsr2FCbRDzHTAgl0/RhGRPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyAn2sjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyAn2sjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD07DC2BD10;
	Tue, 14 May 2024 11:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687062;
	bh=ClI0OR3zPoaBVn/w2zalGJX2bScj3wk5I8uDs9i4v6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyAn2sjPLGc5XC5xficeCzAUsK0Yryc6I3dvwkrhDHrHVJkbpY86W4dA8MEIBZxxI
	 7oJPj1iJo/fmVH1qq2ieaPg5n+R+SjU8KrRX9q4U8FgPY8dofzuQuROZ185wGaKtNP
	 FWS1PmsU0XxTMtnyvJPhGLVWs7ihma7TOo6QHuOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/84] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:20:02 +0200
Message-ID: <20240514100953.607103004@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b82423a72f685..b1107b424bf64 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -86,7 +86,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
+	res = mode & 0777; /* S_IRWXUGO */
 	if (v9fs_proto_dotu(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
-- 
2.43.0



