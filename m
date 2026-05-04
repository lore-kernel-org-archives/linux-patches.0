Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B54D3DE425;
	Mon,  4 May 2026 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904162; cv=none; b=Lx6/vKCXcRM4hUM5GcaU7ijGg81iDoHskoXqLRYw/Xz61KJvODnqXzwZliQvkFDn1WH/QFGLAHK4dWqPkQOTmVG9snnFrxQnOrw5aa/K376yKjLjREWW4ZR/uvgogDYl8VG5QxDkedLYQq6qFey7tkp6mZii1b7eS2h2lXHzfWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904162; c=relaxed/simple;
	bh=z08WFuuWbL7CXXbbAAuGsDbhnbIz+SYe09UHV8oa5WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwCEZK5Im5q45CrZnnuMVnxDHarYIPU9OFaRNqPP8TxwgXlsCyRcNpBemAVxry+O4pi9PC8xMpKNBUpbfLSdb2tIG9skQcULi6BA3ZsEDINM9kMEGVLUKPODV085oP26OruFgbutBBGQk7mF+lIXklYlo7aL6wrSDmzo8b5h430=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvoiS6dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvoiS6dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7212C2BCB8;
	Mon,  4 May 2026 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904162;
	bh=z08WFuuWbL7CXXbbAAuGsDbhnbIz+SYe09UHV8oa5WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvoiS6dxMmSYFGQ9CZvte5I0ZrOJJ2MTxZNm2HpN5ljNCTXLZ6VL4z6jIi8dI2q71
	 wagyy0j80es1M9LbXP/cLam2IpHKE2S4BTbMNa0EbRplsNGqpBx0RaRC0N7IAE9U9C
	 DUicTf/lmhmKblOBuLQfOP43NSvTbk/yc0UVzdwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Ming Chang <chiamingc@synology.com>,
	robbieko <robbieko@synology.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 208/275] inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails
Date: Mon,  4 May 2026 15:52:28 +0200
Message-ID: <20260504135150.805155540@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,6 +621,7 @@ static int inotify_new_watch(struct fsno
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
+		dec_inotify_watches(group->inotify_data.ucounts);
 		goto out_err;
 	}
 


