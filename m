Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1084E1C7274;
	Tue, 15 Oct 2024 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992696; cv=none; b=Z0WOFCr2YZ8SQIignk+SFwYX21MTJpw2c9ai041MquRkjG1sn3qHPyc3bDBlYWurMOW7kzWgfTPEGWhfbAD5mqB0PDrkm3y37BLSCkPMmZ/MhNKQZ0ciDWiivwaT4fQjxksKC12QtezSln5xlSyeGHZ0yoq4WIB3pD87/1k+8tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992696; c=relaxed/simple;
	bh=BWcEMQHt1+jxWa8hhFFMqgK5Zc1/l3511KKUEItkHcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkpuWevsoJr4kBSZRNbu/2ThqCBRYlfsGNo+LMl+YiPJ+lpo3ceBCJphE0VfLwUx7Oud6OnwoAlFfMtFFE6Te29fBAxnQCRLid1Kh3B+ywA0mI0zMGouXmyvXa+DpC0/G4ZEZhj7eHZ+S33k7l7dmn9PZAoHdY7yUmhLJXsc0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mot8pM4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mot8pM4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDE1C4CEC6;
	Tue, 15 Oct 2024 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992695;
	bh=BWcEMQHt1+jxWa8hhFFMqgK5Zc1/l3511KKUEItkHcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mot8pM4k71yvJ6Ur5JPjh0Yo9dE7+vCN1FwWzA24XNr+Mh/2zclY9HXEFnHVOdcMs
	 htrB4gQ87kPWp7HW5j3ym7Kw+yeUTRjFM+oso1bNPd1Aa7tyaeiyIMt3KOEDY8ezXd
	 0xq5fUSnorS5A00AAOMgS/I5H/zoWwx3vo+s6oUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/691] selftests/bpf: Fix error compiling bpf_iter_setsockopt.c with musl libc
Date: Tue, 15 Oct 2024 13:22:20 +0200
Message-ID: <20241015112447.979404142@linuxfoundation.org>
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
index 85babb0487b31..59a9b6e02452a 100644
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



