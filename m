Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9667119F411;
	Wed,  2 Oct 2024 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878009; cv=none; b=RhXGkf95QR1/UKgOgqsPZXpKL9X4NbSDsTyKu/VoSZCcwSa+kTo6tym09YyI5xWpJNcqerNTbNboit8S2lusQBQM5BCRn7Krit8LwVssfd/ptSGPjcacMW3HRwob4DkZTH0C8fwVBP72F3V0Z5if2zfeWR446RAnTnBbkwgwa1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878009; c=relaxed/simple;
	bh=QWvRTreEEWbwk8ZwukEmUWVe/AZO1+nFeg3KJy95iKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZv7sduA/Xd6Ayr2E+itLSUm7Vi83DD7cH12iYaFDjt/+ivOCjtU8wz+mJ+ZGVDa+ag7l1BQIukZRqsJ8B38aPPgh8SeubeljGMfAroKVyangy7iYNowXedPpbpElCDQGSpN1EuJRPOKiF6fHaNMHunCfRRnyr0czn59g1VzzwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TK+OsgUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TK+OsgUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C6DC4CEC5;
	Wed,  2 Oct 2024 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878009;
	bh=QWvRTreEEWbwk8ZwukEmUWVe/AZO1+nFeg3KJy95iKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TK+OsgUQ2sPUru33gmyO8v8gFBgWgaCVs9zK/VB72BYF9RuqA3dAZwP64OBRyqRm5
	 4M6+Y4ypkhgue6UbkngPfH9GfQnIoX8TiGcpwXKOwY+V2gIla/shxqEvlF6YZdtDdk
	 0GHU2sMltOyW5c3M/Nv1rMbuYxaMu+EMpuHjCty4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 239/634] selftests/bpf: Fix error compiling bpf_iter_setsockopt.c with musl libc
Date: Wed,  2 Oct 2024 14:55:39 +0200
Message-ID: <20241002125820.534053158@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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



