Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB305313538;
	Thu, 15 Jan 2026 17:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498132; cv=none; b=umTObQco7gYNCtRB3MLaDIpFB3HLhy2xcPHXEtYaBpho+Sf+oQhuRzW/vKqq6XbsHS4EtmAFjCEcVlJjMSecolOKFUKJ4g0AyyK/HNn+rBmbPRQA47SB/dGHS4SNGIESXOdyeYOh4MbEqhBtRArnvSL6c9+/i7/64t5NVgcd9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498132; c=relaxed/simple;
	bh=GeLVcDZuW5XOHC1xS3zk5StfFSfvCybLQa0S/B8iJQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxupkJOfldvfwy0uEP5i3L0eOS00pPqYVsvrxLGOxR1a4oAo91oFguea1+GN1moij13eWUikVP5rFaZCkrqQjvOSEywpt8qSbc6D8mKF3Un/uSKSepDEPx4DIs97stIcDzhyq4pGGiy39snudFo+mt/vVwuYR+nuH0JFwZ524yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opDcrPQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opDcrPQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F14AC116D0;
	Thu, 15 Jan 2026 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498132;
	bh=GeLVcDZuW5XOHC1xS3zk5StfFSfvCybLQa0S/B8iJQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opDcrPQoKRoPrnMiz9EFyJy243Pm8+KAAWuF/RvsY9Cmm+s6jytJY13+OP9yRCuYT
	 vFsWmdN97teXc/bp3vnir9RsH7pF7brIboOH8XoWZiOyDmQvqzRF4vHIwc2MeAP/mx
	 eC1H8IfQBdO+s0HNMFUXgTjOw1NiJAHndCkB6gjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 325/554] io_uring: fix filename leak in __io_openat_prep()
Date: Thu, 15 Jan 2026 17:46:31 +0100
Message-ID: <20260115164257.991869443@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4326,13 +4326,13 @@ static int __io_openat_prep(struct io_ki
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
 


