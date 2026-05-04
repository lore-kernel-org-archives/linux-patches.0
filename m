Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511A73DF019;
	Mon,  4 May 2026 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904708; cv=none; b=ISYQDO7l8bLcm4H6yYNjySGA/FwQ7L5urbUPhgIQF4v8JVVRa3foh/cle/kWq1qliLzO/TtYeG3XRI1jjcSXXBnUDqbrWetZ9hXoEoFS0fDU5n2k0g9F9SsJ9rjpQ0tLn3ONpedSnuk9NlOCeUrOiPrYBwdKDfVbVO14rnYOf3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904708; c=relaxed/simple;
	bh=Mi9KzfC/eX7RPJFHfGJ8X7rHPMnxRrdRefyIwtXLF8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCtUkXzPmCmDp4QorGvARe70ubb5RAECPybi8a2+pAtUgpa6cWrvDzC83hpQ3f+Y8dHjwsb7SE5s5FtiaCo8hOMbTEl+nCX0hg/Sx2Pn1JQwCXTOe3yh+W77z1BsITi4k17YtVnOHbJDaobLuhypKiiCnqwzGQVIVwjIikWA05E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktLoHdV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktLoHdV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CF9C2BCF4;
	Mon,  4 May 2026 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904708;
	bh=Mi9KzfC/eX7RPJFHfGJ8X7rHPMnxRrdRefyIwtXLF8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktLoHdV0eiNDvbYxXbBn60if144P9tfw3ekZDo6bPxIXujZma3fyDOZT1VJeo86iX
	 CQIpZixTkv4TrRpB0V4RYro0X3b7mr3KdlQFQ32FVc0l9tsglxOEvkoMN+eTU+e8D6
	 IMH8OVbTqr79s5sUqrxwcJcB1Ctl3nql6wF8X15Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Ming Chang <chiamingc@synology.com>,
	robbieko <robbieko@synology.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 144/215] inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails
Date: Mon,  4 May 2026 15:52:43 +0200
Message-ID: <20260504135135.418163785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


