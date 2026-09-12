Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E07B33F5A7;
	Sat, 12 Sep 2026 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222852; cv=none; b=B8xjnXJpqEj7CxBHxvtvkB5JnzvO97xTXSeSe3HcsGYgAqxFDJH6DfD/5EnfqVQc+rMTRALMcjilfjXooQwAbaATRQycrjJEQANZg/jR6HBeXMRZuO991gtFlANS5UvL60R7T3j9G/w/8dxxOPSVM3kb5D+0tv1WjH3SZnllq5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222852; c=relaxed/simple;
	bh=ClGW/N3PJXKBCgy+55msz6/SmjXVl/b8G38/7lW0m8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCFuA8DJh6A+thTgVYbcz85/zwwtV/t5jeloNWHlqx/WnBsGhSE/JGwqEHNLTej0F0269WhHFGJjvivPa0l48zgb6RfHCZdFptTaIqR300fueAo1Sxi9NWSqw4pBjaIobzM0Mszv82O4gFjYYtatHGdEIfAr7LQr8yYDrwz6VwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOT0YoQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOT0YoQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED981F00893;
	Sat, 12 Sep 2026 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222851;
	bh=6Yf6pEx/fLzrN+5wMejZNmLNau4+wKrcJgLxMGHkfOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOT0YoQm17TugChNr5HS06Dibr6hyY/pd2P9nfKqhBUKNavO3g/wBrnUdX4hFssIL
	 Ip5wDpg+1gQmDQoXeaeuzLfHFpisvggJvk8wSL7tgT+9miRwpt8pme7An1r3n3isAF
	 yFh0hlKVu/h5ye1wGjNcyW7Yg/i1keeuea5djv8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0668/1424] selftests/bpf: Fix memory leak in msg_alloc_iov
Date: Sat, 12 Sep 2026 08:51:40 +0200
Message-ID: <20260912065622.256436922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fcaf7205bd9f3..812f96f06a3dc 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -513,7 +513,7 @@ static int msg_alloc_iov(struct msghdr *msg,
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



