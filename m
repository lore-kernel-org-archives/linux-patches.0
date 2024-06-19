Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DE31419BA;
	Wed, 19 Jun 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803793; cv=none; b=ijWFqVN/ILsEjx/c1obo7tU3q7HvID9MbtUwlMXOeTFEtGLIvQEO8x7FrKDbAYB2+tnnr6Heq2CkBtFRhrs5f+r7whxUshvELkuRKo0MkAuHWfOFDfDbFI3cOJalOFv1IDgmgpiSYaeXf5k4PwR2uV1UnjSLlKKh6TAQpx7TMrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803793; c=relaxed/simple;
	bh=EA+55qf4xs9vDrA3ssG27qOtulUhG9gGk0NFSisWtOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1BxQ7NTKvugTwVLUGuT462/q2dNOevoqq6bjJXVrAe27MVue0m4PNt64+jc+tTOCo9/B1ZPse11pU05mAXdX/TiY3orxacASKxMHo449r4g0UgqxdaAYxljwqiH9OyMXkl1CtUYw6hpfyNqQyodMiurKAj/3O1zjdQg2cuMy9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIzkj1Hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIzkj1Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BA3C2BBFC;
	Wed, 19 Jun 2024 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803792;
	bh=EA+55qf4xs9vDrA3ssG27qOtulUhG9gGk0NFSisWtOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIzkj1HzLyQ36J8qnl6iS+ypH6PL0SjSLWN/peApDmzRoF5l53J/eefS18Ib1VSQZ
	 Pj0QL3QapELHqpNj2W/kC4XlQiJajOy3G7w+Pq2awc9NILj1E3O0xiOmMc2gWYtV1E
	 kzZxcBRLZQRpIj/TDvLv/aKh0DUJTlvoJgj9HP5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Sri Jayaramappa <sjayaram@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/217] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Wed, 19 Jun 2024 14:55:17 +0200
Message-ID: <20240619125559.540404013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dev Jain <dev.jain@arm.com>

[ Upstream commit 9ad665ef55eaad1ead1406a58a34f615a7c18b5e ]

Currently, the test tries to set nr_hugepages to zero, but that is not
actually done because the file offset is not reset after read().  Fix that
using lseek().

Link: https://lkml.kernel.org/r/20240521074358.675031-3-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/compaction_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/vm/compaction_test.c b/tools/testing/selftests/vm/compaction_test.c
index 9b420140ba2ba..55dec92e1e58c 100644
--- a/tools/testing/selftests/vm/compaction_test.c
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -103,6 +103,8 @@ int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 		goto close_fd;
 	}
 
+	lseek(fd, 0, SEEK_SET);
+
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
 		perror("Failed to write 0 to /proc/sys/vm/nr_hugepages\n");
-- 
2.43.0



