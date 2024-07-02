Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCF21BD005;
	Tue,  2 Jul 2024 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941627; cv=none; b=NHFmFzXPqLUZWUVyKjUEV1i1QxOqHWd7fTkCWJwTjVsNiDiyQvb3fVQjTB+J6vUl7viZ2m6T6Sbup3BK5ZMOXQZLZuTXR7avAWXbruKVILDrRWHWI4zntcPTm6tghF9XdvvAJ4h8HYJCXiCxFoHvLxopt+4ABv1XaOr5mVdQQT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941627; c=relaxed/simple;
	bh=6OqA+0meB1VkxxvH/I+Nvqxfa9Xq4EDcYtAKZXwdEz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUEF2oboeAtGtUIRaohCEO/8K+JcCAIUeL1TZlfAGlb8dtuEAmbyyNgK9wQ9OSTfVljemCRHd/mq/472xZm0sFGlpPEY0+zOZlFhLQ2asWvlzm24he1P6t19PHWOYQd1gGWsjWPnzDnMAiAf5FkLDegWEDsrfmipGTgxBAzbsTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvxIh5FO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvxIh5FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9C7C116B1;
	Tue,  2 Jul 2024 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941627;
	bh=6OqA+0meB1VkxxvH/I+Nvqxfa9Xq4EDcYtAKZXwdEz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvxIh5FOBN2zOgfQadQGUI09bdB0fMEWGvUJRKl6QKAB0PrbCyTkvSF6vUoY3YSoJ
	 E3M/erRlHPNesrdZd24Aydfubb18wjqn7makPbGcaWcl5PZxS7KZKPUmRUTGRjXOE9
	 IdljPJpwgCzKlOBKQcHFmEbXepFPLqtc9ghQyFgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+29c47e9e51895928698c@syzkaller.appspotmail.com,
	Juntong Deng <juntong.deng@outlook.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Clayton Casciato <majortomtosourcecontrol@gmail.com>
Subject: [PATCH 6.1 120/128] gfs2: Fix slab-use-after-free in gfs2_qd_dealloc
Date: Tue,  2 Jul 2024 19:05:21 +0200
Message-ID: <20240702170230.760137700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Juntong Deng <juntong.deng@outlook.com>

commit bdcb8aa434c6d36b5c215d02a9ef07551be25a37 upstream.

In gfs2_put_super(), whether withdrawn or not, the quota should
be cleaned up by gfs2_quota_cleanup().

Otherwise, struct gfs2_sbd will be freed before gfs2_qd_dealloc (rcu
callback) has run for all gfs2_quota_data objects, resulting in
use-after-free.

Also, gfs2_destroy_threads() and gfs2_quota_cleanup() is already called
by gfs2_make_fs_ro(), so in gfs2_put_super(), after calling
gfs2_make_fs_ro(), there is no need to call them again.

Reported-by: syzbot+29c47e9e51895928698c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=29c47e9e51895928698c
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Clayton Casciato <majortomtosourcecontrol@gmail.com>

---
 fs/gfs2/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -591,6 +591,8 @@ restart:
 
 	if (!sb_rdonly(sb)) {
 		gfs2_make_fs_ro(sdp);
+	} else {
+		gfs2_quota_cleanup(sdp);
 	}
 	WARN_ON(gfs2_withdrawing(sdp));
 


