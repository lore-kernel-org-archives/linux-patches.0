Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0820126ED46;
	Sat, 12 Sep 2026 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242401; cv=none; b=JYoUNzZEgq3O+s55sUn8i27hZVKUsKhW53FeYHE/nqgoRSXEGb1yrbwYr107RysKzEmQ4vi6LEAD3ePTJNrgeZ7OzKe6CyxWQg/qqOsInlV9w/WCt5AKETxFsCxhVSewfPAuFeTE+OQwUUo1ZrAfCSwrPazOptPbKwo6iPhNl7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242401; c=relaxed/simple;
	bh=FgKztgf8FJwK6L51z7l13Cj148isYjrPsrGq7wM42nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5laq1O7V0hslOTZ8Xoq6vzPzuAc8d8+36Mv4woLACLbLEgjH0t77mn0MDsiloY+gSYjsTSZI2eA8T19fM687Pf0XzKYGaXcC6hP8Fj5k3OOKg7ZfucYBEGYbLS1NgbsKO++aYQ8ChoPq/omAQz4rKMYM8HWOpnYoe+YB4+a/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yel4P9g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yel4P9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7FE1F000FF;
	Sat, 12 Sep 2026 19:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242399;
	bh=uQJxKlq+D/yWrgNMQ0IAVgHy4zbVCsK/N81K0QoFV5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Yel4P9gJLBv0MwTq84O1ZTGJbB9eoy0g8gCLETtseRUGLrujyW+OaeKw1o4tGR4E
	 EBREmzXRooeZf6u2IFQWhSEU2Fjfb4CGp4x7tXEqjRYS4J16wUoIVwk60DuD8r1Nuk
	 1a7TxR/luvzCXV9f6yN0jgbbDnmRWEPh0XzeOk5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/798] selftests/bpf: Fix memory leak in msg_alloc_iov
Date: Sat, 12 Sep 2026 09:00:19 +0200
Message-ID: <20260912065526.111008542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 602701718649936eb287bf6c7ecf870ec54c6f71 ]

In the msg_alloc_iov function, the iov pointer is only assigned to
msg->msg_iov after all memory allocations complete successfully.
Therefore, when a calloc failure triggers the unwind_iov cleanup branch,
we should use the local variable iov instead of msg->msg_iov.

Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20260707081434.539327-1-yangfeng59949@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 906a2e22957d5..8732a44c09021 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -514,7 +514,7 @@ static int msg_alloc_iov(struct msghdr *msg,
 	return 0;
 unwind_iov:
 	for (i--; i >= 0 ; i--)
-		free(msg->msg_iov[i].iov_base);
+		free(iov[i].iov_base);
 	free(iov);
 	return -ENOMEM;
 }
-- 
2.53.0



