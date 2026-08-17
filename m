Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B9543C07E;
	Mon, 17 Aug 2026 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978357; cv=none; b=uGTzGd2X/uxmenh7j+5krFd5nVcmTLQMBuHLzSSO+VoD+oajsr0GcWgTS9FlA1RVn8Yq0GMX0OvNJkrVfenFMsGtVzgmpMaHtKrkuRAN9t5g7ldIgerdvJ8Z6CptTTJTzzNwowPVUvGkYxvQlhOmIp0oX8XDFbBQd4Awmy+EOLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978357; c=relaxed/simple;
	bh=hcLua6M4aRThZW3eQMyZG8tSlDhrQGvFM6WiVPdCZsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruwKbWdM0YC2TaNZFfz/WCJ0jUuuKIyxHIgAV58afiEh4Lr548F56TaILnMPtFXhrBVf8z4Mq5GvHFn0W010OE/nO5BQ2y+b2MbKdLg0d2Md7JrLlTafrsf9KZNIHEIU1kL4sTgacf506fPvJhqECHWh+ap4XIx1Zq+d+37o2HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKKStWrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKKStWrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D0F1F000E9;
	Mon, 17 Aug 2026 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978356;
	bh=neptSaTty6idcQNS8RiDE9WQhunqYRYuE5Vhtm2ZLVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKKStWrGeN2JHB8gNcI/FQh+0sObrmsj1NClEFrOETP47egtZv2Kcx+Q8+vHV2Hcn
	 Kc+ZuV5YyjQ2FF9msWf0xAh0YuiKOBdyEtAB6ND6b7cWZ8xMJvXFVxHTNRTGT79CRH
	 WXuyl6Q4pApK11vxnnrYN6bZsaciNOSvjN2DppRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/156] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:32:15 +0200
Message-ID: <20260817132534.723868338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 646d9e7d41ee8..f185de5f5df4a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4050,6 +4050,11 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
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



