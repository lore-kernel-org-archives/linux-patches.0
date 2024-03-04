Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2237200D4;
	Mon,  4 Mar 2024 21:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588654; cv=none; b=PwK6PAAxEA/2DZH9et0S5rOVbaVgBZ6sAKyHRGEWCriLwfyUSJUr9Fhw1ewyfkyER2tUz35OgiALkBF0GZpN4GwPilbJWfBk5nORtP84HemjLSYly5s8FDSadmnwvx0qXHtw/qTWXPn7MVNKX7cd+Kb3uyVMwVlxOBaESc12grk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588654; c=relaxed/simple;
	bh=nrB3svpo/EZeLOlqjMBI5lUenFo0vKWd0t0SZs6rmk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVNqHJZFkCHaW8I+NzhBJXll4aSk3H7+HgGZr32gWkFJYQAy0yxJhfYdrv2pXhhAX0pbcraBkcMDDL66H+jByAu06TTeZFQbCZkiAXCeR8HIGhluOvci79pn77IXYZuv6n/JcS9S332v4m+6GzHv3/mA3BHzs13C09wZeqFUEsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+GIEF2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+GIEF2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F282AC433C7;
	Mon,  4 Mar 2024 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588654;
	bh=nrB3svpo/EZeLOlqjMBI5lUenFo0vKWd0t0SZs6rmk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+GIEF2DfI/7y+RzEvDzEXbT7QY+E3JurjhQny7ICveEi4VBGiG6j7+EslQRtLJU/
	 bFcIY/DXRDg7Eb25xhXvhkuGZJNqrC0HSS/b7d1xprHjXA2UtKeyMsLb1H8BeypWhx
	 B0M261wxHVdyg4oovnEF/tTDnkNSsBoQMzOgfULM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+f45957555ed4a808cc7a@syzkaller.appspotmail.com
Subject: [PATCH 6.1 022/215] fs/ntfs3: Fix NULL dereference in ni_write_inode
Date: Mon,  4 Mar 2024 21:21:25 +0000
Message-ID: <20240304211557.704318697@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 8dae4f6341e335a09575be60b4fdf697c732a470 ]

Syzbot reports a NULL dereference in ni_write_inode.
When creating a new inode, if allocation fails in mi_init function
(called in mi_format_new function), mi->mrec is set to NULL.
In the error path of this inode creation, mi->mrec is later
dereferenced in ni_write_inode.

Add a NULL check to prevent NULL dereference.

Link: https://syzkaller.appspot.com/bug?extid=f45957555ed4a808cc7a
Reported-and-tested-by: syzbot+f45957555ed4a808cc7a@syzkaller.appspotmail.com
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 1f0e230ec9e2c..d260260900241 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3255,6 +3255,9 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint)
 		return 0;
 	}
 
+	if (!ni->mi.mrec)
+		goto out;
+
 	if (is_rec_inuse(ni->mi.mrec) &&
 	    !(sbi->flags & NTFS_FLAGS_LOG_REPLAYING) && inode->i_nlink) {
 		bool modified = false;
-- 
2.43.0



