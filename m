Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B8435C6AA;
	Sat, 12 Sep 2026 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214267; cv=none; b=nZSUS74zBgaXX33zCyOgpSkPoR+SzM4yWTmzaNhF1eOlAiVLvRrzRCmG9Zn5caoE/Wt7EWiRFnsp0Yz79vdyxgKIivskXuwsUwbd2LlzeMp6jyx5K5uERWrLz05wTyet352YmSS+9iW/GJvS14ph6bz1XPDhJ9RYV/pOv2QOy5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214267; c=relaxed/simple;
	bh=Orhgp/rNjwLKwk1vRP/AYirpvsLBbol/YpN8wsyiuh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJl49cWf5Mp56Utq2779+i30cp87VFbFzOEAqmwrPcWIituw7d/pCSAbidJtFQO8wADH88c0insRur+gNmyPaENnuaE1SWdT8DEXGaLuk4K/4HoNzFPggSk88r1Wzwb/OQvxloKqcNMBtUUdLOZ8W91y3Y7ZDtaw12/LpssAZEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fABtys+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fABtys+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22111F000FF;
	Sat, 12 Sep 2026 11:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214266;
	bh=w+BqRKgPQCKlsVlfhRVvWSeLiiSR6cwMlajmauB3FUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fABtys+EZsbXIWxeUCiMaj1AnO21X1PY1KZisrbiLTb7xtGzKXFdmOBH4jGArbjNj
	 T3l74eT2AJOpRsCepW/5TwbNNqYAIDiKXsHgJ046iQ9WrWkvOlbiWU01YLZSiVWXmw
	 RP9xBnMqB4Wq3FbynB0TPu3nepi0PdHZWCxCkHK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0250/1376] f2fs: use the mount idmap for the owner check in f2fs_xattr_advise_set()
Date: Sat, 12 Sep 2026 08:44:36 +0200
Message-ID: <20260912065613.113871672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit a54ffce4637acb0db8e695188a6c7f99f14c3576 upstream.

f2fs_xattr_advise_set() calls inode_owner_or_capable() with &nop_mnt_idmap
before allowing the "system.advise" xattr to be set, instead of the idmap
that the VFS passes to the ->set() handler.

f2fs supports idmapped mounts, so on such a mount this checks the caller's
fsuid against the unmapped on-disk owner rather than the mapped owner: the
actual owner can be wrongly denied with -EPERM and an unrelated caller
wrongly allowed.  Pass the handler's idmap instead.

Fixes: 01beba7957a2 ("fs: port inode_owner_or_capable() to mnt_idmap")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Acked-by: Christian Brauner (Amutable) <braurg>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -118,7 +118,7 @@ static int f2fs_xattr_advise_set(const s
 	unsigned char old_advise = F2FS_I(inode)->i_advise;
 	unsigned char new_advise;
 
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
 	if (value == NULL)
 		return -EINVAL;


