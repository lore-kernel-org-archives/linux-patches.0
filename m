Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E8C33993;
	Sat, 12 Sep 2026 09:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204460; cv=none; b=X886E0MSwNFvyMomgf3I2ehKFBKV1lkBncYz7THze8rYc1OmzShI91DwCmuTOri3iEpWB9SjDLxjqpR0KtkNaLd2SMNYEFOsUznZPOM//LQGWf00wYUtRcwV3o/qVPXRoXuRmxJi1FwE2WoNp9OAHE/0Tv8oAgdlUbOH1Ok2HsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204460; c=relaxed/simple;
	bh=fL9z9NrMduHQtI171N2DZayEzm/ILnESd8YUMM51aSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hy/2U0GdlRad4sljOGpq6cPHqWFXG2KyhNrIzESUL9hWOuBjDp4Uh5aoqF1lDecQIl0DdB2n7N3ZrOgioe1CP06DnwP7QWzGcL152hGfgQ+k17eL4JIGEEVcXmYyOjAZUxOrP6/SzG2QrOhW0Fau9UWIYkxk2Iis6oe06/raakE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQ+e7ZEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQ+e7ZEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E001F000FF;
	Sat, 12 Sep 2026 09:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204458;
	bh=Q+Uo3tu3BjjpftkTTHBSzksiKP7vaRYe8DYICishD3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQ+e7ZELJpJ85SlE9nBOAfLvv7ddlD3aK4CDFK0l3P32Jxlh/DFp0c6Gdeps0tmY8
	 SWOHCaAatGSW8yRofEJWiMlp5VJjoRPy0TH/uWLSOWCejf1YOfHHqxz1XFhZzMYu61
	 h83QZAj/l/2igAX+ScHxaKPOa2Nrur9LOfW70dUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1618/1815] ntfs: do not update ctime when setxattr fails
Date: Sat, 12 Sep 2026 08:56:08 +0200
Message-ID: <20260912065726.974782400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 60038154b40e03fdfade1eb975f0305c4c887d5e ]

ntfs_setxattr() updates ctime and marks the inode dirty even when
the operation fails. A failed setxattr(2) must not change file
metadata.

Update ctime only on success.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 578ee00ea9315..25ff159dbfd38 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -824,8 +824,10 @@ static int ntfs_setxattr(const struct xattr_handler *handler,
 	mutex_unlock(&ni->mrec_lock);
 
 out:
-	inode_set_ctime_current(inode);
-	mark_inode_dirty(inode);
+	if (!err) {
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+	}
 	return err;
 }
 
-- 
2.53.0



