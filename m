Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282321EB5B;
	Sun,  1 Sep 2024 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210094; cv=none; b=idiR45o1xP6e3Y6XJ8qWiLMGRVIZa62vPZTdofu09wxxktPxAD6/evGXLfZvWPP8cEz35V8wt/D+xk0+SecCzCPPsGLJwvlHj1YZ3fs5L+++oqNe03uckfM0b6HCvlyS/Wa3clH9gSVDVk9pflaB+cYfPjIvZEzIl29T7lkauNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210094; c=relaxed/simple;
	bh=/LQGwcZZtGAFp86NEOiEkOisd0lqE9x2gK9nyau/Snk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfpac7YpsMwhEN4GFWHqiUYx2rYOnbK1uxaeQIwzlDzp+GHf/TRjB/HN+m8BTMVzO0wVvvZOsGfqAsrzto5t1kb9tejPXl0E5XQVnHyPMKM9fQyAjxVxBeVF1qakod96lArzQ9Cq+2O25edWCUCeMk/NxCzA3plNlpSzx8bsjKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYYHfUcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYYHfUcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86045C4CEC4;
	Sun,  1 Sep 2024 17:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210094;
	bh=/LQGwcZZtGAFp86NEOiEkOisd0lqE9x2gK9nyau/Snk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYYHfUcmgdvXNQT2z3teyvbnuuv5zzdlF0zSlgockND9nHBcTBMEBfCySVgZ1RKnY
	 uJCopkkyZhMDI/PaY9uXkqzbHDSoBqFk4EDh6U0fx4O9N4ROrWZlsoR29J/O+cu+OA
	 +kRDDCsUzF/XtP0kQzpwLwXF2oh7Gkzcheoso1Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/215] afs: fix __afs_break_callback() / afs_drop_open_mmap() race
Date: Sun,  1 Sep 2024 18:16:21 +0200
Message-ID: <20240901160825.960939508@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 275655d3207b9e65d1561bf21c06a622d9ec1d43 ]

In __afs_break_callback() we might check ->cb_nr_mmap and if it's non-zero
do queue_work(&vnode->cb_work).  In afs_drop_open_mmap() we decrement
->cb_nr_mmap and do flush_work(&vnode->cb_work) if it reaches zero.

The trouble is, there's nothing to prevent __afs_break_callback() from
seeing ->cb_nr_mmap before the decrement and do queue_work() after both
the decrement and flush_work().  If that happens, we might be in trouble -
vnode might get freed before the queued work runs.

__afs_break_callback() is always done under ->cb_lock, so let's make
sure that ->cb_nr_mmap can change from non-zero to zero while holding
->cb_lock (the spinlock component of it - it's a seqlock and we don't
need to mess with the counter).

Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index b165377179c3c..6774e1fcf7c5c 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -512,13 +512,17 @@ static void afs_add_open_mmap(struct afs_vnode *vnode)
 
 static void afs_drop_open_mmap(struct afs_vnode *vnode)
 {
-	if (!atomic_dec_and_test(&vnode->cb_nr_mmap))
+	if (atomic_add_unless(&vnode->cb_nr_mmap, -1, 1))
 		return;
 
 	down_write(&vnode->volume->cell->fs_open_mmaps_lock);
 
-	if (atomic_read(&vnode->cb_nr_mmap) == 0)
+	read_seqlock_excl(&vnode->cb_lock);
+	// the only place where ->cb_nr_mmap may hit 0
+	// see __afs_break_callback() for the other side...
+	if (atomic_dec_and_test(&vnode->cb_nr_mmap))
 		list_del_init(&vnode->cb_mmap_link);
+	read_sequnlock_excl(&vnode->cb_lock);
 
 	up_write(&vnode->volume->cell->fs_open_mmaps_lock);
 	flush_work(&vnode->cb_work);
-- 
2.43.0



