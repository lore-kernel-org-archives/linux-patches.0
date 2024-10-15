Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265161E490B;
	Tue, 15 Oct 2024 11:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992692; cv=none; b=NVHQuEHL6C1iXMzcT8yt9zIteMrjE/NkFJ8AuqeZrb1Ab0T8t6XqU7v3WZrYtDTtLAPWowJp9gyAbj/1bfbn+Ksxl6wQuhtQhTyNNyHGilbjXLMmjYG8pyo2GCd+BOyAvbtm5ECuXUODrIs8ZC+Kvc8Udx6QwmLnnK3hPXolts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992692; c=relaxed/simple;
	bh=h4ODjuiSUfaZeb62A2KcNpfWugqPzo+YBwkX5JWqGhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFdvVOW0njOEsQSklTY23uGP4zfvEnTJJYOyLTi1R+Oxdogo9akmADtn12pFYS8f8w6yHaEAoohecW2yl0MLH8BeRtQZRfFiZ0dQ4/UM5erFkGxcgBNIBQkjffP1+9iyp/VS5rwhVfcjGFkVoqDqCXrNz16nxcroFRKIl7tBGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTbhuZ8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTbhuZ8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B306C4CED0;
	Tue, 15 Oct 2024 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992692;
	bh=h4ODjuiSUfaZeb62A2KcNpfWugqPzo+YBwkX5JWqGhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTbhuZ8zfy1EEZG7MHspFWYmBAon/KIfBZ2Q2X9WryBKS0ObLK+CFrj1XwTbGQikH
	 uoUSYXLafPJQuWIs2VsIy9pNy9JuIZitza6azV0cRF7xPjidrSd/3upUSmm2JXGvBA
	 KYXRbYpgKsDU6qHwQm0f2zzhRze2ydPiAnnv+hUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/691] selftests/bpf: Fix compile error from rlim_t in sk_storage_map.c
Date: Tue, 15 Oct 2024 13:22:19 +0200
Message-ID: <20241015112447.938777215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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



