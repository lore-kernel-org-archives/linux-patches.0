Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53F612D7;
	Tue, 20 Feb 2024 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463571; cv=none; b=AfTr+ldxtGalrYJ9CdWDeKxy3XpMT2MelKz9UBafc3MqtNBWnM1e2eKrRuqgSryPPFOYiXGEk27Ya8mPjuPZcsjV01HMhJ6bFK2tWlHrKMJbk9uk3A4QREbOPrnUiwrt6L0z8TzPFjzTQv8pBzJi8HeYixbt2kVCFmAcE7ebyNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463571; c=relaxed/simple;
	bh=wY2EEy8Jegerr84D9L99pggT9XypAIasFisNCoZKDTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6orXiSX4duKpevoPQm9PQyQ61qglpEpgfpRFMfKtSKJKblZ2Bb0GZ29CFoBP3jJ9FXqFFgFEfUvnZTiL+xf0Cg66lbX5kTH2ZLEaZ2xpFilBIlF269G5es4lmnMNLIKiz1s2a4ZNoPuPqDti/Wl4Y3iAEIYgN4mFF6ZMy0pHWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOYFX0gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOYFX0gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB1C433C7;
	Tue, 20 Feb 2024 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463570;
	bh=wY2EEy8Jegerr84D9L99pggT9XypAIasFisNCoZKDTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOYFX0gV353KQmSLMc6HBrU5DsxVQjnNsO1fV/+McVm9Eh0r4IHNFDn38drCurYaJ
	 VLllN/FGqlixllGxJDEnO96pArrCUC4kCKqI1DIV+gl9iStLx7IyHsTkxLJiea05pj
	 l/UIyF1bWoGhNUY7aCYkGpieCJUkvOckV9cWZT2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 056/331] selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
Date: Tue, 20 Feb 2024 21:52:52 +0100
Message-ID: <20240220205639.353085118@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit d021b442cf312664811783e92b3d5e4548e92a53 upstream.

ksm_tests was previously mmapping a region of memory, aligning the
returned pointer to a PMD boundary, then setting MADV_HUGEPAGE, but was
setting it past the end of the mmapped area due to not taking the pointer
alignment into consideration.  Fix this behaviour.

Up until commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries"), this buggy behavior was (usually) masked because the
alignment difference was always less than PMD-size.  But since the
mentioned commit, `ksm_tests -H -s 100` started failing.

Link: https://lkml.kernel.org/r/20240122120554.3108022-1-ryan.roberts@arm.com
Fixes: 325254899684 ("selftests: vm: add KSM huge pages merging time test")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/ksm_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -566,7 +566,7 @@ static int ksm_merge_hugepages_time(int
 	if (map_ptr_orig == MAP_FAILED)
 		err(2, "initial mmap");
 
-	if (madvise(map_ptr, len + HPAGE_SIZE, MADV_HUGEPAGE))
+	if (madvise(map_ptr, len, MADV_HUGEPAGE))
 		err(2, "MADV_HUGEPAGE");
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);


