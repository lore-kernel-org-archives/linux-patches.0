Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42F82B9C7;
	Sun,  1 Sep 2024 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208685; cv=none; b=A2Xt/5WKlUZ6wGPS2HGCAYcRFIBVkn2Hl9OVoYJUHgZuBI0kmGEJ6IxL3++SXf2cyWdHUROXEVoHkl4ZwI+qZRN8Jk08QeG64YJoEyBC8FfvXoCYvHM0NAbuJ3uLmYxa2qpCdo6EczDFks6lhyzqXEL6FFNdmCFfAD14uXD+8aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208685; c=relaxed/simple;
	bh=I3QavycwobMZiScEXJZmWiY8frLcsD586kvtOce3Qdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCgPX6auZGhYEdMRkq7NzaLTiat413a5pD3lipZ2PEBmG6Ekxp342pjj104dBehHtWnejTPu8jMeUBYq6NmA4UOZ5yeKleRQ3jpzgCjjqm/RM3wYvc2D+lqCgVxqaOoaSemSQDpcScc0ipM+iUk1EHFG9P0d+h4Wlq3on1wjfK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvonzdk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvonzdk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222E5C4CEC3;
	Sun,  1 Sep 2024 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208685;
	bh=I3QavycwobMZiScEXJZmWiY8frLcsD586kvtOce3Qdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvonzdk/xlQl+O1aoA6YalWOQ8jocyyKniOY8rPDdbAfoy1g5X8YmAcIy0msaJ7Gc
	 zNsuu7waEgJGJeiGIj6rK/ps4L1byon0sDomOThc6BZdVwNqq2UvtZ59KjKJIfSEMP
	 otXm9Tc+pendylPhT9B7XawPp/qMqd5CcTZ1Ib9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 001/134] fuse: Initialize beyond-EOF page contents before setting uptodate
Date: Sun,  1 Sep 2024 18:15:47 +0200
Message-ID: <20240901160809.812347269@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 3c0da3d163eb32f1f91891efaade027fa9b245b9 upstream.

fuse_notify_store(), unlike fuse_do_readpage(), does not enable page
zeroing (because it can be used to change partial page contents).

So fuse_notify_store() must be more careful to fully initialize page
contents (including parts of the page that are beyond end-of-file)
before marking the page uptodate.

The current code can leave beyond-EOF page contents uninitialized, which
makes these uninitialized page contents visible to userspace via mmap().

This is an information leak, but only affects systems which do not
enable init-on-alloc (via CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y or the
corresponding kernel command line parameter).

Link: https://bugs.chromium.org/p/project-zero/issues/detail?id=2574
Cc: stable@kernel.org
Fixes: a1d75f258230 ("fuse: add store request")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1626,9 +1626,11 @@ static int fuse_notify_store(struct fuse
 
 		this_num = min_t(unsigned, num, PAGE_SIZE - offset);
 		err = fuse_copy_page(cs, &page, offset, this_num, 0);
-		if (!err && offset == 0 &&
-		    (this_num == PAGE_SIZE || file_size == end))
+		if (!PageUptodate(page) && !err && offset == 0 &&
+		    (this_num == PAGE_SIZE || file_size == end)) {
+			zero_user_segment(page, this_num, PAGE_SIZE);
 			SetPageUptodate(page);
+		}
 		unlock_page(page);
 		put_page(page);
 


