Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEDB2DA759;
	Mon, 17 Aug 2026 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980238; cv=none; b=t4u0AUqsINo7c9/uYtJpqae77Z7vB4B89QP789dJQBlGpbcvpEPG/UlkSkgTYvnUF2zWVhy710Jy/fu8ryPBIlVhfNZIlGGtX7xM8aekgpN6yjVhznGy3EGTGqH/3YUVCq/T//zKL2oTDuWw8WGnX1clvdSTrylgLiNDp8IiGRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980238; c=relaxed/simple;
	bh=S4+43y9Yra4Zc7XrWVTHVPXMlOh5cFKO5Xpl3CLkva0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBFKjFJKiepLIQP3xZE1HF4Et8v08heaHjYTgVKrsO17ac8RyfsN+23hKjtEpD8ymHRTMgF/rQYJEZdId1wAEh1rlYZIQilNyxCqdObj6X4cpMxgiPUhHTAkiD4ap/VCmXTRNYIXfTZ2CMmLpwlZDfMtEhoe+OiNth+tm+4AXjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04xFhlNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04xFhlNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F2D1F000E9;
	Mon, 17 Aug 2026 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980237;
	bh=j0iUZYEQ33s/lCYrB1fltNfyi0u2OS1rXEPj1SezKxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04xFhlNs8TNuzLtg6e4PjkFpy1G1IR2TN9rJNx41FFjpOm/aKeNHNPi+8p7sRgdox
	 alqIIrCxPszm4agB4okUyuCBCexyvik26VvFJEtX2VDKW7wUOnHDTlYqLWUukvU8Tm
	 C4cvmdCu/zHT7IkEF3g6s126t5npAIVamKB4niZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 486/609] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:33:02 +0200
Message-ID: <20260817132600.188718123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6dd3c6884cd9defb511284b566cef5ac8f657dbf ]

One should *not* be allowed to mount one of those, new API or not.

Reported-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://patch.msgid.link/20260602020444.GP2636677@ZenIV
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[Denis: rename new_mnt -> newmount.mnt]
[Denis: use goto err_unlock instead of direct return]
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index f22f76d9c22f9..ed5e9e7251e34 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3744,6 +3744,11 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		ret = PTR_ERR(newmount.mnt);
 		goto err_unlock;
 	}
+	if (newmount.mnt->mnt_sb->s_flags & SB_NOUSER) {
+		mntput(newmount.mnt);
+		ret = -EINVAL;
+		goto err_unlock;
+	}
 	newmount.dentry = dget(fc->root);
 	newmount.mnt->mnt_flags = mnt_flags;
 
-- 
2.53.0



