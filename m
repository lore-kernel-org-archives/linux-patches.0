Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97E352FAD;
	Tue,  6 Jan 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720165; cv=none; b=gdOeNeLZAFQ6k1eZL2WJSblAAEBoQ8Fw4NSWAYSjx8UOZvLq+pl3K2EiAYyI5JATMkjwuJxLdq4cDsjiVt30Bpnqn/CSeuPfD45yXgQkVVCe4XQUNN97Fzrq98WzXBOfG+F3UxS46lhiDD4V82b4iVHsGl8sy4TtlPeRXPiQeXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720165; c=relaxed/simple;
	bh=nuJjIv9rOBFrcO/FfCmdnbqaKL0QxnM3xptqZqplF9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ6njtfPl7jWgTGNa9W4TWva0DosZg7wJLgHYBRxdLSMzBafggL39eS2KCOVc1FHSNmOjfdLGQAdYN4CI0WvxcLUHOP+NvFFudLPwKY6oTgB9TFf8dhHYtef0m10/lYXsVw0zlVtg1jodF125b7FPQcKoR9voONZYgRL/Yz+UZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM+CWzOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM+CWzOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F99C116C6;
	Tue,  6 Jan 2026 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720165;
	bh=nuJjIv9rOBFrcO/FfCmdnbqaKL0QxnM3xptqZqplF9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM+CWzOoteh9g+In7J+T1HllzmHZlzlXSVn4mWF7HxNEGaH9LoKoH3GTB9zkCm0ps
	 6TVqRGLPKeEiU8jDj1fmpkI87jD+m2tFiUMI37trhqpwtvA9sGUnPOzI5jZAcyl7Gd
	 8tRIT6udfdz7EYYCpSLFI/mdPe89F0qs2chbeQXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 154/567] io_uring: fix filename leak in __io_openat_prep()
Date: Tue,  6 Jan 2026 17:58:56 +0100
Message-ID: <20260106170457.024930980@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Prithvi Tambewagh <activprithvi@gmail.com>

commit b14fad555302a2104948feaff70503b64c80ac01 upstream.

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
 io_uring/openclose.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -70,13 +70,13 @@ static int __io_openat_prep(struct io_ki
 		open->filename = NULL;
 		return ret;
 	}
+	req->flags |= REQ_F_NEED_CLEANUP;
 
 	open->file_slot = READ_ONCE(sqe->file_index);
 	if (open->file_slot && (open->how.flags & O_CLOEXEC))
 		return -EINVAL;
 
 	open->nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
 	if (io_openat_force_async(open))
 		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;


