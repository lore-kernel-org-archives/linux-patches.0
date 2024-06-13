Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8058714A604;
	Thu, 13 Jun 2024 11:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279510; cv=none; b=raUCAjE/mB2CCkqUuwqH1JQHw9DfRKwRys7uohwu/Eq76m/7yxXqUVgUqBjtylIC8t6Kv4jCZdI19IcXx0cZUwh9X4K5bzO84X8Qw5Nypvh6t4q3HK1NEFemfl5tbfjfRdjIyc4wUCcjk5mqn3c12iM6OXSJ8wsIw4V4Ka1K27k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279510; c=relaxed/simple;
	bh=syB6Y75RwE6+kmm/oDWsmEMwoPw/sjpFQGOtxzPXYns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGi4j1ekdKQ75MsUSmf0E4p+JORU+z4RuUB+3uSWBbyWNpgHOOlzTy/xpIGwdElCi2sss/HFRF3znIl3GOxa2IdfLPq1/22kMfadUV0RTCergNfw+0vbNN7dKlfayzwrbeBtSjDh4kK0rwbrdRt1iOybASvbfwH/ZU+mNxCyZrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSE7svkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSE7svkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E6CC2BBFC;
	Thu, 13 Jun 2024 11:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279510;
	bh=syB6Y75RwE6+kmm/oDWsmEMwoPw/sjpFQGOtxzPXYns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSE7svknHdBG8TdYfpLbR7WT/HPqg/utMAPb8cMqUEapFkq4CD9aJtHAvb+0JOelB
	 8Fnxd1pVbRt6siyRQeq05n8FEJq4406u7Rk5UhaaW5qiOgSPtkxnVkdjN0v75g0o7s
	 NA/qKawDitqdm/VJh6wDPbdWXA5EsGe/bAYNKk1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Sri Jayaramappa <sjayaram@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 101/157] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Thu, 13 Jun 2024 13:33:46 +0200
Message-ID: <20240613113231.327699847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

commit 9ad665ef55eaad1ead1406a58a34f615a7c18b5e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/compaction_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -107,6 +107,8 @@ int check_compaction(unsigned long mem_f
 		goto close_fd;
 	}
 
+	lseek(fd, 0, SEEK_SET);
+
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
 		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",


