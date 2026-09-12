Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EBB345EA2;
	Sat, 12 Sep 2026 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222842; cv=none; b=E8zRftHx2Rq4bNCiZvUjZutzcVYvGmlN0GN8J6RxD7No0BLjBqKLznDXZS0/lBySdJBZEtjZbJn0M1xPhLuc4EGw0rfL/7kfHBuZAJ+FHIGtUa0/cBPVCUnIv0AFK20V1ZJolb6U+UGftKeS4i638iaAzRETo2kBG/ZHJTwmj3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222842; c=relaxed/simple;
	bh=7iZ1+FxR9ADGSoL0Bs7+ll7LgaqpWSAaUHuweHZoJ2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/m8XzoHp22eqZ8G5LmtmNO7KbOQ7TBObPacV0aoM20T/LYhfQXwuwGmFDVzGc6CLDW+6255ODFMAg4WaRIfE2E2Fw0iT3vVsFm+SrEwVxXJVgfZFFTBR9CP1aveAIoO02PTjgAHHEbBqkVJt+rK56gHJniDlcxstJLXqZaBoPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPrGBhRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPrGBhRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BA21F00893;
	Sat, 12 Sep 2026 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222841;
	bh=889n5f4AvtQZIzTutcoc5+oK1Ls3BtQDWHdFkmmC8vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPrGBhRQLmPzTGfdltc9XmFZfz4MBeJZt3n+Z/LQbnNJmyIaB6fglkY3JOvSPJmXR
	 dYcJiUYHPbHSsxs7m78JBuSbLWSoFt0xKVN9CyAaQhgV0LAh+DbkBVKLZdgCseutyO
	 R1pR5Pjq7RZYQ8SXpMTQQSSDZIqc9uO6RyB49hUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0667/1424] selftests/bpf: Fix memory leak in msg_alloc_iov error path
Date: Sat, 12 Sep 2026 08:51:39 +0200
Message-ID: <20260912065622.231424470@linuxfoundation.org>
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

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit 0bebfaa39deadec21638f6fba553eae12627a26d ]

In msg_alloc_iov(), when calloc() fails for an individual iov_base
allocation, the error path frees all previously allocated iov_base
entries but fails to free the iov array itself that was allocated
with calloc() at the beginning of the function. This results in a
memory leak of the iov array.

Add free(iov) in the unwind_iov error path to ensure proper cleanup
of all allocated memory.

Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260704122936.102394-1-malayarout91@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index dccaf9b8cb900..fcaf7205bd9f3 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -514,6 +514,7 @@ static int msg_alloc_iov(struct msghdr *msg,
 unwind_iov:
 	for (i--; i >= 0 ; i--)
 		free(msg->msg_iov[i].iov_base);
+	free(iov);
 	return -ENOMEM;
 }
 
-- 
2.53.0



