Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719026BB5B;
	Tue, 12 Aug 2025 18:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024899; cv=none; b=tYR7I70Nj8A6PwcK8iuBTBxsEwvdF1wj/tc1Vd1P9i0XmfW6fvwpHN8ER+qheEsB4Qbu7IyXMcKiFG6PaEAQs61AD3lHRsWZHVOGs3h4q3E2gpS8axD2OlpkuMqKHl+GCV+Ap2AEJHJy8Y8yAnd4xjgnCvOH3UxLjfprK0uU+rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024899; c=relaxed/simple;
	bh=r2ajVIaa3njrbFqtQCjbJKPxmkbo+vlfJU4ES1z19ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tA37YASpsiDCSGnf7cU4RKptb5t+2dygzH+l+IFnhPYYRv0PYr+h38uE3jP+vfctXaVnsL+SJxT2chI/L9WFtBDn6pN9n6255KrZDypa2Qs+8bvpQJx00InIeCl6hOav3GLUTZ0+L1IC/nCVSnmd001tPz1eEwGMJp94OLTYN0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpKRrsAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpKRrsAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C2FC4CEF0;
	Tue, 12 Aug 2025 18:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024899;
	bh=r2ajVIaa3njrbFqtQCjbJKPxmkbo+vlfJU4ES1z19ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpKRrsAgJUJZGu75mofFKps1J4M4M8oT97TBn8pKg2YdsFO957jObkVRGq0cvDhIo
	 Y/xa1+x15o1RkpVAsQ5+XT1yV0+nmwOEZSOc8yj3qW5+x4H4pHkx+poBxLA3j+fski
	 aM06n8fekec6MAnjx7UOblIDr1nnBzhGGVXsKM04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Hejtm=C3=A1nek?= <xhejtman@ics.muni.cz>,
	Santosh Pradhan <santosh.pradhan@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 509/627] NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()
Date: Tue, 12 Aug 2025 19:33:24 +0200
Message-ID: <20250812173448.831941483@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



