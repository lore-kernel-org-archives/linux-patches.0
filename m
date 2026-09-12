Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461A747A87A;
	Sat, 12 Sep 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229224; cv=none; b=hM42HuOyWvPoJWifdHMieYdNxi4tPPTR8uxxrRUwKnPlTlAEf7SCjVHLVwqKU6Tl/J8qgxYz8IQulJqXIqWBePJKBOGIT6yPFQ3Lt+0kfwjclkR64EHC7ZtY98ceCvKJOsROeS2lAiY1qSdkuLMlYqeWpdt9/42qtv2Hjp8MK9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229224; c=relaxed/simple;
	bh=R4ICqhwCRs5ulNNmzZhGg4f1VunDrT4LNsyBdnzJFTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5ERO91p0CjuFYXwYhH0Tbcu4Up8x7dmS1LHuDui9eLcURLABSYsMVSi8V++5Rx9K+rHJ7s/UVCMu573ByxRig6/21+8A1t+voHtDXsT5kpND00uSrB+puT4soUUSVNmniPN29bi8CVbZhw4ojuIJh3IOkjeDFczN/hQiiP1mk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER8VLHoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER8VLHoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012DC1F00893;
	Sat, 12 Sep 2026 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229221;
	bh=co2tI5r4SrUk1nvrKo8itpb8Zd5FZ4tXG3fdFphnOCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ER8VLHoGVw0YhigqXE05zmBREBNJkRmoTvfZquRI4Vb1t8fzXNwAsMc0oSmlMiElb
	 vrar00SyyKaUcQGEmoNDkufI+V0S/sa4/bmOsUPovy8xr3fJbJzwvLwndWqfiMBD0q
	 qmqdUeQ/4RTtBWuB1SdwKXIi5cdXyfvYtKf1jWNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0545/1191] selftests/bpf: Fix memory leak in msg_alloc_iov error path
Date: Sat, 12 Sep 2026 08:54:33 +0200
Message-ID: <20260912065600.486258260@linuxfoundation.org>
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
index d0284ef699bb2..664be1f108dc3 100644
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



