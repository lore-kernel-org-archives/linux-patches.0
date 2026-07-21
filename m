Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BEC46EC82;
	Tue, 21 Jul 2026 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660932; cv=none; b=XffgrKFoLkWOhADxHTfz8ao43vgzsml2lL9VoX4zNpMS+T0aYbf6rLFwnCXUC9W4+oGfKPmQkdh57EgEmSFjW1gBwLEohbC3iceXRfHpA/31IzMLP66YxsRz7HBSX3sK4gYMvESKNHYX3+M8Uc880QxShXzzaJofUWefF8LRIfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660932; c=relaxed/simple;
	bh=rfAaWODq0tmvCnh0SdaMI+UXQw0K6Vv2JFgS0zx4d7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o50j4vDe6OPtnZqRM+PHnmvGahjk/Ib4aB1fQ7r8JXCgpEFgXgEuF5bCcBuK9y3w1xk1sUXgc/aEq3Z8gPOft8Uqvh2HkuDYgNCGKffSp2mjOXyCy8nu3FGUUVO0VmoVT6eCVkePOe5XYrshA6dhZHxNis6ox8Y4bCuNczukp8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHGEinT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHGEinT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0DF1F000E9;
	Tue, 21 Jul 2026 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660931;
	bh=C37BQLu6P52arHZ+xLmSPd0PqpR9PReIOTnYgy766tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHGEinT7Eo6/9grnxbe/FLn48hRGxPqiI20oQ1s1vqR296i1OudFi+F0SsvNKYogG
	 ztpVA2lWE/S+bz2hEXIb2zTNsP51ORzJT4bjLepvrizZcNGpaSnAtZab78SPXhsmEC
	 LkrRuJOZ3rjQCuAZ5sWK4L9w7uCodpzIPsZoqznk=
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
Subject: [PATCH 7.1 1168/2077] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Tue, 21 Jul 2026 17:14:01 +0200
Message-ID: <20260721152620.371694200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 700fbaa18d44b8..dabaade1eaa0d1 100644
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



