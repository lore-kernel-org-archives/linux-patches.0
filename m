Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCDC1D04A3;
	Wed,  2 Oct 2024 13:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875914; cv=none; b=nURGCJVmytJIyOKEHbjzzNhgu2r8uB1RY1+sUc9nKzUVDKlzgW86HKMnEazUofHoMSFDGDoZptSG4GPb71DBfnb9/6FiHrIv6xfpqg3DnGL6a+l4uiI45FH2ONEtkJPxs8PGHSh7TiQF/AgWmatEu9gVLqkdEnNlEgQLpJjPeGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875914; c=relaxed/simple;
	bh=eGM9e+i8BwsW/xldjvNOYHDr0f5Y0xhDhHnL5tXGipo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcruoh3ApR8BB6herrzQHhBq1bnrf011XmFQ4bF0u5uYDcpOzHawJgL2aS34Golh2YotLemE9NbJxknjNwS/tUSa8JZGr21/HDp1yIy9kOlU0dKvQUBzxnhO8HlhT/AO/93HlZ4P6w0Lsl1EvfZKPa32xeC+y3m4UbDbI4LA5i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSnHBg7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSnHBg7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14743C4CECD;
	Wed,  2 Oct 2024 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875914;
	bh=eGM9e+i8BwsW/xldjvNOYHDr0f5Y0xhDhHnL5tXGipo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSnHBg7Ss1cLVYhfLvhrYn+kWRyR6W5SqqEaG6ikg3aFjN0TMZlv5UlcJtOCqoVmn
	 coElZzubAgBkpznbsZ/UIYIJwzEIm09vpSXG/z5JOgtf0A2JFHUUf9zEkHd/KTzkE4
	 YTUZvuA4nlMe9sPkz6OJvy22EnSPWA8vaDvHNur4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 265/695] selftests/bpf: Fix compile error from rlim_t in sk_storage_map.c
Date: Wed,  2 Oct 2024 14:54:23 +0200
Message-ID: <20241002125833.025932598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 18405c3b7cee9..af10c309359a7 100644
--- a/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
+++ b/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
@@ -412,7 +412,7 @@ static void test_sk_storage_map_stress_free(void)
 		rlim_new.rlim_max = rlim_new.rlim_cur + 128;
 		err = setrlimit(RLIMIT_NOFILE, &rlim_new);
 		CHECK(err, "setrlimit(RLIMIT_NOFILE)", "rlim_new:%lu errno:%d",
-		      rlim_new.rlim_cur, errno);
+		      (unsigned long) rlim_new.rlim_cur, errno);
 	}
 
 	err = do_sk_storage_map_stress_free();
-- 
2.43.0



