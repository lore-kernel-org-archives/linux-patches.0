Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A5D3D3302;
	Mon, 17 Aug 2026 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973869; cv=none; b=OIcTwTCu5emaq/yWAG97BtMIHiD7DIDFfezbjsz15YKuss+KtuVICefkdY+XqRKwbggpMIvRUDL/LbNBdrWzxDj5h0+SwTtKILjbRMya78W5aFV317Wa2vPFLFX3zCsvB8M/MX4R3/k6y44byldWjOXwUx3xPaM7/E9Bxw+Yqr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973869; c=relaxed/simple;
	bh=EU7+EVjgBelsUZyhtG1DYBiurIY+HV92Mxh5YoYUjdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zel7bF9A6ezG2fTClriB6KNUJpISN/M8f9ezUxmEDiLdI2Ald6mzKM73xSKqVps1RxzgpKGQ0aD9fyzrqysD0D6Y3tHDzRTv4HGJ8m2RXISwvfudwix7VzjIpyBrlgkXa+BnrMf43FpAJTxJyDOQo3klBMq36AX6lWqHXTp8lfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa/UUx3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa/UUx3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1131F000E9;
	Mon, 17 Aug 2026 13:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973866;
	bh=aTfzxgfLnGzlysy1+QljsMtu17afPQITifZLJpAf9/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qa/UUx3UsVFF2/1xYmndYhAFQTKMRIIQ8JQH2/y/7Qoen9lsNzyuKpymTvhb+O/lS
	 39CmBwECjmpbZoMRARcjTQMhxgehgvU3wawIzZbeJzYX9yJsUlAAWS4ecehyk1B//Q
	 z/w619uLVsSy4saONtB0L9tG4yqdppWWGBwitV6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 001/271] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:28:46 +0200
Message-ID: <20260817132536.817918154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6dd3c6884cd9defb511284b566cef5ac8f657dbf ]

One should *not* be allowed to mount one of those, new API or not.

Reported-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://patch.msgid.link/20260602020444.GP2636677@ZenIV
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 341ddd353b3a8..841ef26127861 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4502,6 +4502,10 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	new_mnt = vfs_create_mount(fc);
 	if (IS_ERR(new_mnt))
 		return PTR_ERR(new_mnt);
+	if (new_mnt->mnt_sb->s_flags & SB_NOUSER) {
+		mntput(new_mnt);
+		return -EINVAL;
+	}
 	new_mnt->mnt_flags = mnt_flags;
 
 	new_path.dentry = dget(fc->root);
-- 
2.53.0



