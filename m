Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B6C1D54D;
	Tue, 14 May 2024 11:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686416; cv=none; b=TQz8CDBgUBzF4x8Loob6iVVoRYkidZibYS3k1TnskutJTVlK3fv3+PKL0+bPmhdgFuHsFTiResrAAofHS1TM5dx/jMbN8+Hdi2r4v2jyK3eJem81AvC/2WSekedsL3fFBxpNM6mCpShRIzeyVm4X4W7gBr5h26rv2nq0EGEYpkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686416; c=relaxed/simple;
	bh=gcVr5uD9pRFCh9V2BlbUBo7Jzuz6q6yUF2qmKqS03l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IllbNTTEGhQw7kpkcoBT6+Ky5z50vLKuxTzo/2755khKFGmo3F1hpVO0BsD4tbUYLFg1NqkXCSKjtfHF7643RBAASW98qS8L3V3Fx9XbRHesGdK0AS9c+zvNYbIabnhHo08aseArvXfoq5QhdsKZlYxkJ394PmCMh1ZgJQQqASI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VC1iq8HT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VC1iq8HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1045C2BD10;
	Tue, 14 May 2024 11:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686416;
	bh=gcVr5uD9pRFCh9V2BlbUBo7Jzuz6q6yUF2qmKqS03l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VC1iq8HT6trC5EW+zRaTJXG8pKhp0ZQM8KIyCJ7U3+2JryDrW0UrvYQCRPbBZKOC4
	 txOZs5xa5i51kZSEnyF0bKRmLP49gQTHMxkZtZIDFoiwXGQqmhLipqpvjiQ3K8KJbh
	 hFaK3+71X2BVsZCfFvj8XKO9fZU7VLtXHauieqBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/236] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:18:13 +0200
Message-ID: <20240514101025.342938704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5e2657c1dbbe6..a0c5a372dcf62 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -85,7 +85,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
+	res = mode & 0777; /* S_IRWXUGO */
 	if (v9fs_proto_dotu(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
-- 
2.43.0



