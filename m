Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA6F423149;
	Tue, 31 Mar 2026 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975406; cv=none; b=aYUK7RnGH+UssbyGhZdPrN9N/X0f9Wpx15xJ9P0yJTKY3G1EVq6wAANfTgKvZ695fDhnmzMWcbX2nfZJO/XBWOTKej4Wg5oUl5Kim3wFR74SuANbtxHKO7GQuRjdEC5s8N+KmT52n2W85Ic1euNF9MtYQlsapL9US2P3698oZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975406; c=relaxed/simple;
	bh=8Wvb67knUyY9rmdupl8FfoTbFDcrgQ+FeGcDVveEtyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBVPvs5d9cN8MrZJM3awHF7GhRyI5suC1xjWGxGML8oK19KwrIP3o2F84Kjh3rJpyPSMjDtQ0uZbpHSa//mhOVvjduHBM/LvGfG/B/aFHXlQhl8kY35DxgJVTba7h/KYxYGws8+bu+Mji+uStVqM0hQ9vZ3LuHvJVGECz/ExSgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPYz0wTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPYz0wTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DF9C19423;
	Tue, 31 Mar 2026 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975406;
	bh=8Wvb67knUyY9rmdupl8FfoTbFDcrgQ+FeGcDVveEtyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPYz0wTHyFmvbR/TnOX/Ytfn4ReyRH8rW7VGeZZUXDrh1zhBsZ5lI/t9iW2BEtvR3
	 CJYH41veBcgGdPrgWYvknQ5Tvce+5omq+gMaPoPqhNtV+11O+EluxG2AwDx04BZQU9
	 x1ljFTlKyhfd2wcHnCv1tUS04/cngAAkNcJXRETU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.19 283/342] xfs: stop reclaim before pushing AIL during unmount
Date: Tue, 31 Mar 2026 18:21:56 +0200
Message-ID: <20260331161809.353030713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuto Ohnuki <ytohnuki@amazon.com>

commit 4f24a767e3d64a5f58c595b5c29b6063a201f1e3 upstream.

The unmount sequence in xfs_unmount_flush_inodes() pushed the AIL while
background reclaim and inodegc are still running. This is broken
independently of any use-after-free issues - background reclaim and
inodegc should not be running while the AIL is being pushed during
unmount, as inodegc can dirty and insert inodes into the AIL during the
flush, and background reclaim can race to abort and free dirty inodes.

Reorder xfs_unmount_flush_inodes() to stop inodegc and cancel background
reclaim before pushing the AIL. Stop inodegc before cancelling
m_reclaim_work because the inodegc worker can re-queue m_reclaim_work
via xfs_inodegc_set_reclaimable.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -607,8 +607,9 @@ xfs_unmount_check(
  * have been retrying in the background.  This will prevent never-ending
  * retries in AIL pushing from hanging the unmount.
  *
- * Finally, we can push the AIL to clean all the remaining dirty objects, then
- * reclaim the remaining inodes that are still in memory at this point in time.
+ * Stop inodegc and background reclaim before pushing the AIL so that they
+ * are not running while the AIL is being flushed. Then push the AIL to
+ * clean all the remaining dirty objects and reclaim the remaining inodes.
  */
 static void
 xfs_unmount_flush_inodes(
@@ -620,9 +621,9 @@ xfs_unmount_flush_inodes(
 
 	xfs_set_unmounting(mp);
 
-	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 }


