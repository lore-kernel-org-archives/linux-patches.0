Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58B11519B4;
	Wed,  5 Feb 2025 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767997; cv=none; b=UuapjNvPGND1YEJ/Cz4N+DNWZKSZVZZq/OYCABoNcaBItPnwwik4MAr314mgi2MlbbdgNiokqzVg0RMju8+BykTpDoVnkKOlbxQv7C3ogpjO1xfK+w23du2HgXZE+yZzVY9wUyKjCllKFqw1sBhZ9tZgR5aCgU9UXl1xpD0JhPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767997; c=relaxed/simple;
	bh=GYZ7n37zGUU7VE1AtKQsz+M3Xq9Z1F3C41/1/AuYtEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8YmXd52J94mtaCBUlpSD2ImD2V7W9mjXwWSUuxDpqO2vwKt82BJTzqtIwdPerOYkUcrtZYNsSshlDgWFtdXdbSTvbdRmPNLwmDjQW70rT9dS2qQq4nIF5fFxq8Axxaf74NLIssgvz4gbLbMDep+qPLjwC3oB3eA0nESlLJALf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phPD6bp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phPD6bp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D7BC4CED6;
	Wed,  5 Feb 2025 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767997;
	bh=GYZ7n37zGUU7VE1AtKQsz+M3Xq9Z1F3C41/1/AuYtEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phPD6bp6VtwCBGRBmYDkgeG2YVqlIopnNjzd7eAWE5BlKhRp9XysLwwbJNMt6sJgx
	 VbUdnR2auPUCv/4ntBqlCnpjj71ZZix/+m+A2s+JSkf3ZOJGYscGH5sbB+IC/FY8aD
	 vnS5Ykl28Pguh76nnfpO6whf5G/wDsuO8O9mD3Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Wang <00107082@163.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Yu Zhao <yuzhao@google.com>,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 482/623] alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled
Date: Wed,  5 Feb 2025 14:43:44 +0100
Message-ID: <20250205134514.657690718@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 07438779313caafe52ac1a1a6958d735a5938988 ]

When memory allocation profiling is disabled there is no need to update
current->alloc_tag and these manipulations add unnecessary overhead.  Fix
the overhead by skipping these extra updates.

I ran comprehensive testing on Pixel 6 on Big, Medium and Little cores:

                 Overhead before fixes            Overhead after fixes
                 slab alloc      page alloc          slab alloc      page alloc
Big               6.21%           5.32%                3.31%          4.93%
Medium            4.51%           5.05%                3.79%          4.39%
Little            7.62%           1.82%                6.68%          1.02%

This is an allocation microbenchmark doing allocations in a tight loop.
Not a really realistic scenario and useful only to make performance
comparisons.

Link: https://lkml.kernel.org/r/20241226211639.1357704-1-surenb@google.com
Fixes: b951aaff5035 ("mm: enable page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/alloc_tag.h | 11 ++++++++---
 lib/alloc_tag.c           |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 0bbbe537c5f9f..a946e0203e6d6 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -224,9 +224,14 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
 
 #define alloc_hooks_tag(_tag, _do_alloc)				\
 ({									\
-	struct alloc_tag * __maybe_unused _old = alloc_tag_save(_tag);	\
-	typeof(_do_alloc) _res = _do_alloc;				\
-	alloc_tag_restore(_tag, _old);					\
+	typeof(_do_alloc) _res;						\
+	if (mem_alloc_profiling_enabled()) {				\
+		struct alloc_tag * __maybe_unused _old;			\
+		_old = alloc_tag_save(_tag);				\
+		_res = _do_alloc;					\
+		alloc_tag_restore(_tag, _old);				\
+	} else								\
+		_res = _do_alloc;					\
 	_res;								\
 })
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 65e706e1bc199..4e5d7af3eaa22 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -29,6 +29,8 @@ EXPORT_SYMBOL(_shared_alloc_tag);
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
+EXPORT_SYMBOL(mem_alloc_profiling_key);
+
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
-- 
2.39.5



