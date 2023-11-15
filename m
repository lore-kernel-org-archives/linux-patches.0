Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B4364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDccTwjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D67EC433C7;
	Wed, 15 Nov 2023 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076603;
	bh=ARt+bUw/bVW0CWmqMrN5UqzyrDpfLZVG+a8ixj+RqrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDccTwjz4mzEhJFC6My5NMYf6ZUY5vj/xFDmDNrO+6O85t4DkCRhvkFBHAbVvdh2+
	 LWexhNPQvYcqNWLjqJ2JdwbyrYtjH+VmICPmGHiktG26NhwAmnbqlRwA/aq+xiMD/e
	 JsikwBF3oXAEngFdDf4XDiGHmtD86x77X4nSKJ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	David Hildenbrand <david@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Ayush Jain <ayush.jain3@amd.com>,
	Alexey Izbyshev <izbyshev@ispras.ru>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Greg Thelen <gthelen@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	KP Singh <kpsingh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
	Topi Miettinen <toiwoton@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 334/550] kselftest: vm: fix mdwes mmap_FIXED test case
Date: Wed, 15 Nov 2023 14:15:18 -0500
Message-ID: <20231115191623.922548769@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florent Revest <revest@chromium.org>

[ Upstream commit a27e2e2d465e4ed73371974040689ac3e78fe3ee ]

I checked with the original author, the mmap_FIXED test case wasn't
properly tested and fails.  Currently, it maps two consecutive (non
overlapping) pages and expects the second mapping to be denied by MDWE but
these two pages have nothing to do with each other so MDWE is actually out
of the picture here.

What the test actually intended to do was to remap a virtual address using
MAP_FIXED.  However, this operation unmaps the existing mapping and
creates a new one so the va is backed by a new page and MDWE is again out
of the picture, all remappings should succeed.

This patch keeps the test case to make it clear that this situation is
expected to work: MDWE shouldn't block a MAP_FIXED replacement.

Link: https://lkml.kernel.org/r/20230828150858.393570-3-revest@chromium.org
Fixes: 4cf1fe34fd18 ("kselftest: vm: add tests for memory-deny-write-execute")
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ayush Jain <ayush.jain3@amd.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/mdwe_test.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/mdwe_test.c b/tools/testing/selftests/mm/mdwe_test.c
index bc91bef5d254e..0c5e469ae38fa 100644
--- a/tools/testing/selftests/mm/mdwe_test.c
+++ b/tools/testing/selftests/mm/mdwe_test.c
@@ -168,13 +168,10 @@ TEST_F(mdwe, mmap_FIXED)
 	self->p = mmap(NULL, self->size, PROT_READ, self->flags, 0, 0);
 	ASSERT_NE(self->p, MAP_FAILED);
 
-	p = mmap(self->p + self->size, self->size, PROT_READ | PROT_EXEC,
+	/* MAP_FIXED unmaps the existing page before mapping which is allowed */
+	p = mmap(self->p, self->size, PROT_READ | PROT_EXEC,
 		 self->flags | MAP_FIXED, 0, 0);
-	if (variant->enabled) {
-		EXPECT_EQ(p, MAP_FAILED);
-	} else {
-		EXPECT_EQ(p, self->p);
-	}
+	EXPECT_EQ(p, self->p);
 }
 
 TEST_F(mdwe, arm64_BTI)
-- 
2.42.0



