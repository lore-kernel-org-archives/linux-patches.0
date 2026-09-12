Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805AE2BDC0E;
	Sat, 12 Sep 2026 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197760; cv=none; b=E9R3f/11QQkXoVUWfc8Z2fwtk8P6UyKHpP9IlA07a2xKT2J8gOs9rDtDmNDaVMOebgq1ORCQKc0oJp8Ba3L4FcACaLJ+r7+TzWe0UN0Z6PWORx6wndMEX7gdURX042IEPQZ0fJ18SSj1RnvAES++4b8I8+a8usYY1ugMmZUNxL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197760; c=relaxed/simple;
	bh=NiHnRDm9G6iEyO71Sn4kQUs9cku+EUwkX8hUAADShyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YATSrxdWS39BOBmmHjgQM91RxCgL5RKA1aiDZrkdwkzZaIagKyvPDODTb2ke+DKVHeOiX8s+7aLf7yGkvGNDWfd2YzOOX3fJfzri4va3M7coOuznP+vGi4LEQV0hisza3JiXSuoUlT1Iu5uX7jjkfzQQeANkdiwIWUCmIPqRnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adqRoiiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adqRoiiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBA81F000FF;
	Sat, 12 Sep 2026 07:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197759;
	bh=VjbgSmv/7u7sankD92wgP3sDzYfgLWryuyn8iwl3tcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adqRoiiJQRoDzfyKOMePZVY7QovPkSWVFlW9yZ93/B5mltYisQxyReHAu4mjd9/R6
	 lr+dhzvdCW/1ssQJvx6dznDuQFwC9FodVbsDsYTVzm0aUq/FepWtJDdkYs9x2PpNde
	 t50OFPORHKCe0jaJJ8h73+SOcwWeXqWquYdYugA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0242/1815] selftests/bpf: Fix memory leak in msg_alloc_iov
Date: Sat, 12 Sep 2026 08:33:12 +0200
Message-ID: <20260912065654.670368534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3e6be455d1583..aaf2050e88450 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -435,7 +435,7 @@ static int msg_alloc_iov(struct msghdr *msg,
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



