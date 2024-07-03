Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6311802DF;
	Wed,  3 Jul 2024 10:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003409; cv=none; b=u6WttagEuIkkMjHJjHVfSAUYUa2jXrcqcBzO4HRy49t5eHOkWF/qALkiCXYglpDqV+spLE1hO3kA+O7r9gWa3sbZ4nWjmsP+0ld5HUFhe3KcRoGaKdmiLenTnBAn4EoVBd0+aO9kjtsVpiW/yJc2r2iEyo18Y/3mur1Jph5JEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003409; c=relaxed/simple;
	bh=SfbabCfHcBKIVd7EyMwzHMfaqxd1zDK8njlatPC7Yz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1oU+AEs61KBMYE+8NdketC5hPbe0DYxw0lHHyDhw01smRKUB8QEpbfDc1t/W0b+M1f09B1f2xmTHYjryGcUpsN7nC+9ZNBGDNzxuKO1/aNNQfs0zY8xCP5c1TbmQY9jWYJLyrDHKRsbwKRMVdi7quIO4QaZtEkgTZz9b5TufkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRrO0eza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRrO0eza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61808C4AF0C;
	Wed,  3 Jul 2024 10:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003408;
	bh=SfbabCfHcBKIVd7EyMwzHMfaqxd1zDK8njlatPC7Yz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRrO0ezagZQv0ZRqao6XvarvDY3FTehwmQZuOfe713aNQ0vrNbqbHxCZamHK6VHZw
	 GIa60lt8JZ3IJHUwneaOqveGuXOuPD8iFxu7INp6OjoBhwfMw9UEgjHrmkzHpodB2d
	 wa1wupbY7SKDN9UYtFY3BI8bCX6GJUDU686ri1Vo=
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
Subject: [PATCH 4.19 022/139] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Wed,  3 Jul 2024 12:38:39 +0200
Message-ID: <20240703102831.278385466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index bcec712508731..cb2db2102dd26 100644
--- a/tools/testing/selftests/vm/compaction_test.c
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -102,6 +102,8 @@ int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 		goto close_fd;
 	}
 
+	lseek(fd, 0, SEEK_SET);
+
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
 		perror("Failed to write 0 to /proc/sys/vm/nr_hugepages\n");
-- 
2.43.0



