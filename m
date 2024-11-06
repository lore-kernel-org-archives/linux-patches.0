Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30D1DE3B5;
	Wed,  6 Nov 2024 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897462; cv=none; b=mNWONvxZ3152tubwhYvcVkGpEmRRw4yPu/2YP5Go1E8AhFcOcGyWF9xU8Iuj3c8kwa/EXJUPxnl9CD9NpTz2xSpsSKsgmorsxBlHm3NJCWGAO5l5BYCzV4BWba3jSx9iZ5UnLwQL3UbVrS7kQCalkRRonuMzkDlVxaC1bfKoodE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897462; c=relaxed/simple;
	bh=sQz3FLUWwzrYNzNbsLlL2ZsDnyIZpCFi/cEvtBRdVHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6ZdqnZJymAWLaKHODzHbmeHPtwISGhcGja+K97GFDejl86qxbEU2NnctG7mN97R2yFEbKThBlFmxGc8mP5s7QRFSZCqOArhR1+E/hNogeVmGQ2Rky7ZcqkbW6OkBGEAJJ3FFz+CY3wZUxsEJa6UCM6Mcwji2EXGlmLYXUAp16U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQHhxxqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQHhxxqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975C4C4CECD;
	Wed,  6 Nov 2024 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897462;
	bh=sQz3FLUWwzrYNzNbsLlL2ZsDnyIZpCFi/cEvtBRdVHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQHhxxqfo+ZvK+ykn3C62c+D0gAgkmP5JnbdubhFbKCq2ZxdKsQuJmHUjgi5EZmT5
	 LRXKfmaxsu7kF+2kurHjWdO/C986tEQ9bznEPoqeJ1Lfw+4qj6+R125/mCoodfl8N5
	 /CuC3Qdh3yKyYBG0OVOZCYaDcY6fnGP2j9mSysiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/151] fs/ntfs3: Additional check in ni_clear()
Date: Wed,  6 Nov 2024 13:04:09 +0100
Message-ID: <20241106120310.520471074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d178944db36b3369b78a08ba520de109b89bf2a9 ]

Checking of NTFS_FLAGS_LOG_REPLAYING added to prevent access to
uninitialized bitmap during replay process.

Reported-by: syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 61055bcfe8277..12e03feb3074a 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -102,7 +102,9 @@ void ni_clear(struct ntfs_inode *ni)
 {
 	struct rb_node *node;
 
-	if (!ni->vfs_inode.i_nlink && ni->mi.mrec && is_rec_inuse(ni->mi.mrec))
+	if (!ni->vfs_inode.i_nlink && ni->mi.mrec &&
+	    is_rec_inuse(ni->mi.mrec) &&
+	    !(ni->mi.sbi->flags & NTFS_FLAGS_LOG_REPLAYING))
 		ni_delete_all(ni);
 
 	al_destroy(ni);
-- 
2.43.0



