Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB96481DD;
	Mon,  4 Aug 2025 00:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267320; cv=none; b=foKA925+1MNsBOJKzodshpsZ1wTS7DAt1XCSma94DoLPh8X+VAzWbbo0GUctNYsuwN1k8gRXyJdTfnV1ByzKUQjzWx//IHPkbCe1HfPq49RV2r3mXU7gq2SSosDCLpcSd6tyiGaqsv/7qE8B3bkYKq28eRD1TScsbxM8bi94P1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267320; c=relaxed/simple;
	bh=rGuC4G/A/foKMlucrLetUjcWCEVkTC4GXyn+FF5LiEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LpCtiaV46zQqk2jrluVyeOBc4AltyUJkisePsjWv9v59fI/+ob1MbYtaGfHyZN7FYzjU0P2AAy0//JT6gAqLcBqnrvT7JvC2f2q01S46k84b71eWGbLaw3UKdui7T2HjcR8K+dncivP/rJvykDHwVIZmxo+jukuvIYIJpdF8Qp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBZHg5cF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBZHg5cF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA94BC4CEF0;
	Mon,  4 Aug 2025 00:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267319;
	bh=rGuC4G/A/foKMlucrLetUjcWCEVkTC4GXyn+FF5LiEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBZHg5cFRgy2vEh2m5IFS7hyVC/HyCJuEIPZ9Jtm1a5Es/q8gqbF7jKa7tu7zI3O1
	 J4cBa9aH6f4LOYjEjyi6z3pg8Oua0L6Go/j9dqmPwVQvTjc0Yb42sks5VzvV9BcLfW
	 ZDufQm+JnoVtWeJR1oc1lchC4XuuGRtX+hzHtXYGmW6kjF7kyHs1BJCmvP+juqacVR
	 xpxUcIr5mHt2O0aY6R2NMIKK/lpwJbgekCPnfp5BjaVIs3LvkLZf7PKdh9GWcY+Sul
	 1A+CqoWH4ea5vHyIPnV+Zvd1iNDyAMTqjoMgNlr94Jx7cO8RPjJoOvcWyquyG3N9VC
	 l/hqpdq73bSiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiffany Yang <ynaffit@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	arve@android.com,
	tkjos@android.com,
	maco@android.com,
	joelagnelf@nvidia.com,
	surenb@google.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 17/80] binder: Fix selftest page indexing
Date: Sun,  3 Aug 2025 20:26:44 -0400
Message-Id: <20250804002747.3617039-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Tiffany Yang <ynaffit@google.com>

[ Upstream commit bea3e7bfa2957d986683543cbf57092715f9a91b ]

The binder allocator selftest was only checking the last page of buffers
that ended on a page boundary. Correct the page indexing to account for
buffers that are not page-aligned.

Signed-off-by: Tiffany Yang <ynaffit@google.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20250714185321.2417234-2-ynaffit@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit fixes a genuine bug in the binder allocator selftest that
causes incorrect page boundary checking. The bug is an off-by-one error
in the page indexing calculation.

**Detailed Analysis:**

1. **Bug Description**: The original code uses `i < end / PAGE_SIZE`
   which misses checking the last page when buffers end exactly on a
   page boundary. For example:
   - If `end = 8192` (exactly 2 pages), `end / PAGE_SIZE = 2`, so the
     loop checks pages 0 and 1
   - However, when a buffer ends at byte 8192, it actually spans into
     the third page (pages 0, 1, and 2)
   - The fix `i <= (end - 1) / PAGE_SIZE` correctly calculates the last
     page index

2. **Impact**: This bug causes the selftest to skip validation of the
   last page for buffers that end on page boundaries, potentially
   missing memory allocation issues that the selftest is designed to
   catch.

3. **Fix Quality**: The fix is minimal (single line change),
   mathematically correct, and focused solely on fixing the indexing bug
   without introducing new functionality.

4. **Backport Criteria Met**:
   - **Bug fix**: Yes - fixes incorrect test coverage
   - **Small and contained**: Yes - single line change in selftest code
   - **No architectural changes**: Yes - simple indexing fix
   - **Minimal regression risk**: Yes - only affects selftest code, not
     production binder functionality
   - **Clear benefit**: Yes - ensures proper testing coverage for memory
     allocation

5. **Additional Evidence**:
   - The commit is acked by Carlos Llamas, a binder maintainer
   - The fix is in selftest code, which has lower risk than production
     code changes
   - The mathematical correction is straightforward and verifiable

This is an ideal candidate for stable backporting as it fixes a testing
gap that could allow memory allocation bugs to go undetected in stable
kernels.

 drivers/android/binder_alloc_selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder_alloc_selftest.c b/drivers/android/binder_alloc_selftest.c
index c88735c54848..486af3ec3c02 100644
--- a/drivers/android/binder_alloc_selftest.c
+++ b/drivers/android/binder_alloc_selftest.c
@@ -142,12 +142,12 @@ static void binder_selftest_free_buf(struct binder_alloc *alloc,
 	for (i = 0; i < BUFFER_NUM; i++)
 		binder_alloc_free_buf(alloc, buffers[seq[i]]);
 
-	for (i = 0; i < end / PAGE_SIZE; i++) {
 		/**
 		 * Error message on a free page can be false positive
 		 * if binder shrinker ran during binder_alloc_free_buf
 		 * calls above.
 		 */
+	for (i = 0; i <= (end - 1) / PAGE_SIZE; i++) {
 		if (list_empty(page_to_lru(alloc->pages[i]))) {
 			pr_err_size_seq(sizes, seq);
 			pr_err("expect lru but is %s at page index %d\n",
-- 
2.39.5

