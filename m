Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002532BF24;
	Sat, 30 May 2026 16:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160121; cv=none; b=YWFp3Ekz7MTAOIw6kHt2ooWKgUXYbsmI9rCEWg2F04E2K2GVeK8d+xOEiQKwmVt5w5GAjrVDeuhNGIZdvzeDZ0aQdJ1IoWyn7NIZiBTgxOpd2TB+Mi61pA6LGBPY/kvkjaaRnVVcvpksAZYBUPwfU+S8tsIAk6uvRZPfNk4VskY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160121; c=relaxed/simple;
	bh=6kz8T8KcZZ8L6H+lpXvcApy0KIhNci2oYk3N7JsK1Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYkPJLLxEwoT5CdUGWMRbsUbKXhkrC/MWTUxKSDra/PPFf0AI7bbboyWVQhv/hBZsa8JEvHZ7E8GrG0gpKuw+RlbXnTNnPukXSyjj19LLiFdDA+4Y9znYz4nbTiiTmYqAnLZYy2TyKlOK7nAEFZpqjSZcwO72DlYlmfbA7vjak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dE/mjIeH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dE/mjIeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7D91F00893;
	Sat, 30 May 2026 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160120;
	bh=WzFVvENlxPwtJXbQAzN1pmh+cWL37tsYxtBXyqXdGuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dE/mjIeHx+dRZTy9MeKGWJriaWq9JOkEgdeKIxFJ7z33RVHsUIpM+NZrdGUisHqwX
	 +7+xG2Y6tHrOKajhjGbn6u7+muI2vSqI9QU0yIHBX0O6zI8HDyV/YPEKPh57FUkgeA
	 oF1+fII/itKXDgwHqb3p4di0fkAdkaAg+5DHgAUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Ming Chang <chiamingc@synology.com>,
	robbieko <robbieko@synology.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 250/969] inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails
Date: Sat, 30 May 2026 17:56:14 +0200
Message-ID: <20260530160307.371365804@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Ming Chang <chiamingc@synology.com>

commit 6a320935fa4293e9e599ec9f85dc9eb3be7029f8 upstream.

When fsnotify_add_inode_mark_locked() fails in inotify_new_watch(),
the error path calls inotify_remove_from_idr() but does not call
dec_inotify_watches() to undo the preceding inc_inotify_watches().
This leaks a watch count, and repeated failures can exhaust the
max_user_watches limit with -ENOSPC even when no watches are active.

Prior to commit 1cce1eea0aff ("inotify: Convert to using per-namespace
limits"), the watch count was incremented after fsnotify_add_mark_locked()
succeeded, so this path was not affected. The conversion moved
inc_inotify_watches() before the mark insertion without adding the
corresponding rollback.

Add the missing dec_inotify_watches() call in the error path.

Fixes: 1cce1eea0aff ("inotify: Convert to using per-namespace limits")
Cc: stable@vger.kernel.org
Signed-off-by: Chia-Ming Chang <chiamingc@synology.com>
Signed-off-by: robbieko <robbieko@synology.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://patch.msgid.link/20260224093442.3076294-1-chiamingc@synology.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/inotify/inotify_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -622,6 +622,7 @@ static int inotify_new_watch(struct fsno
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
+		dec_inotify_watches(group->inotify_data.ucounts);
 		goto out_err;
 	}
 


