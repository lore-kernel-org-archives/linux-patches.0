Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387B63FD95D;
	Fri, 15 May 2026 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862199; cv=none; b=ei4WXtGbVvGPHxeHa6rI6Zm+rkhB2x8C8T8edGaYNoBCNKkZivLI5gdegAIKYZmHLxHxJ2Pn1BPX1I3ZHq6LgdkQrYjf/T99/lYVP55LceczZVt6YnObMXyVS0BdwzY8MfauiwzmQtR/K7Kfl5R0xhHbmfbgbwJbNWQjPw9n/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862199; c=relaxed/simple;
	bh=9MPAdYbO9uXWEXPlqBB6OkKvGVs4qzgTK4y1NS0oy/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWJSi8FovSsZemFnGuEeclrQLv5ccsKDzb37v6Tbgvri3hY2Nr5mY/jR47YieO6D95Ie9XxGV0hRoz7wjtu6J4zkKHK62O9Ypjpzh0tBXeErukAC4KzpcnCXkFGUpKLxOP54g6RRwn1UNO3Y2gZOoGM3iiAT3+WVlk5UUHeq1vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0cXw+Vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0cXw+Vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1805C2BCC7;
	Fri, 15 May 2026 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862199;
	bh=9MPAdYbO9uXWEXPlqBB6OkKvGVs4qzgTK4y1NS0oy/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0cXw+Vr6q734GCpURLCJw0CHXCn4sJJrpwrc37+3V0pN3pQp2N5SSYPkUTnMa2gq
	 5c8Y/IwPPmv1iAlFKARIGbM9Zizu33pFeXtYm7ICL8tHoPG4sEtlxzcp+QS5+OHwlX
	 yxjR/NUxl5ZYY+G+FAz9tZ4JyYGC4Z8TTHfWBF5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Aizen <kai@snailsploit.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.18 145/188] io_uring/zcrx: warn on freelist violations
Date: Fri, 15 May 2026 17:49:22 +0200
Message-ID: <20260515154700.469594708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 770594e78c3964cf23cf5287f849437cdde9b7d0 upstream.

The freelist is appropriately sized to always be able to take a free
niov, but let's be more defensive and check the invariant with a
warning. That should help to catch any double-free issues.

Suggested-by: Kai Aizen <kai@snailsploit.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/2f3cea363b04649755e3b6bb9ab66485a95936d5.1776760901.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -697,6 +697,8 @@ static void io_zcrx_return_niov_freelist
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
 	guard(spinlock_bh)(&area->freelist_lock);
+	if (WARN_ON_ONCE(area->free_count >= area->nia.num_niovs))
+		return;
 	area->freelist[area->free_count++] = net_iov_idx(niov);
 }
 


