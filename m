Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF613D260;
	Tue, 14 May 2024 10:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683276; cv=none; b=fO2l3A28mCgCyi9bD9rJFklfGIxK79n3tu7jWBSV0zQUv/LnuSmWUu9LcdkTbGVbCw6O9Rgmb5pElkXYsmVbaG7HpbCYOuRhnLjqPaN0fN9+kP0HSWbcXh/7Tfvn+Jt067Ks8gTkeunGVuFBC2paHRlEa9RZvRww+bfshCJSF0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683276; c=relaxed/simple;
	bh=GyZYLyziwiFVWDxj6n5QXmXEJi9GwgAsOCKsxCbOVqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGH6DlTY18Zl8xSXfQBvpYyJIRmWXsv6cVrDTMDJRrDJvVeIRwZ3MFqA/DzXopTNfrBFSKCfgNDv1h4zSjn4jsxQhRh/ExLMpF4hSp4Rmf7ESYYzki0MmxuHdhrjlUhQZvDjv9ltkmyFQxUndYTku4lGfbEEQfJ2OXsiiHJ7dGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw/9ACYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw/9ACYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85974C2BD10;
	Tue, 14 May 2024 10:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683276;
	bh=GyZYLyziwiFVWDxj6n5QXmXEJi9GwgAsOCKsxCbOVqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw/9ACYtibt6lvixL8w1l2fX/4ljMPv0M/Zk1j42SAAw9OWUzu33EHb54DcgAuUJu
	 4JxvE6IKMjgGXOhqJqC78PsekZQQTzzAG21+4dzwGUw12FFeVpf2m/R+4LG3o5E8MV
	 Kd8fMkgxhWqFuXu29duM/d6X6qq3HHN4bp78sZvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 177/336] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:16:21 +0200
Message-ID: <20240514101045.286597641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 7d42f0c6c644f..ae3623bc4ef46 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -83,7 +83,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
+	res = mode & 0777; /* S_IRWXUGO */
 	if (v9fs_proto_dotu(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
-- 
2.43.0



