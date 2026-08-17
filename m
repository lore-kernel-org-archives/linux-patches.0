Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2A4175A6B;
	Mon, 17 Aug 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977832; cv=none; b=YoD9Si18plBfdztc0XFk4ID1swxwJD90BLp3OUyJfOSoDclr4CsTgwB5LFDPXKXbSiS7EJcf2XK0pD9LmhF7885qOffpgzkD/KJ1Yb6SfyZdjHfYm5y/889dRLs18v9snEdGeulKQawUhLFrntEz6KtuWIgMzFDyY06RhJuvNE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977832; c=relaxed/simple;
	bh=oCBslig0Qxl6wJSWJK8jj41t0gRprjFb2XQse+s14nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhhCQ0xR0MX9zWc2AGS1Fr0bfL9aXorMFXq9wi1MrQbhClIqEUzdMdDvWlfw6CkmNnkV3VtBEduglKUotQbD/ogJVDMdsd78wN7q73E670u3nVQgG6cWfbX9OpPxccSDPI9QDbFeOqaEVx76Uzv+jm9fqhVZq1o8v0urMWkjFQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZubknFiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZubknFiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DB71F000E9;
	Mon, 17 Aug 2026 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977830;
	bh=vllR1s8AK9fXACv08JEytGXuCFiSi8jyKdQBv2AXoMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZubknFiJw5b7azMhlF4EXPzprGgUSrfY1z+ZejdWp+648BEX5DnQnihj4teEcSeYG
	 4J/Tc7YRO/vzFgpWcshGnxic2okrv5WRw1b4iKnZX3v8aDkWEDq41QNWhHCmEZz8rv
	 733wFPxMPdWd/KOLrSp3wbfrnA6a5xIdp35pIyR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/181] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:31:35 +0200
Message-ID: <20260817132535.456451160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 94c06c8429023..a596381dba1c4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4229,6 +4229,11 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
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



