Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444541509BC;
	Tue, 20 Feb 2024 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464660; cv=none; b=Ze/+ptTL0yMFw+C4LHNzFfGDVJ9zTA+pEZfrvBA8N/ozBeWpJeYHdaDJcMe3vI6QAaROfE5dTSpknHCzjpRG6aTVHjhEXTHu5r0CQryrWORzsauI5qD4/PbLpuME7fH1DQtJI5lnmW3Q0OGoqeDrchehkBc2GaciJr2JHsk6v6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464660; c=relaxed/simple;
	bh=wC2Kh5cnoQWNwit2YU3AcAWJlZyolFjvpX4n24FW3jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv/R+BtmYlynUmy4o6as7eI1L1MrZiaTS6pbjGKx7NuWYTZONR4WNqAwU43nFaFlVFen861X+ads5WDqxwtuXRg3axcAsm+Zi0yeLl6AVcnl8wOXCj97ynQ47l7IgnSCshx0d+zeUOZRv5EEFYr5xj22IPPAFeVkHoFMM9pDMs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Yg+Ml63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Yg+Ml63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62ABC433C7;
	Tue, 20 Feb 2024 21:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464660;
	bh=wC2Kh5cnoQWNwit2YU3AcAWJlZyolFjvpX4n24FW3jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Yg+Ml639TMg4B1b1kfV2vmlhArnTYTXMvNn2mlDouGvvSL41HKn2ukd/Vq4t5qc1
	 ut0JtivEF/J8R/sOtYm1SdR5NpjQ8B/9r44PVEwC41cuROMBcsBZfFeu1t3fVZL9Bw
	 kIAgID0Uo5YKW+S825g1pgADnlK9BPa2U6GYfM8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 065/309] selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
Date: Tue, 20 Feb 2024 21:53:44 +0100
Message-ID: <20240220205635.250030237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


