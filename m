Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8198633032C;
	Fri,  9 Jan 2026 12:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962476; cv=none; b=kTjCWaEdt+7bbhZKUNr6A26Tqa82YAAeyXPDOSO+9tpfPETsfkRpiOKbNIDBKd8EGmUnqXf8bB1iVpq/ceHA4AXxiov5yCL/I1iSJA/wfSO2cWqtuHoEr/xMn84EsmNoboEp2/vmmt3qn8D+ZwfRuQsTDXQ9GuEuXkoVyJYBHjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962476; c=relaxed/simple;
	bh=Tf7sVKpG2vsKCAQ28KV278Y/4GORVsVnoLeG6HVg0k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU2i6EXNixiLUQyE55lc2Q3scOo+kTdrhIqIGCmwdj7tmLc+ofQfvddT4Zv8UldSqrcAW5kSikAtMtVTR06L+4GkHCqgoNKBbWuHL5AJakDLjaYHm40jtV5/Lhp5uKPdYv0QYwIbDP8zA/OHryIdu46XwkdDJVsSs6yzjw3GHq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlX/D/6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlX/D/6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D864C4CEF1;
	Fri,  9 Jan 2026 12:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962476;
	bh=Tf7sVKpG2vsKCAQ28KV278Y/4GORVsVnoLeG6HVg0k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlX/D/6RP9iqAmlXVt22blHnlUISv9mHxWF/bdC/v/sDmgtT6MUSuD16QC6XyY1fk
	 nsqP8zV2FxIwX0PYWorhjEexynYAHwR5stGG60MLrb5qaxBa89xNG1KNo3omCpMo1G
	 u42pbBK0fMvDRqnzatZl7ehqgO2BBUlqXqGwUKjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 377/634] io_uring: fix filename leak in __io_openat_prep()
Date: Fri,  9 Jan 2026 12:40:55 +0100
Message-ID: <20260109112131.715787843@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Prithvi Tambewagh <activprithvi@gmail.com>

Commit b14fad555302a2104948feaff70503b64c80ac01 upstream.

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
@@ -54,13 +54,13 @@ static int __io_openat_prep(struct io_ki
 		open->filename = NULL;
 		return ret;
 	}
+	req->flags |= REQ_F_NEED_CLEANUP;
 
 	open->file_slot = READ_ONCE(sqe->file_index);
 	if (open->file_slot && (open->how.flags & O_CLOEXEC))
 		return -EINVAL;
 
 	open->nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 


