Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD182C1B4;
	Sun,  1 Sep 2024 16:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207560; cv=none; b=OQ3ye5V7wInDzYGkOoCQVwOqmTgW/ugNg7AYQMbj1AaLj4k5dO4XBbwzb75dYyH96fk6WqDcLE79SH93x320vq1hZ4YuHtaXNKZK11VeZ+V6brvxsW1qBU3S1MUfVzOYIZCLDAm2n7uvq5G0vpWYOiO+LbzAYBmG7Kk458mk9/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207560; c=relaxed/simple;
	bh=naerpwW5HIKun4xuIs2nqh1PQfPf51TAEzehaL0zlv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS7wMoi6TZYFz1rnujnJhfeAHV1CdP8bNIdmNkVpkVt7tKhq0Yyuxo7Amy17HWkouK61P8sHHXH9KOE9x2iNEEONlmJ7NLS6sJ68t/3HwX1o98jnV8i2M2s4rqf4iRyNxtAnxyXWt8juXIua66QN6AvEiiw8XYKxbVzaatJ3nbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRLErB4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRLErB4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE28C4CEC3;
	Sun,  1 Sep 2024 16:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207560;
	bh=naerpwW5HIKun4xuIs2nqh1PQfPf51TAEzehaL0zlv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRLErB4ODQNh8ZYdoXX4e8/5ZG7f0sGlSuY6dzxnXoHGpQZAiJfVp+TqBsjmZGvGR
	 fG4pKeN4FYcc2UErARlZqIcORNg+YpixsrvAStm8glcgd0iUl28U4RJjjLURNH0tAl
	 aHURDxlNYRuGvqLW0KCbaGD71loJyZ76WQIcFiG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 01/98] fuse: Initialize beyond-EOF page contents before setting uptodate
Date: Sun,  1 Sep 2024 18:15:31 +0200
Message-ID: <20240901160803.731972566@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1671,9 +1671,11 @@ static int fuse_notify_store(struct fuse
 
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
 


