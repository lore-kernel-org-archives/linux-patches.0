Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F133D301E;
	Mon, 17 Aug 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977543; cv=none; b=HX7y3AoAAETbEh0NjsM2GIuIS0s34Xaigdwq110LuYw5lxCiYM4GZobxIPz2DsMHTSVFFSfBzicvWAPKHZyqhmdEfI5PffgDznsrV/jtQXVCCYn/Y79d/lhBjD6k4XX0JfkzkAAi/JGpk1rFNBlE3iqmvMWt26lLANHWwvOKX8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977543; c=relaxed/simple;
	bh=QDVsbKDBSwpNcvAQUd3GwnYX32zjPqmW4Z1QP1GPaTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm1jK7q2L4RYomyOG2pn8gqwtQStZp3xIyNnIxxlYMtBZFqhV8hYu/E37U+Mmzp1bFclGQXwIY7nwprU/9gpNRPXGc0pDGgVCose8PYoqEH4vvG+deGKjgNLoyeAqIU9SOcMnkCoGwDnVaiZr8y3O40Nekedizpa+dmb193cp14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joRo1bx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joRo1bx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC401F000E9;
	Mon, 17 Aug 2026 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977542;
	bh=sqPx0yMl31q2aMnW7ADvwY10N2zegqQpr8Jqnc18lyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joRo1bx83kYin94LBLGyIcd+1cBvGGJkzh8r/u5j7IbxubzE1WFhMFYXdY/d06XgS
	 hif/aV4x/lu5dL1D1nt+Cwg9hb0UDQ8imtaQDh/EGn13UmBzCS7/f6WT3UuxlCM7ig
	 OmF1omOGmifvjzeZEi+pH0Vx0BYT90jqz1/ZlEz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/456] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:32:36 +0200
Message-ID: <20260817132553.809223765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ae1b8530eb939..2c502d554f619 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3700,6 +3700,11 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
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



