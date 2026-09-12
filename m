Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E023624DE;
	Sat, 12 Sep 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238440; cv=none; b=e5w3DmHz1mwZp5fD9sJ+9kGzMKcY3Gzuq4nm53un1LY1wenOcAtVD/lDDsJvn96yhAsrv1qGJ4P8naaiN6Zr/s67pj+OnYaVRZJxmbNqU5b0jRXQy6k9y7Zhqz5zqTR3W2ZcQjLejOzLevxbkRb1uV+p6/fwyHx0DtP5yNzZvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238440; c=relaxed/simple;
	bh=9ZWOrLSQjWZo00qzQqkrjyEUb0zLiuR7qsQYUNTCA0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ubv7nQ0zW+N4RwYGZDbDZVmvIx+BTGc4XB33RyF6iYXM+Bjfjp0SRThXZY09NmTPK9Au8O6X4om4Yo/Veqifv3pilD2xrM8I7IHoGIO98Adi9s6btIltY6c01sxcBMegCDu5IndbBPp6z8XV1zyaEjeDHCA2oGn5bPxaJc6FnxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJHJfODN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJHJfODN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D01F00899;
	Sat, 12 Sep 2026 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238433;
	bh=kttNQqt5XdKKKKNurviz0mt+mdtXV23q1m1RYyCGWpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJHJfODNQAHr4RG9wqMw5j2w8TN7sYVS2rovSaXyNYxEI02nhg0NnVOb5H8zYOUJH
	 0j8MuO8/UDfmH+i9dxRxsSzt3qFh5CkYAw/XtpB3nt/4VYvBskziZA4VMXDMwea9sZ
	 Vy0hI3fUHmDXY6+GISi+wb+EPPiHoOYrLDIEQTLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/935] selftests/bpf: Fix memory leak in msg_alloc_iov error path
Date: Sat, 12 Sep 2026 08:58:12 +0200
Message-ID: <20260912065537.424330811@linuxfoundation.org>
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
index 2cecd6cd647b0..1033c8a2a459c 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -515,6 +515,7 @@ static int msg_alloc_iov(struct msghdr *msg,
 unwind_iov:
 	for (i--; i >= 0 ; i--)
 		free(msg->msg_iov[i].iov_base);
+	free(iov);
 	return -ENOMEM;
 }
 
-- 
2.53.0



