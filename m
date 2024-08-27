Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F20A38DC7;
	Tue, 27 Aug 2024 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770299; cv=none; b=Jnu5L9pBNjSoP+SjxQS9Vwig3mT4Mu1k6ApYoCy+si1UzCvvH0ZfrhM95IUz8WnSLYgP2tZ0z9/33nhP04ihib96C/rQ3iXuTA0S7xImn2iL24skaC0Zhrj8LbbJzr/Fs6/mlhpGK5/0r6cBGoxT/Al9pgWhL1XdY9w9A8FnPTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770299; c=relaxed/simple;
	bh=28mCluQ9GJSFiNLecNeWdTA6cQWevECOm04G9QRtqZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urLXSdLnXh9I+sbk439WVHFcwODBTTupRprhG7cUVXPvIsScfDrUHxlgoomqHeJcoFXK+OokwNB+JPmBIYm6S+9jFkeCBpVoToe3rxHVBuzYoe1CjRiB2YTJ6uPy6LK/kaplcwgLVhHt/qnt+sosaOLWPJrvwMCMGl9muCgjamc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yO3uDobX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yO3uDobX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CFC4DE03;
	Tue, 27 Aug 2024 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770299;
	bh=28mCluQ9GJSFiNLecNeWdTA6cQWevECOm04G9QRtqZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yO3uDobXTM8jSYfBe90X7fORYU/ORoidXFc9O+HJJWK3L7TjgqhplDzUKjtAS9NBx
	 U6ZCgiBwdrzstrzhvHFQZDLsWNhsHTD4u4BojR/i18xPurPH0sFmPHsY+4Tb2uzkAD
	 LpKX2bJuL/06RNv7qnPD89h/cq1knmfIdSFTtEYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/341] afs: fix __afs_break_callback() / afs_drop_open_mmap() race
Date: Tue, 27 Aug 2024 16:36:27 +0200
Message-ID: <20240827143849.353607920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index d37dd201752ba..0012ea300eb53 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -529,13 +529,17 @@ static void afs_add_open_mmap(struct afs_vnode *vnode)
 
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



