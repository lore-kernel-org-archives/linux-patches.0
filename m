Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A2B345EB9;
	Sat, 12 Sep 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229229; cv=none; b=hwuqh3KJhnt0t/s7sUnx9aRjRLf079pYkU8fZP29D9jDfMW7F/N6OwVZHM56ixBE4EZA2gs8pALk+FsTWW9Jxo7yHnJsF3FuMZsVx1MTgpbF3bqqphc2wjxaLax+QSb97XZ/5goZqL9kuwib3bWAszGieQRoFW6UDZ+ZHDRYQME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229229; c=relaxed/simple;
	bh=5KEqBK6UOw2NHl92oxpEolmW9fdThb1OyHQnoFHN7BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlX2/IvLPq9YpAA4z1WF+KztRHdH8XrANeRveVJGF9ZkYbTwQ9jm3Ik6ZfNNvlWmxghadHEhcJbQjdEPFKXXT8+VZIFqV4208g98LKuWNsKX4b0E50TjIje+Zq/bVl6JHQsFME5DigCqkaEdkzOIdZcSYoFzdePjaulsiOnWVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zL7hRSNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL7hRSNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF7B1F000FF;
	Sat, 12 Sep 2026 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229226;
	bh=Ak0fCTiW6b/c+NyK4FJdaXRnWV9mAq5IT1jSfQaY20k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zL7hRSNyariM+AVSHW0uhi28jC3XcqsEE2HXJfkyBdgrs8IIgpspeZdE0RBD4XVIs
	 omYPpqtd74cmvSMMISemKa5ofdbOJNzTjlvYssuKmIkkChxVZF3beuIYcQo01Ispap
	 ZXwe900Zbp6Cw1xmfHgJCzlBa8aa5t8eLSiBup8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0546/1191] selftests/bpf: Fix memory leak in msg_alloc_iov
Date: Sat, 12 Sep 2026 08:54:34 +0200
Message-ID: <20260912065600.508367035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 664be1f108dc3..118da895bbc5e 100644
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



