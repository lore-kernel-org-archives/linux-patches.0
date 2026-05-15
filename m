Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AAE39B971;
	Fri, 15 May 2026 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860991; cv=none; b=ooSgcrn0GsP76edSc94Y49scNMiCtwfsWQKJHlHCdKjuCEHJWSWZ3WnhUbqDquxNY522rSIvK4qBywb/VBa4+6Q02ybHRgLkdx2x3CHQg/XmklN4SOVnN5hOdFq8n/+h/8fq1Iw/jh1Ts+CXsQZnMY13VQysBnGx7L5LXWWH+Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860991; c=relaxed/simple;
	bh=yj4Lm2h6wyQM39iE8wX7FUBpBWvPeHuGY86rPw9v+WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRad+JIZoL4xzDjUMk2aRF2vYX9456y9nHJ4lwFcdw6+jCh9+I6cDAhS/fltTwaPqzEDBOzsA2r4/susk0WVInzZTDJ6KLA7q00JSUQn+VWO5teSaRas/y7aE/lN8lGbsiLILu/7UVF+fmiHdXm+5INVwjyblOGyopj4HTHib/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC7kZ+pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC7kZ+pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F95C2BCB0;
	Fri, 15 May 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860991;
	bh=yj4Lm2h6wyQM39iE8wX7FUBpBWvPeHuGY86rPw9v+WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC7kZ+pNK926oJCswQs2nSjXI8Y5HOi8j6Hzjkqo7j0zBKR7fr4DK+GcKFIMfaYUl
	 Rw7WT8+2dPeJoKVvCENxEGFONfjUFBoEleyjZsuQSsjQ8uRkTJOC4YBNDi+cdpTONO
	 7KvwOOaZ+QweCZrm9JBHaL1cKJOJUkj9vECI7Ob0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Ming Chang <chiamingc@synology.com>,
	robbieko <robbieko@synology.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 115/474] inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails
Date: Fri, 15 May 2026 17:43:44 +0200
Message-ID: <20260515154717.525991305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


