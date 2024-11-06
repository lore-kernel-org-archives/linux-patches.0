Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10E81D86E8;
	Wed,  6 Nov 2024 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897994; cv=none; b=D3nxVqVtcIx0z9Z7YRCGEpXflrcm+R46fRyPdZuc/K6opFFKtv2Tas4Rbbcnbdbd3Xcy76+7xvpFsHNkN7Wo87hXaEAeO2zPCxHVT/fvPOG1jdVecVr6FvwBbK0d1grC6SMxeykUPrwd4N/AgGqv7/YAEcZJ4YWy8v4MR7CtUe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897994; c=relaxed/simple;
	bh=OJ6PSCcEw4E8K+gMaj8lYQqbbshLJXA+k+1djIKzXiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUsl0Lktv9emBQXJSDC8G9JcpejphjhimgUS/iEHhIWSHQCWlcY4ZgIbTQ8Ib7gBrYiQUYCumd2P488rJkEOZwZNrUNMoVkIrHyWkqDm8V32xRAgQOfvB/ojjU9eh6bmy8FBn/G3O/B4215WgwWyJsTZrJy4NRsrQ9/528x6ddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlfPN18X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlfPN18X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7695C4CECD;
	Wed,  6 Nov 2024 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897994;
	bh=OJ6PSCcEw4E8K+gMaj8lYQqbbshLJXA+k+1djIKzXiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlfPN18XPAivLcxEPDlM6NHtz0GENEvnP+BGJ28txPO+stZJbyW96dSQdJ2Q3WmWf
	 xigowq56OGk5GCfnMvK4OYNI1yurV6KQgmHXoMpZ/beTxU2QHp1vB+WVWWQ0nojiM4
	 S3hNOHc88y865a5vSMHa6FaR8JbfBZqZ5TlIhGkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/462] selftests/bpf: Fix compile error from rlim_t in sk_storage_map.c
Date: Wed,  6 Nov 2024 12:59:41 +0100
Message-ID: <20241106120333.679068055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit d393f9479d4aaab0fa4c3caf513f28685e831f13 ]

Cast 'rlim_t' argument to match expected type of printf() format and avoid
compile errors seen building for mips64el/musl-libc:

  In file included from map_tests/sk_storage_map.c:20:
  map_tests/sk_storage_map.c: In function 'test_sk_storage_map_stress_free':
  map_tests/sk_storage_map.c:414:56: error: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'rlim_t' {aka 'long long unsigned int'} [-Werror=format=]
    414 |                 CHECK(err, "setrlimit(RLIMIT_NOFILE)", "rlim_new:%lu errno:%d",
        |                                                        ^~~~~~~~~~~~~~~~~~~~~~~
    415 |                       rlim_new.rlim_cur, errno);
        |                       ~~~~~~~~~~~~~~~~~
        |                               |
        |                               rlim_t {aka long long unsigned int}
  ./test_maps.h:12:24: note: in definition of macro 'CHECK'
     12 |                 printf(format);                                         \
        |                        ^~~~~~
  map_tests/sk_storage_map.c:414:68: note: format string is defined here
    414 |                 CHECK(err, "setrlimit(RLIMIT_NOFILE)", "rlim_new:%lu errno:%d",
        |                                                                  ~~^
        |                                                                    |
        |                                                                    long unsigned int
        |                                                                  %llu
  cc1: all warnings being treated as errors

Fixes: 51a0e301a563 ("bpf: Add BPF_MAP_TYPE_SK_STORAGE test to test_maps")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/1e00a1fa7acf91b4ca135c4102dc796d518bad86.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/map_tests/sk_storage_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/map_tests/sk_storage_map.c b/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
index e569edc679d88..9228e33cc0db7 100644
--- a/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
+++ b/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
@@ -416,7 +416,7 @@ static void test_sk_storage_map_stress_free(void)
 		rlim_new.rlim_max = rlim_new.rlim_cur + 128;
 		err = setrlimit(RLIMIT_NOFILE, &rlim_new);
 		CHECK(err, "setrlimit(RLIMIT_NOFILE)", "rlim_new:%lu errno:%d",
-		      rlim_new.rlim_cur, errno);
+		      (unsigned long) rlim_new.rlim_cur, errno);
 	}
 
 	err = do_sk_storage_map_stress_free();
-- 
2.43.0



