Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8001A76A3;
	Tue, 30 Jul 2024 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359634; cv=none; b=t4S8ZYoqxsbT+RezEscPwTzRSFQIqTW/KeC7htVg0w43ZDh+h2odhl9fzacUoK5zRqvIs7TNhNjOZT70+06sZhkr9xu9EjVIBNfb3MCrb1jcp5NoT/Iz//Q/a1wgacjL1PHCeiLK8Xy+C9a7ADZrq2XBCgJN3hHVSsPfZ2psO0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359634; c=relaxed/simple;
	bh=XgWCA9QhUYuuvC5U9INnZtVaRkZUHGWvqJs+GP4D0GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDEHB9CIAKQt6DQpmtoW8zDviXLbv37Ns/dMyiXbZsfqZcnK/WpsEYHyWA1aUghrcg8BHDi/Ywd2GtUjvWcy/vIe3zA2LXTzRdeO2LJ6mfyJW+BJn9BLA9bNKJB8j5d+mijeKSqx/SbyasZKm8RMwmzPaJ+lNtG8HHPVV/8OKJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOO0nwNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOO0nwNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42662C32782;
	Tue, 30 Jul 2024 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359634;
	bh=XgWCA9QhUYuuvC5U9INnZtVaRkZUHGWvqJs+GP4D0GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOO0nwNa42/w1oV6mPgJXmi5MTVqV737AgJqftirnLLfUBQOZ7I8rtEwwvksuMAQt
	 km7XCvA9+LrKl4yN0j3iRnwoOcXHG8+3XvwWGaWXGIXuaRDHUy6v2cu5Bj2K5klkoJ
	 Ak1a3php5PCRShpKazgF/m67Ll3WaFkNKIFVAroU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 511/809] selftests/damon/access_memory: use user-defined region size
Date: Tue, 30 Jul 2024 17:46:27 +0200
Message-ID: <20240730151744.919959789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 34ec4344a5dabbb39e23e8daf30779892c0211a6 ]

Patch series "selftests/damon: test DAMOS tried regions and
{min,max}_nr_regions".

This patch series fix a minor issue in a program for DAMON selftest, and
implement new functionality selftests for DAMOS tried regions and
{min,max}_nr_regions.  The test for max_nr_regions also test the recovery
from online tuning-caused limit violation, which was fixed by a previous
patch [1] titled "mm/damon/core: merge regions aggressively when
max_nr_regions is unmet".

The first patch fixes a minor problem in the articial memory access
pattern generator for tests.  Following 3 patches (2-4) implement schemes
tried regions test.  Then a couple of patches (5-6) implementing static
setup based {min,max}_nr_regions functionality test follows.  Final two
patches (7-8) implement dynamic max_nr_regions update test.

[1] https://lore.kernel.org/20240624210650.53960C2BBFC@smtp.kernel.org

This patch (of 8):

'access_memory' is an artificial memory access pattern generator for DAMON
tests.  It creates and accesses memory regions that the user specified the
number and size via the command line.  However, real access part of the
program ignores the user-specified size of each region.  Instead, it uses
a hard-coded value, 10 MiB.  Fix it to use user-defined size.

Note that all existing 'access_memory' users are setting the region size
as 10 MiB.  Hence no real problem has happened so far.

Link: https://lkml.kernel.org/r/20240625180538.73134-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240625180538.73134-2-sj@kernel.org
Fixes: b5906f5f7359 ("selftests/damon: add a test for update_schemes_tried_regions sysfs command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/damon/access_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/access_memory.c b/tools/testing/selftests/damon/access_memory.c
index 585a2fa543295..56b17e8fe1be8 100644
--- a/tools/testing/selftests/damon/access_memory.c
+++ b/tools/testing/selftests/damon/access_memory.c
@@ -35,7 +35,7 @@ int main(int argc, char *argv[])
 		start_clock = clock();
 		while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC <
 				access_time_ms)
-			memset(regions[i], i, 1024 * 1024 * 10);
+			memset(regions[i], i, sz_region);
 	}
 	return 0;
 }
-- 
2.43.0



