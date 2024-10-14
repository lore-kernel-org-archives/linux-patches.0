Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E931ABECD;
	Mon, 14 Oct 2024 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917818; cv=none; b=JeMrhKG/swhUG6zuXQwwPXo7eeN69Rdic5rMb6J+UOgQtT+yO50vVOzBBTJe0V8vcULVi/DwUhFkEHjg527pwzqNJ/om6lv9OWmd3egGKqtRogbey3T//cIsRGwby5lnvgN02Hb577wTlSUcGFK6pn39Ld1Moz11HfWI3EvXTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917818; c=relaxed/simple;
	bh=3pv7NnsvIBE1g8uwKGLAMZ1X3eGn0oo7qdAJkAh7bB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJm8kWQT1CX0Br1SJ1Rm21qS5guQOxRsBwwbi+UI5UTk7o1MGd5fHJNIY/PmYtu8Xb4TWvWoU3fBEE/6row6hlf+NXXiOxZeUtOV6e0PsbiutNCdPeXX4XNyI9u+dfUkKpWLjUPq5D6eKCGiDLepayd05OyCfInA9DoLDz180ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCgz/Wc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCgz/Wc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F12C4CEC3;
	Mon, 14 Oct 2024 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917817;
	bh=3pv7NnsvIBE1g8uwKGLAMZ1X3eGn0oo7qdAJkAh7bB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCgz/Wc6UYqxP8BUHYyLMNO7105inb+3eyqtYVJTExJiNUQR0uw3kJN6O7XlXtBx1
	 KjarQOqUeoR8XE4sRYQ94Bc7nogtEm2qnFPRTgIY4iAvmNtFaBAHfEETOzLs0WYK/B
	 L4nBTHqnuJ22gzczXO3CPDEIG7n6pG9a4db+GNuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/798] selftests/bpf: Fix error compiling bpf_iter_setsockopt.c with musl libc
Date: Mon, 14 Oct 2024 16:11:37 +0200
Message-ID: <20241014141223.536492568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 7b10f0c227ce3fa055d601f058dc411092a62a78 ]

Existing code calls getsockname() with a 'struct sockaddr_in6 *' argument
where a 'struct sockaddr *' argument is declared, yielding compile errors
when building for mips64el/musl-libc:

  bpf_iter_setsockopt.c: In function 'get_local_port':
  bpf_iter_setsockopt.c:98:30: error: passing argument 2 of 'getsockname' from incompatible pointer type [-Werror=incompatible-pointer-types]
     98 |         if (!getsockname(fd, &addr, &addrlen))
        |                              ^~~~~
        |                              |
        |                              struct sockaddr_in6 *
  In file included from .../netinet/in.h:10,
                   from .../arpa/inet.h:9,
                   from ./test_progs.h:17,
                   from bpf_iter_setsockopt.c:5:
  .../sys/socket.h:391:23: note: expected 'struct sockaddr * restrict' but argument is of type 'struct sockaddr_in6 *'
    391 | int getsockname (int, struct sockaddr *__restrict, socklen_t *__restrict);
        |                       ^
  cc1: all warnings being treated as errors

This compiled under glibc only because the argument is declared to be a
"funky" transparent union which includes both types above. Explicitly cast
the argument to allow compiling for both musl and glibc.

Fixes: eed92afdd14c ("bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Geliang Tang <geliang@kernel.org>
Link: https://lore.kernel.org/bpf/f41def0f17b27a23b1709080e4e3f37f4cc11ca9.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
index b52ff8ce34db8..16bed9dd8e6a3 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
@@ -95,7 +95,7 @@ static unsigned short get_local_port(int fd)
 	struct sockaddr_in6 addr;
 	socklen_t addrlen = sizeof(addr);
 
-	if (!getsockname(fd, &addr, &addrlen))
+	if (!getsockname(fd, (struct sockaddr *)&addr, &addrlen))
 		return ntohs(addr.sin6_port);
 
 	return 0;
-- 
2.43.0



