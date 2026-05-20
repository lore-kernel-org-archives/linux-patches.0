Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F091834216C;
	Wed, 20 May 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295964; cv=none; b=E7aRbQvvx6eCCJ8ZuKWXe8CuQnnGJp/RFy7VK39rVCp2q8LcgCd3YL9LuZCwmGzGodk20l5tALQSqS1JNCplXAghmx3zWBDcrrUPfAk9EGIUKZjU2kR5pfdKqmA803b511Rx5Rmd0CaeAldaqsBHoUnCgZpS4XVB4g8/hHba6cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295964; c=relaxed/simple;
	bh=sdn621/DKpaig8m/n+nzHoGJ8Rx8NaekHPA+mooyYII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVTXHHaRD0iuM/9B+chKZTmJbaR5iPmtgnh4tskOqzrXPA4AaVzKVehaGwPKw8UYU+3eQOLP0GnvNtYz/WdMIYsSL4yHwCh6bPtK1Xu9qHKiKEnGLL9cvLJov1E+2bLK3ea6itXOdnIQ8U9oF8CinrW8fXm/YnuHhfBVKMsjGLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiXyRPYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiXyRPYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C931F000E9;
	Wed, 20 May 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295962;
	bh=s3yhkyL5ESWBRFRB2F0ftY5i8dOqijlcBLNnPNTmIVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiXyRPYVvk0HjIbejAH2lKfGzzhhDPsRTMIXkXPEqmqyrJCRRPI1ZyosG9rO7wc2k
	 0vVMnDjN5Us135yEqyWHibKe9AVS3x0YpvhtSpBpyrNnhhA+sQ1lVy4XyGLo139w3X
	 39xYyTWVGuZRJjWcFqxc1FSvWcCrvFaxO+Go7keI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0620/1146] bpf: Validate node_id in arena_alloc_pages()
Date: Wed, 20 May 2026 18:14:30 +0200
Message-ID: <20260520162202.217568853@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 2845989f2ebaf7848e4eccf9a779daf3156ea0a5 ]

arena_alloc_pages() accepts a plain int node_id and forwards it through
the entire allocation chain without any bounds checking.

Validate node_id before passing it down the allocation chain in
arena_alloc_pages().

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260417152135.1383754-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 9c68c9b0b24ad..523c3a61063bf 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -562,6 +562,10 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	u32 uaddr32;
 	int ret, i;
 
+	if (node_id != NUMA_NO_NODE &&
+	    ((unsigned int)node_id >= nr_node_ids || !node_online(node_id)))
+		return 0;
+
 	if (page_cnt > page_cnt_max)
 		return 0;
 
-- 
2.53.0



