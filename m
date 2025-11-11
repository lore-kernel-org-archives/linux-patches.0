Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF5C23C4F2;
	Tue, 11 Nov 2025 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825136; cv=none; b=CKC6iX9NcIF1K6Xv/b/s+a/wgpwhUpswgprM5w/jkXDYGAgZyqUHCLJCjknAO7/Em4xbXzVXr8pIgdsO8ZGFTlAC4oDR+2q+fErlPeft+Kxe4hSKHWMoQLV6q0yQLQzORQa9Zu4df0SS0c24HwJrpxFU9Jlq0f0fiNIISig/j0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825136; c=relaxed/simple;
	bh=DhbMJ7K3mSk4tKCyzhOCZ4vLm/orf1pOO0RUkjmqWfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4S7GKt/aUOlrXqtXP9fDngFnINdD3+FUICBceH8HD0mvc5iAyTbrQzpLgPUBRXgDBRCNrgE/lMaCTYoMmIjZw4QLk5aHAWF7y2s4qKkfwiGZNY8eixBy+tmA8uJu6Dv5uKAMRyOCXjbisKxuR6Ae1Yc7VoLO/Q0l2+GJ9WSgU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rm9l7Cz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rm9l7Cz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B471C113D0;
	Tue, 11 Nov 2025 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825136;
	bh=DhbMJ7K3mSk4tKCyzhOCZ4vLm/orf1pOO0RUkjmqWfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rm9l7Cz6hdZvKfkoL5lbq9G192TYg8i1TDS7EXfYfp/smOJfEaycStzajtpcSaDqo
	 fBcUxEk3rWS+frMjdndpU9Vl/IANKtNygSwxBgci0CpBV0YW87m3rA73prz5zvdZ0M
	 9W82B/Q+S2CVR8pAO/6qFSGbBMk8DFEZSFhLId/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 677/849] smb: client: update cfid->last_access_time in open_cached_dir_by_dentry()
Date: Tue, 11 Nov 2025 09:44:07 +0900
Message-ID: <20251111004552.788712430@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 5676398315b73f21d6a4e2d36606ce94e8afc79e ]

open_cached_dir_by_dentry() was missing an update of
cfid->last_access_time to jiffies, similar to what open_cached_dir()
has.

Add it to the function.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b69daeb1301b3..cc857a030a778 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -423,6 +423,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
+			cfid->last_access_time = jiffies;
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
-- 
2.51.0



