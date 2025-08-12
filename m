Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAE03F9D2;
	Tue, 12 Aug 2025 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021809; cv=none; b=Lx+WF9Pf/1NsTKdF135x6cSSMYcGj3WgmEzqn1U2hMRyZNYV9OrLctvt0caA9OitSUPqKa4H7/suv3JFVDBOZgnoUaoIvRs/IJyOIv2JU05/vCA4d1NAU/uOBX39hY8lCjBFedEkfXJpmfaxQ+NIzHiE59AB2wSiNmmKJG540v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021809; c=relaxed/simple;
	bh=xTkf+UllQbSJhxrMdm/TlSo6VK8vnPtkz82cL7glQ3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7zUjs9xkrs7JsnHEatDlIBXjT5aUnbBcMVpAKcfRuFfPK5ZzyWoBo2CIFd4OT99UmQhdRfURfwsq4tfUj4L8UhkWRHlC7qvWLt6fjKQhaUtgG+UYkXLLe+sAJZIUAOYpnCj46yj8XO1Z/RqVSTTrGDHLODjsNpQI1yLFI6cg0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0FNMUqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0FNMUqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EA6C4CEF0;
	Tue, 12 Aug 2025 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021809;
	bh=xTkf+UllQbSJhxrMdm/TlSo6VK8vnPtkz82cL7glQ3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0FNMUqHD3vV22PAJ1bDqYXggcrHHXnn72rD71LK+2oqvx4DDOBafFBwUdFk7Q372
	 NwT5UheAu5+xp75Y6Whij6b3L98pIoWE0lqnW1NpuJDFlPdVQcsIu1VqxNroivf6yX
	 rvFOmKWNNrJ1XqOo86L3U0WK1Jtr19bLWMTzbKwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Hejtm=C3=A1nek?= <xhejtman@ics.muni.cz>,
	Santosh Pradhan <santosh.pradhan@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/262] NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()
Date: Tue, 12 Aug 2025 19:29:46 +0200
Message-ID: <20250812173001.589205543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1db3a48e83bb64a70bf27263b7002585574a9c2d ]

Use store_release_wake_up() to add the appropriate memory barrier before
calling wake_up_var(&dentry->d_fsdata).

Reported-by: Lukáš Hejtmánek<xhejtman@ics.muni.cz>
Suggested-by: Santosh Pradhan <santosh.pradhan@gmail.com>
Link: https://lore.kernel.org/all/18945D18-3EDB-4771-B019-0335CE671077@ics.muni.cz/
Fixes: 99bc9f2eb3f7 ("NFS: add barriers when testing for NFS_FSDATA_BLOCKED")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 389186384235..385baf871800 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1835,9 +1835,7 @@ static void block_revalidate(struct dentry *dentry)
 
 static void unblock_revalidate(struct dentry *dentry)
 {
-	/* store_release ensures wait_var_event() sees the update */
-	smp_store_release(&dentry->d_fsdata, NULL);
-	wake_up_var(&dentry->d_fsdata);
+	store_release_wake_up(&dentry->d_fsdata, NULL);
 }
 
 /*
-- 
2.39.5



