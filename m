Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17BA1607B8;
	Mon, 27 May 2024 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836340; cv=none; b=fAdm7Os/gt993IMDIjXrXlcJWj32Xo5XpIrKHzYWm3NMcsY4oJNkbPaycq4+IjMpVn11677H48CgmPq3Mcj0W8rnUKZTkd3N+W1ZYxO3hTTPcEom3mpO8KU5bhno7rsJHxGV9p8iZZo7n7Xrv256NplVyiscyGnodfQTuEKPVRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836340; c=relaxed/simple;
	bh=10/7otn0HWBN3GidM3KP/yMeRhcu7mY6QNS9gS8DZT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgFPHi0Wpp/iuy4ZTxxaTM75nmdN1XXobwDXqsL8obzxdTtpGXNzn0BALIi/O9fPN6Y07RtfOTwQzRnZXNAcPT7ZwvGbHnmgV/FtNNRzAGO9RfVB/X4I43aaiCthlkt7lWkjOFB2HNBLV5IQ1r8VJQhsot99y3VO8BD1YDPYMLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVO/L7xM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVO/L7xM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE9DC32781;
	Mon, 27 May 2024 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836339;
	bh=10/7otn0HWBN3GidM3KP/yMeRhcu7mY6QNS9gS8DZT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVO/L7xMmMbZ7yzDydPTlaFWAt2nuHt6oBRg2V0X/g6E/C0lsk4Ns0772OMHJhn3I
	 EIrBckJQRvzaiMeV5GMWlYUVNQdGDVKiZAHkApyS8ymmmjX7piindX0B+WDOFQ+QgS
	 nih9zIvFDNNTTsxgprtHRyIMTnOclBLlVg8QmgMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Udvare <audvare@gmail.com>,
	Christian Heusel <christian@heusel.eu>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 016/427] io_uring/sqpoll: ensure that normal task_work is also run timely
Date: Mon, 27 May 2024 20:51:03 +0200
Message-ID: <20240527185603.240467546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit d13ddd9c893f0e8498526bf88c6b5fad01f0edd8 upstream.

With the move to private task_work, SQPOLL neglected to also run the
normal task_work, if any is pending. This will eventually get run, but
we should run it with the private task_work to ensure that things like
a final fput() is processed in a timely fashion.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com/
Reported-by: Andrew Udvare <audvare@gmail.com>
Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Tested-by: Christian Heusel <christian@heusel.eu>
Tested-by: Andrew Udvare <audvare@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 554c7212aa46..b3722e5275e7 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -238,11 +238,13 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 	if (*retry_list) {
 		*retry_list = io_handle_tw_list(*retry_list, &count, max_entries);
 		if (count >= max_entries)
-			return count;
+			goto out;
 		max_entries -= count;
 	}
-
 	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
+out:
+	if (task_work_pending(current))
+		task_work_run();
 	return count;
 }
 
-- 
2.45.1



