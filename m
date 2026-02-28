Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B76342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301846; cv=none; b=vFeRvXQyxpZJkKlcqriY9gcoVxN8jl2enCMHCK42faD3jKpwgOX5VPz9xjptnzcUnlUgLmAQ4Z7lv17HtTyEW0RzavioqucmoHJlaqFMKAfYVFSmUGvSl4PgoFomkx1Y5m7EhzpkuYmA797ke0glLGY3erDjpT7htbeEack7B+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301846; c=relaxed/simple;
	bh=2hi+ZXcW4Ila6xOPfO4NcgV3nBf80MmAowItQKrowqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGui5WDSCAMqzrc9yoXJylW+b4Ap5Spy8iL5+A0EUTZ2dCqAg11E1FATuUkC/2VKZpQLMDFjaGqeLszjB7XQ//sg00NrjlCAPuCEWtl/m1Da6GkQzo4yXQ4b0MX8MMnlTbnaItuIXq6vC7q4x32+vb4puT4Zz4/X7NZ36L5Wnq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twQnOfUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twQnOfUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC41C19424;
	Sat, 28 Feb 2026 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301846;
	bh=2hi+ZXcW4Ila6xOPfO4NcgV3nBf80MmAowItQKrowqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twQnOfUeAiIFAepiCt0+Y5Hysh6mSCyDj4QK2BesuxNfRwOB/eFC/YAjbwHdTbS/h
	 qnCDQh7nIMpG/vzDEiN+mJmDsh4MRmtOolwEkF7hluWYhFAtls8X5p0NOIhqzzG85p
	 SdkLDBZGYZBXUhDEq4nu34+pAMzCB4SS+6TJjIT8J8RRspKsdBPcOUaFVAzJbngSnS
	 pb0ZKg8Ok0Vel24hCzUmJHNtGpVEKXPH5oNWdgnLN0N3MKpuWtvbQykngg7Y8bgrxP
	 rf4UIYFIrP/DheIMdc9ZkzHSNbZZgiJRNL8CelFDQ7Lmm1lyzlnoJVzl/9IZ9M8mTc
	 OwKDacVE3ymSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Malaya Kumar Rout <mrout@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/385] tools/power/x86/intel-speed-select: Fix file descriptor leak in isolate_cpus()
Date: Sat, 28 Feb 2026 12:58:08 -0500
Message-ID: <20260228180011.1568201-266-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Malaya Kumar Rout <mrout@redhat.com>

[ Upstream commit 56c17ee151c6e1a73d77e15b82a8e2130cd8dd16 ]

The file descriptor opened in isolate_cpus() when (!level) is true was
not being closed before returning, causing a file descriptor leak in
both the error path and the success path.

When write() fails at line 950, the function returns at line 953 without
closing the file descriptor. Similarly, on success, the function returns
at line 956 without closing the file descriptor.

Add close(fd) calls before both return statements to fix the resource
leak. This follows the same pattern used elsewhere in the same function
where file descriptors are properly closed before returning (see lines
1005 and 1027).

Fixes: 997074df658e ("tools/power/x86/intel-speed-select: Use cgroup v2 isolation")
Signed-off-by: Malaya Kumar Rout <mrout@redhat.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 5127be34869eb..07729d376f018 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -932,9 +932,11 @@ int isolate_cpus(struct isst_id *id, int mask_size, cpu_set_t *cpu_mask, int lev
 		ret = write(fd, "member", strlen("member"));
 		if (ret == -1) {
 			printf("Can't update to member\n");
+			close(fd);
 			return ret;
 		}
 
+		close(fd);
 		return 0;
 	}
 
-- 
2.51.0

