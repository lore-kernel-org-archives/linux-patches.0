Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E70372B31;
	Wed, 20 May 2026 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295971; cv=none; b=N/gTzzk/mFiGF34JOZM6T3PzxmHJnZ4P+WH0qOkatoluVtMA8lCpwmqRWAmmastuon6cEiIRz8BITjSO8J5w+KrHY634pciMy+6ekOXu2W/y+OeaEqWyzT3QzoUFkdtso44b66MRs5IBfE3Kj21ICS6zBz4kKi/2qo7HMaQkAis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295971; c=relaxed/simple;
	bh=n0H50bmamBUehvnTNWJXsVmniQmf8s0mHxejOWrZigw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBEWbRAVmIwLNboEijZnLtcoMkMpPjkJzoUU7bfTO3mFoCCV5+wp/Ob/G1YJjD6eI04CnyNumLvFz9/LUsZ+0J5E/oIuWktotfAaC9xM5kfTmG35M9Jgdx+HtnrqRTKeeMaX6dlmyrYYJUf5MObeCx8K7O1IA9DxkES98bkNXds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEUVBJOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEUVBJOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472D71F000E9;
	Wed, 20 May 2026 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295970;
	bh=Wn95Ba/PWkRDBaiXM0PdaY7b3fTJuLj6i6XhKJoYSY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEUVBJOjHCqbs8NZYvg9ywcD9UOvZxnQ6dSZ4VSKxnxQNfIMgJPFKpiDvuwq2nzt8
	 /it2I8+nwt/id4JxI5jVqJnLqOqavyYGf30RX+xSZQHHWFLFvj6mrypyCMTBIf2q49
	 LBkZsxnDi8OJPZn4nh8tAj2r2O97XEjFAGP5RM84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangguangju <wangguangju@hygon.cn>,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0622/1146] perf trace: Fix IS_ERR() vs NULL check bug
Date: Wed, 20 May 2026 18:14:32 +0200
Message-ID: <20260520162202.259760360@linuxfoundation.org>
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

From: wangguangju <wangguangju@hygon.cn>

[ Upstream commit 96f202eab8133f94479b14a32902c636e9bdf6af ]

The alloc_syscall_stats() function always returns an error pointer
(ERR_PTR) on failure.

So replace NULL check with IS_ERR() check after calling
delete_syscall_stats() function.

Fixes: ef2da619b132c6f74 ("perf trace: Convert syscall_stats to hashmap")
Signed-off-by: wangguangju <wangguangju@hygon.cn>
Reviewed-by: Howard Chu <howardchu95@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 311d9da9896a4..295b272c6c299 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1573,7 +1573,7 @@ static void delete_syscall_stats(struct hashmap *syscall_stats)
 	struct hashmap_entry *pos;
 	size_t bkt;
 
-	if (syscall_stats == NULL)
+	if (IS_ERR(syscall_stats))
 		return;
 
 	hashmap__for_each_entry(syscall_stats, pos, bkt)
-- 
2.53.0



