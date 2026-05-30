Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357443148DA;
	Sat, 30 May 2026 17:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161256; cv=none; b=R5OIHbSn0uTgf26sri9/BcPb3x14G+Nb7mNGjxLPHhafIppaiRVoK7K+9zHonaX3fFdV41nllDBmp2GhClDD9Mgp9bdkYNFkLFq+Yj3ZDJopaQaXTnZ8wfagS5TEJpcTto/gL2BNJSJNrRxO6GN2xQLVA00iXCv9vFEoLXAZ1bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161256; c=relaxed/simple;
	bh=a5Q/A/13+Owi5IXBqqwhOEWMvQ/MgDq6vD40jxwKIJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8cAAl71UaH+zzIe/PYonKOUkcknCIPjUp7xRBEGXTvNG3NjOorGOzuKPM3AwG6Iy5vr9Mjpfqw7l/8On+jDFiVxkzZ6/DbYrGuoN8dCxPON/hP7otMVhSXfRvc3w4AgXgStaM6We4oZ246avmTkYXaxBPRGOwCCidVxP4HWlGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhTP4CPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhTP4CPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC831F00893;
	Sat, 30 May 2026 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161255;
	bh=YD8oiUH34ymWG2q6j6mROjTbewvKQMMtoKNWU9TaSiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhTP4CPOGxeupry4ZcuQGvLFfrrvDnCo1qG7XBIZ1buovnMP9S/w98/1pwkcsMCk/
	 ImsnezGnyu8LYVVv9DeRmDVXFDCOEakJUVChaikrLxyoFbky+hPbAiZpjDb17ta5u5
	 TQmwq1xM29i1rKV0xh06yfFpX8J5+RE75M7xZiHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AnishMulay <anishm7030@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sayali Patil <sayalip@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 540/969] selftests/mm: skip migration tests if NUMA is unavailable
Date: Sat, 30 May 2026 18:01:04 +0200
Message-ID: <20260530160315.283253300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: AnishMulay <anishm7030@gmail.com>

[ Upstream commit 54218f10dfbe88c8e41c744fd45a756cde60b8c4 ]

Currently, the migration test asserts that numa_available() returns 0.  On
systems where NUMA is not available (returning -1), such as certain ARM64
configurations or single-node systems, this assertion fails and crashes
the test.

Update the test to check the return value of numa_available().  If it is
less than 0, skip the test gracefully instead of failing.

This aligns the behavior with other MM selftests (like rmap) that skip
when NUMA support is missing.

Link: https://lkml.kernel.org/r/20260218163941.13499-1-anishm7030@gmail.com
Fixes: 0c2d08728470 ("mm: add selftests for migration entries")
Signed-off-by: AnishMulay <anishm7030@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/migration.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/migration.c b/tools/testing/selftests/vm/migration.c
index 1cec8425e3caa..6ea9826e6f979 100644
--- a/tools/testing/selftests/vm/migration.c
+++ b/tools/testing/selftests/vm/migration.c
@@ -32,7 +32,8 @@ FIXTURE_SETUP(migration)
 {
 	int n;
 
-	ASSERT_EQ(numa_available(), 0);
+	if (numa_available() < 0)
+		SKIP(return, "NUMA not available");
 	self->nthreads = numa_num_task_cpus() - 1;
 	self->n1 = -1;
 	self->n2 = -1;
-- 
2.53.0



