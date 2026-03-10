Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8DA3876D7;
	Tue, 10 Mar 2026 11:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142056; cv=none; b=uHcsuUegyvGupbKQvHsiyYAvD+0hOxAvKk8R5zvUo0xLTh7kkqM6O2/xt6/XuOruVvAB22DJbFDyAE7hYER7enryMLDP2wdGMKOKeARNPy9f9pqJGJ0/Uxd7oh5Qd6erVu0Bzb8ubjnWTCkkBsov1oXXH+WkGT14+fxPClPcrsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142056; c=relaxed/simple;
	bh=8BSsYPD4bcZiXHoW+0BHCdCwVqKMq+iS1gaXh6R8JmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks1JHbRfJskCwL/iNoDNZulTJaSWqcrJnAlZvl/XsmR5HjdQN8rYbo/H0ClgFFw0U0B0ZIkP5j4JNZMFk60pWXrhJ+wA2f+x8cMObnSTRkhgPzHjkPLeXs1jC27pkZIa9w9P5yQfpMnkNbwhwK72lmwEoiA3aR4CF7jPokZr/L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7IQVxXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7IQVxXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DF5C19423;
	Tue, 10 Mar 2026 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142056;
	bh=8BSsYPD4bcZiXHoW+0BHCdCwVqKMq+iS1gaXh6R8JmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7IQVxXw6OZLavFLF2LxtHdxBNJZj/AUtmhGW0UiL5snhjf7R5aT0tdHwxtYfSkXM
	 Vk3UC7s0oVAg9cBw+UCUZDqARucEXywJDHA7kwE6eUjSNj+ZeCKQhGjqLsD6+xpssK
	 C75J6y7Ud3kHZR2xLTz8yWBZGXsx35AiNO5OsAcdz1Fzv2S5Yx0RRVHsBLZu5vXweY
	 cSmI9vGRjCq8ieb1QfR0uSnWg0t0LVCJCT8Dhh8QcOYWWMsyF0OGefeZ1QsXkrgSH0
	 XgozlQ9VWITIrA8XRJoBOM3OT81hL6YgGpoc53NmRt1/w8YAPckWpcNA/E5A+ifpic
	 XUVRxu2vRMkeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 182/314] xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
Date: Tue, 10 Mar 2026 07:17:21 -0400
Message-ID: <e64c19c076b94e71b3ac7c14e5ccadbb8c80505c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

commit eb8550fb75a875657dc29e3925a40244ec6b6bd6 upstream.

Chris Mason reports that his AI tools noticed that we were using
xfs_perag_put and xfs_group_put to release the group reference returned
by xfs_group_next_range.  However, the iterator function returns an
object with an active refcount, which means that we must use the correct
function to release the active refcount, which is _rele.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_notify_failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index b176728899420..0700a723f38e7 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -293,7 +293,7 @@ xfs_dax_notify_dev_failure(
 
 			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 			if (error) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 
@@ -329,7 +329,7 @@ xfs_dax_notify_dev_failure(
 		if (rtg)
 			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 		if (error) {
-			xfs_group_put(xg);
+			xfs_group_rele(xg);
 			break;
 		}
 	}
-- 
2.51.0

