Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D717334E;
	Wed,  3 Jul 2024 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005391; cv=none; b=kwJM0BqJmBhbhnoz60qbzdGqGe54PYKNXfIWpwMWmfwtrjCdAS35CE5K3kS5ktie9L9pQX2OjhdvBnRsjlyFmIpuDMiP574MX8uUaNiHmqAJZTk28NCYnM/B9QF3PGebXwCVKgyLm2XHqBt/kiJxFKlnmMDkiUFBzLJEetEZdz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005391; c=relaxed/simple;
	bh=FUSBJSdO0KuVekIkpaoztXeyiSzb9F/O6ujMM4ygjrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0FqOXMnuuMG03iW1fyqqOm+RCvyBMkqy5cXZk75j5k+SCzk1a2kETeCaWi4arkvOipUmLbhDpH87F+pnbbewdTB4zD7SaiPBsRVz/KFe6ZyPN+xO5/vLEkyBX+2cWlBWhqP6dR8QaxUZ53q+orCeFwr2kWBPKU7SpiCqSKDDCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ6gos03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ6gos03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92A1C2BD10;
	Wed,  3 Jul 2024 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005391;
	bh=FUSBJSdO0KuVekIkpaoztXeyiSzb9F/O6ujMM4ygjrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ6gos03oUgrXRJOjlSEUOeTnJMJ7IdjVOzl6J8nJE0L3Sa5YsYDUWBVPP/GhuhhW
	 6Gn6TbrPutx72FRTalP7/PAh9qSFlMU99N0AnyySIzTvoPViG11STvE19oKcINTBOd
	 WxFH0TjrQFkIjEN8hqs+CO0sIqLRtTXacZ3g+fho=
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
Subject: [PATCH 5.15 065/356] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Wed,  3 Jul 2024 12:36:41 +0200
Message-ID: <20240703102915.560083925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



