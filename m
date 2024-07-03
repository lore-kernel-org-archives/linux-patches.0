Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A7197559;
	Wed,  3 Jul 2024 11:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004413; cv=none; b=Km9FeOzASrLf25e9fdjbbVDMi3EpkpW7Z300Pmg/qBx2Ukb46VR+m76vHnZBGlFdGyR7NZRIVc0dRyqSPHq4kBthYCCHJSXKJW62RsCDOVNIh0e1ouviyOKJuSRtcvaw8mQhCH4Yssr8RxCtkHEHum4zLtSfXSXNMXyCiuN3RsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004413; c=relaxed/simple;
	bh=qQBRK5orJOaasjtacMavLvQHoa8edKm7vmQokHLXhsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7rciM2mnpY78JMAf4hyrrsZmgkoHkxrjRPiBY0JuGCjuyIuhOyTxZJPr2YrRaxO1SIKTSDQyKpmlsc+WseAVBGjf1Yq5YMqpCl/Rschb68m/DYweCMSpZ7bzGIPcjk022I6wTozKwplIMtNHDBx1ki+85vwp4bu4cmOMl245fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXpjPXy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXpjPXy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE2AC32781;
	Wed,  3 Jul 2024 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004412;
	bh=qQBRK5orJOaasjtacMavLvQHoa8edKm7vmQokHLXhsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXpjPXy2y5vsa2zNIhjj2XGPxsjH2eNmoFYG/QskoWdavYNOBn3jM85z88G9aef1B
	 50PUpOfQ7WV7802OJ2N5CcSp2aJRJZEmI38rhrmyqmo/kJM88IW1XWOGdptT+vYngg
	 PqKLBBgl1d1xah5XHFoRG/ZCxeMJVLirnoJqmSUk=
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
Subject: [PATCH 5.10 034/290] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Wed,  3 Jul 2024 12:36:55 +0200
Message-ID: <20240703102905.486816193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



