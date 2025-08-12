Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D9F28505A;
	Tue, 12 Aug 2025 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026583; cv=none; b=ESTU5/ZAgiNOvWOwt/Hq166kuJzN1Kj751YlEGIb90SPcoNI9pj1objEoiGcByDZ1Q1PGo05Ouh/ajAN+8HHOfXNlc4FnTQYaFMSPmFr02rfH7qUQmAD2fqBk515qTETolSsmk70j0+I+YiHQBbCDlHKSjV1kSmOLFfhpRE/Qe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026583; c=relaxed/simple;
	bh=AtqkWmbBZMXTmpuVXE/Is1Q9WqzMo4DHS3wPjRD4gdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXbvL6kVPVE1qSY5F6G6MdYeNjZrTYOWOMpYhg3EDCX5DwRpBSrj0Yo958TRqZ/tHv7Xr28FHOEVGb2dgwh7h8ZWGJyNUZb++VCK0Y/YsYUC+jrwLg5DwgxwbUpxS405AMPkniIZOUkYTiIrhcMsmBia9SZ/A9Sk5esphs42Te4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymoFfwZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymoFfwZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD55C4CEF0;
	Tue, 12 Aug 2025 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026583;
	bh=AtqkWmbBZMXTmpuVXE/Is1Q9WqzMo4DHS3wPjRD4gdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymoFfwZ9AYF24/BgYr4PNzXXGRBTpWg7/pImdN231I6ZrJEioyAT1hpVuAiZVsjT1
	 +LG6hI1BvTt0NQHz7qQciNdN+8mrU0kyzdwNuZY7+2zbnumXTxwPPXjazBWX11ugSi
	 gETtMLGi5nx4Ak1tQaoNsCv9oa+lRB+ZO92yWqVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Hejtm=C3=A1nek?= <xhejtman@ics.muni.cz>,
	Santosh Pradhan <santosh.pradhan@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 381/480] NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()
Date: Tue, 12 Aug 2025 19:49:49 +0200
Message-ID: <20250812174413.141986077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0e0b435a843..d81217923936 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1828,9 +1828,7 @@ static void block_revalidate(struct dentry *dentry)
 
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



