Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C39042643C;
	Mon, 17 Aug 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974695; cv=none; b=sq2PaHEqBgoDuIDQw3gQKt37zlMpJ+E8fIbfl/YSI2xv+thzBdRBTf3ubyJGscqj7u893tgCH12zNifmnu1DJAUOKVv/0zfRCmXj5NbCTSLkZFoRN8Twg9b73n/8FFJo6FDo1nRS7hxtxQrF6C5gCeQ+CA60j0MRpgctu+72V34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974695; c=relaxed/simple;
	bh=NVRwG2M4anHEaOTHihQCNwqFz7uVGHtCemSZ95fW93c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E08p9zaOKr0nVOtN2kPnDj216YUfnM8JmsvR59Fk+UUK4T3tA+t9vdjAVJf6V4WBQOUHNUmj3GvAuCJ6FCMcrrz31imF9765MUgVK99pxXx96ILywfz0jbGZP5RnVVmXVfI/FabTIgQF8zD+hsc2D1n9Ct1mKo6tyC6PX/7eDkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brU5CJGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brU5CJGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376001F00A3F;
	Mon, 17 Aug 2026 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974686;
	bh=ZJ4h/vYdYWtV5gd4yI0ok6aw5ILAdHh8bO8xs61inrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brU5CJGPvLwRbeKlMGoY9ZlYkc8BtPjtMbdpxKP1wG7YD/ydc2CLmtlM+7858z2PA
	 fiNeR1lYOg4CmZzezYTpucE350Xd4JbINvR48zIrzHoK08/mnVmO/+i9H9MdAPxedw
	 /Vw0psbIxXWmlpw/xu71g8r0Cn244caunvt6MZHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/250] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:29:23 +0200
Message-ID: <20260817132536.564118227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5fd8b021785a4..d886ae255e40a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4352,6 +4352,11 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
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



