Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA47E1C3F17;
	Tue, 27 Aug 2024 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772258; cv=none; b=gMOrj/EDckeZymjadGbaE+0r67PhhHZduUobilaWOB+MyC180Z+VR9fzeUQlavR9AdsRmbxR1DLigaSyj7UX4SoA0DlRxnUdHCCUCCZtbSWjV8FyRzTB26dXIVmq1ab/GhvFgPozn1WSgt750TQTMYHHz7hoTdZLRJxDlT76eeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772258; c=relaxed/simple;
	bh=Mf00OFfW+zeysMJhKy0VkRileOcsjdjg6pEfI+XG9F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC0vIkPVl1HgFcHyYliZl6aia1EpRxInRs4I4q5qKE7tcPmrJ73qkxR1YqtjXLF/D1FZlVEjLyAtB3UM8nupBTcXETRwjfV8EyOJpTKP/0fZ/i/1yvgdLSgjCExZxLdCLQFAZLGqoMu3DUkfcClSP4XfcURN9itaS6QAcDn0PqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snshsirY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snshsirY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DBFC61069;
	Tue, 27 Aug 2024 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772257;
	bh=Mf00OFfW+zeysMJhKy0VkRileOcsjdjg6pEfI+XG9F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snshsirY07KPYEvXWxA/dao5/0ABfxY/oin2l6FCttKLq3MwU/3v0U9FtHwa/Gd8F
	 e8BtB2NgLUSmeJKveX3x+wiGn6NOiE/LBAjSYcWMceIA8OHpQ0Sq70Yg49GBxBPEra
	 AvtRM1HXUUq9nK+N0M/YBiO74MX6L59A95T7k/gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/321] afs: fix __afs_break_callback() / afs_drop_open_mmap() race
Date: Tue, 27 Aug 2024 16:37:48 +0200
Message-ID: <20240827143844.321844622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 2eeab57df133a..9051ed0085544 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -525,13 +525,17 @@ static void afs_add_open_mmap(struct afs_vnode *vnode)
 
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



