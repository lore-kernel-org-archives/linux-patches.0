Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6778017B41B;
	Wed,  3 Jul 2024 10:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003827; cv=none; b=DTwHPx8FrQ/XKUlSN+zyBttcZ9qEleqP+3E1cumENv41tPkdNohVlB8HWwmgiyGk1WCBQrSy4bjVXIis+crrCWZ0EvJY/GqYYy4zkgJFgfibdP3l5ytg71DivS+spg8b5sfPWtuzjecxTVXf0lcvwHaDrMGzxLppXyXmg8Sq6vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003827; c=relaxed/simple;
	bh=tMxYDyk2hMOM8r5nSM/8FjVqnVG7gvq8rfStwEZlM7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXQtdFNYI5PvdoKH27uRg7V9hBekStJGAYBxMjFOyKN00c+nk/NRUTVGkWn1vIWceHbf9S+rgVIGYVDsPcrkJuLy5G3ZKpSdzNZsEajaUMsueplgjnKpawoq+qjHw78+R1rsZB1/5n4EhF9yRBi8JEnqTNhr5FEvQWCEwf8yyWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPtU/I8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPtU/I8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8376C2BD10;
	Wed,  3 Jul 2024 10:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003827;
	bh=tMxYDyk2hMOM8r5nSM/8FjVqnVG7gvq8rfStwEZlM7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPtU/I8Rzy++TU0ncaUeYFZnNlkqNnv0G2A8hPJP107JvjYW0Rb/mTKXWjH+4yOlw
	 qT+BAAG6Q6uXCT+hENPrwbWeDJklyjYGWZmSCpN7Wg+kNScMYMrTNBK9FFWYUUtUJo
	 RHhOx93XxzL/xT0Vvb0lNMDoudz9E7TCl+QOZSys=
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
Subject: [PATCH 5.4 034/189] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Wed,  3 Jul 2024 12:38:15 +0200
Message-ID: <20240703102842.795547312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



