Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963E7492525;
	Sat, 12 Sep 2026 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238451; cv=none; b=l6jm1WGpyOxO+UBaXlq3qezJe9OPtJSN3vkLj6p4OL/lWmkBj9Jna5+OocVA9SaeZEhXRvEyJl1SBT0HgbuUji/JVtsWnOUlQ347kwmuciMx2XvnU3OZsvyG0Evz6QT1U70J6ZsF8u4a13pTJ7AjjxRZPdPiN6zaCnyyS5e0uEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238451; c=relaxed/simple;
	bh=9yNXl27CCKh9VSEk6XS8UgXQLS1NrAsvEs0FYMUh8ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJWrdHiwUxv2/lU7KW/pPz9nmGA9y6b+UNC3b9Fiydmeu/RSnOibszcjrQy6xAdKdXrPdkPgX1dXrUSRDwJ23vi2MfNALw+57gtgQI82j6mwsKtSVF2LET2wjuZr/eji6BrSRqVwTtoryf8bdQlyZS86eVZ7ZMgx5ZRlLDQPp1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgDqpkVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgDqpkVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C496F1F000FF;
	Sat, 12 Sep 2026 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238443;
	bh=38TT4ud3VK9m62AxNTrqTNX58nMcbQPTnaKHzl2rB1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgDqpkVlm6vMreTRR1rsCtMAANxOgD7lERSK+qq2KQs1Kd54QsSql+hEkNHNzNFNu
	 Wjm7kNPNOH4PX8P5OKPGsFHDyqYU6FmiaboMIgJQz3gJH+OE9Vk4BKXGjI07ksGL2Z
	 cxyMEewNo34rA/rpLPsIcySdiriQHmdVRQsYUF9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/935] selftests/bpf: Fix memory leak in msg_alloc_iov
Date: Sat, 12 Sep 2026 08:58:13 +0200
Message-ID: <20260912065537.445870612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 1033c8a2a459c..63f7e319ab672 100644
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



