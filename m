Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B8447125C;
	Tue, 21 Jul 2026 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657684; cv=none; b=tckw2ki8j8HnuWAAuPjHwwJm0+b7HYPh9sVz0R1oeppt19AuQefaYACywFONFjdImfX6ocf8gJ358TFt1LWN+bomX0dl17pJyJ+TYIL6v7L+MxDYwXFcB/E+QjVQv8uchvnLD6VF7OCnwH0Ch5CEHtM+1eW2nYnRQhHeCG1d8is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657684; c=relaxed/simple;
	bh=GGzyd6/GZ1HPiznjMcAa7fg+Vb1RtC0WGtLBlh4PIXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EldwHZchS4EW8nCdW4GEKM9i2Q4Yu+PLvQ5wDkHyw1zWtH8IzWMBBfh7gYV5lV6AHcV0qMK1fN8/2wG8b/+fPwp7K0r9h/Ik+bWgb4b5f7OId/A1KHOpiytzC7O/dGd4WKMBNV8PwMfdDwAg0EK0Hr6mXgdS/gQRb9jRhqpxS1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8IBmZim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8IBmZim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2991F000E9;
	Tue, 21 Jul 2026 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657683;
	bh=5HY7IZsg2zTLghJmCrlpXj5EJBjWc1uEu8y/VSWfctc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8IBmZimfX4zgDUzwAaJDXXHnQGz4X9fDl/BzzBonqWxAOxLMVNjglte2ODMmWRzF
	 Z3PvsgkPamolFJX5M5t/cI8SYiJkKtj+mF+aS17dcxw6YEehCJzHPQXn+AyP2WE9yR
	 c9Afx0x29OZ599bdaiXt31aJEPxxFjTNfBZRxHpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0858/1611] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Tue, 21 Jul 2026 17:16:14 +0200
Message-ID: <20260721152534.688652813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit f3bd00507f226a419125df6064632bcbd47d8e70 ]

uffd-stress currently fails when the computed nr_pages_per_cpu evaluates
to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g.  1GB) and a high
number of CPUs, where the total allocated memory is sufficient overall but
not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources rather
than incorrect kernel behaviour.  Update the test to treat this condition
as a test skip instead of reporting an error.

[sayalip@linux.ibm.com: use ksft_exit_skip() instead of KSFT_SKIP]
  Link: https://lore.kernel.org/88202b56-1dc5-43e2-9d1f-a0823a9531f0@linux.ibm.com
Link: https://lore.kernel.org/0707e9a0f1b3dd904c4a069b91db317f9c160faa.1779296493.git.sayalip@linux.ibm.com
Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index b51c89e1cd1ae4..73af98ef6850cd 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,8 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_exit_skip("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
 	}
 
 	bounces = atoi(argv[3]);
-- 
2.53.0



