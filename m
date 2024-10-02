Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFF91D043E;
	Wed,  2 Oct 2024 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879650; cv=none; b=ELPQgTaW/OpUbaAHpBJsOtPqw4Dk2SIZTihoBzI5vc7pqPS/5/aMFoMU6pi6fm7+syqKIfn9xFY7AQaEFyLH5Y1ysBtAYBNAy0w7rzpMytz4YceTmw9/nvIeYRR/T7e/nFX5FIQP3rEG+BBuvZ7tBjioMA+Q+EaN1WPBKhBKZOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879650; c=relaxed/simple;
	bh=0TkkwQIhYYtmbE+xauRW/MrAD2lKx6BLZoMm98RNWjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAmaogUBfTnVFuJhI1di/hHjWA1JOn27+n4rZwCmR6/pJ20r8eDz/Nn8xmMebQMgA4c6xR5BMOj4+63hMmIf8Q2NE32oe73lzpux6VD/46XHt1beCLTsRcWkQQ8qOrvQq33lFZKkLTt+4xzQOSH5g9tt1veLlQKuYVKF6I43SWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlFDMsUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlFDMsUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1E7C4CEC5;
	Wed,  2 Oct 2024 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879649;
	bh=0TkkwQIhYYtmbE+xauRW/MrAD2lKx6BLZoMm98RNWjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlFDMsUVnnR3qQWmQzKXYKxwU9IUFWoTcX5KBYKP4YJPfmmOkrCBme4g3LuUjq90a
	 XkmoSfHjJfC3R+Le8hAFbGYa5SZNhhNq22lEM2Q4Vd+yjQjP92FKgEMxvH9sUwdpII
	 nj0MixlJN7fD10L4Gpeu8vdmOqcHdyhFlFzPx3/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/538] selftests/bpf: Fix error compiling bpf_iter_setsockopt.c with musl libc
Date: Wed,  2 Oct 2024 14:57:09 +0200
Message-ID: <20241002125759.757350756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



