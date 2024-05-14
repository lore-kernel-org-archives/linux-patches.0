Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0473B79C;
	Tue, 14 May 2024 11:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685257; cv=none; b=tFIa2mu3f1BpKsIZje51+VUOMw4wXk0GYdxall7PEMIhqad/4Red9alZEcnKlMm3gWgpQAE9u7jEZY7jr9VHFefxv9HUJSA8ccqF+JXXeHTUFXf+KSvMqnKg0Bd1280MnWz6EbyX4JH4+877rZsNBEbL6nVzo5pH0Fv2fGb2Ajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685257; c=relaxed/simple;
	bh=b5plEFXkoefEnUj2rSpbS9jux63jdF3bkSBaQM2AWx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKZxnObsNsFqMDH8AI8Snh1+AujNCTnq62TOvAYkd0NF3SPVgKB6MnpouuCAv2e3IJSAgrZ83C4Jv/hm7MyXls2nfNHJWaSKOUPtgq/lA9VpYf95endXX8MFhtjduFjXroI7olxX2rH0aqFl9sVFX4N4EnSvJUSPoFHbiSk5rsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPj7ZM1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPj7ZM1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A60CC2BD10;
	Tue, 14 May 2024 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685256;
	bh=b5plEFXkoefEnUj2rSpbS9jux63jdF3bkSBaQM2AWx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPj7ZM1h9LOacqDgH5HiCPEzB/lSkL2Ln4gi7+3O/Z40o4LOu6lC2WpuDQjetT18a
	 JpJWw6hEMWx4gcmQ5Gx/HYNfApuuDCTawSb3h00zSSa3w0kPcXZTb9FyfhOqoMdKBj
	 oWnBJhv6ysObrL0j7knjJT8yde7ReZmowXW7vg1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/301] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:17:09 +0200
Message-ID: <20240514101038.224323296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index ea695c4a7a3fb..3bdf6df4b553e 100644
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



