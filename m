Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4693C1FD5;
	Thu, 15 Jan 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499542; cv=none; b=KqEFIBrgXRQKcHUEJrHxOM1V/N/m0MDGFlrTAf1r0waCG0bt41o9iorOYjfD17GxmEh8qGnYg+94xNoYT5za5HFop5VSYFfrd9chA0OKUX38qwv5RLjL17bI3jJj8jcsJeifrWo9u3XEylQ0jWUyOPRTLIRzerWgVHj7PmYwrJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499542; c=relaxed/simple;
	bh=eoGYVXKZKwBGlArttvkfvVwcXJQniuhtQv+JoZOc+cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myO4gv+k0gPW9Dq3PHDkTKXPGDpjI/rDn41lLWjYFwwPqSZcSFIsAYslxKgtLy6ab+5tFh4QmHWysIIbdOfVI3p8XlqIcUcOjj0Rhnr451vaqqCiU9yw+N7HA30VvyU6HfMukch6vKn+3rbwjSu1MObqBda/vNsGsdW3rLq9YvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhJFv/Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhJFv/Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CED0C116D0;
	Thu, 15 Jan 2026 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499542;
	bh=eoGYVXKZKwBGlArttvkfvVwcXJQniuhtQv+JoZOc+cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhJFv/MfYtIUhHhduyXm5V72xRgxaNZLzL2pL30ri7ewLhNynxDUt0Nya+StMpNOa
	 4lI7z9iTvAL6LTC7l09MppaUyE+7np9OyAT2bzdgolNW9hDbz47Vcf2r+zA2nFQpyR
	 gKesyydvVf737rCfQjlDS60B0H65Cqxys07X1Oxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 262/451] io_uring: fix filename leak in __io_openat_prep()
Date: Thu, 15 Jan 2026 17:47:43 +0100
Message-ID: <20260115164240.364183352@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prithvi Tambewagh <activprithvi@gmail.com>

 __io_openat_prep() allocates a struct filename using getname(). However,
for the condition of the file being installed in the fixed file table as
well as having O_CLOEXEC flag set, the function returns early. At that
point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
the memory for the newly allocated struct filename is not cleaned up,
causing a memory leak.

Fix this by setting the REQ_F_NEED_CLEANUP for the request just after the
successful getname() call, so that when the request is torn down, the
filename will be cleaned up, along with other resources needing cleanup.

Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
Fixes: b9445598d8c6 ("io_uring: openat directly into fixed fd table")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4178,13 +4178,13 @@ static int __io_openat_prep(struct io_ki
 		req->open.filename = NULL;
 		return ret;
 	}
+	req->flags |= REQ_F_NEED_CLEANUP;
 
 	req->open.file_slot = READ_ONCE(sqe->file_index);
 	if (req->open.file_slot && (req->open.how.flags & O_CLOEXEC))
 		return -EINVAL;
 
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 


