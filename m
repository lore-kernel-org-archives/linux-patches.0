Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0FE343893;
	Sat, 12 Sep 2026 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214949; cv=none; b=YXmcPYlfV+KODnHNq1nbh8SpbjxHEAdvIx2wQKGayLx0MgVvwUHZew83t4Tfg3SR1rhIMTUzomMmcrvHuIU5SQSqj0Fy190Lu9gkt+/5d4SORb9McUoUFkMQsfh9kI3+CKUM06pvD2ml22wAFtX7QpidSpMdFpMlBy6oRZHe5IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214949; c=relaxed/simple;
	bh=MKwr0uliz5KUw0lyM3W0r+KIrSYS7K3nP8d/b8nD8Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZXjQxUcrMQhIPgYn/GRxjEhJTn4vdD9npeNArhRLlpVxx3trtgUi22gDLPNyFYACcbzMQoOqbHgI3FakSdIMdp14Wne/OeRdIapAboBinResQwY9qcr25+4qJrZU1I+hFc7LNpH6YV/lnA1LYA/9n1aw7/REmRuiVASYT57liw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJgyXwip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJgyXwip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604441F000FF;
	Sat, 12 Sep 2026 12:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214948;
	bh=SzqGvQan9wLpiI9gvfWYLmQOUtO+pjnUH/NOYtNbNuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJgyXwippUG/EMRfyfendYGKEsbyKse9mIYLuIqrp89sqrkja5rXYXBmtQ3cIfY1I
	 3BnJ4ICxyzTbwCnGhCSRdp01ebTmqBEL1r9WQCFP38pdXKndpmUmDvIKXqSIdGcMb9
	 5sc2UcxXLBaSBrsLBl08u62+AH2WpE6dJc7VselU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0432/1376] selftests/bpf: Fix memory leak in msg_alloc_iov error path
Date: Sat, 12 Sep 2026 08:47:38 +0200
Message-ID: <20260912065617.161781182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61a747afcd05f..a45c96e92a42f 100644
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



