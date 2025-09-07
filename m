Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519761A2389;
	Sun,  7 Sep 2025 20:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276228; cv=none; b=EYrtEyWnUOtlgFProl1Q1YPbwv240eGO25ODk5H+W66zZYlf1PZlMV3Yrbse+N4Q7lWmeTYyClOblBlBJOJaCDS/sC2DWUElGTOlNcF6T2kmAL6FszSggfIxhz8ZuhV1SrP+jOX+IlSau3MGi9hn48XqHp2lJDHnSwnguwFPg2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276228; c=relaxed/simple;
	bh=iLAjGRdmSCmtcHCrwHweJnRCtgrIGUYN6o0mK5M4okk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5lyGiiDlgmfCoSKGg/pm7hBVPObk4AL9x6wwyq9mra4Zr4Kc2V8IkCVB9sLIAqvpTx2iHLUNlt9H4SJQ3WpTy7RMWjzkios5WmKnQB4VyoQZpS7wMsdS/utJDqjfwfwY9GwP5GPXaCtMYK2qUC64bBkDKFAFpHtPsJOz4AUOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZhf9iaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZhf9iaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFC6C4CEF0;
	Sun,  7 Sep 2025 20:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276228;
	bh=iLAjGRdmSCmtcHCrwHweJnRCtgrIGUYN6o0mK5M4okk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZhf9iaYWQsXRQxiosk/XhW6PQklWGwI/DO5g1XakJworDDWgNyCzBgehBynTj269
	 227GVVQ0BJp1du86AHEFAoQB9e2t+NZ2X1x0nIYCEl3JtMZwfH1jJRz6DqcKuwPc35
	 zIEL3JCvL5ycSIiXYC0DG1k6VBRVgLJjmqUYDwF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/104] selftest: net: Fix weird setsockopt() in bind_bhash.c.
Date: Sun,  7 Sep 2025 21:57:55 +0200
Message-ID: <20250907195608.685692894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit fd2004d82d8d8faa94879e3de3096c8511728637 ]

bind_bhash.c passes (SO_REUSEADDR | SO_REUSEPORT) to setsockopt().

In the asm-generic definition, the value happens to match with the
bare SO_REUSEPORT, (2 | 15) == 15, but not on some arch.

arch/alpha/include/uapi/asm/socket.h:18:#define SO_REUSEADDR	0x0004
arch/alpha/include/uapi/asm/socket.h:24:#define SO_REUSEPORT	0x0200
arch/mips/include/uapi/asm/socket.h:24:#define SO_REUSEADDR	0x0004	/* Allow reuse of local addresses.  */
arch/mips/include/uapi/asm/socket.h:33:#define SO_REUSEPORT 0x0200	/* Allow local address and port reuse.  */
arch/parisc/include/uapi/asm/socket.h:12:#define SO_REUSEADDR	0x0004
arch/parisc/include/uapi/asm/socket.h:18:#define SO_REUSEPORT	0x0200
arch/sparc/include/uapi/asm/socket.h:13:#define SO_REUSEADDR	0x0004
arch/sparc/include/uapi/asm/socket.h:20:#define SO_REUSEPORT	0x0200
include/uapi/asm-generic/socket.h:12:#define SO_REUSEADDR	2
include/uapi/asm-generic/socket.h:27:#define SO_REUSEPORT	15

Let's pass SO_REUSEPORT only.

Fixes: c35ecb95c448 ("selftests/net: Add test for timing a bind request to a port with a populated bhash entry")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250903222938.2601522-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/bind_bhash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/bind_bhash.c b/tools/testing/selftests/net/bind_bhash.c
index 57ff67a3751eb..da04b0b19b73c 100644
--- a/tools/testing/selftests/net/bind_bhash.c
+++ b/tools/testing/selftests/net/bind_bhash.c
@@ -75,7 +75,7 @@ static void *setup(void *arg)
 	int *array = (int *)arg;
 
 	for (i = 0; i < MAX_CONNECTIONS; i++) {
-		sock_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, setup_addr);
+		sock_fd = bind_socket(SO_REUSEPORT, setup_addr);
 		if (sock_fd < 0) {
 			ret = sock_fd;
 			pthread_exit(&ret);
@@ -103,7 +103,7 @@ int main(int argc, const char *argv[])
 
 	setup_addr = use_v6 ? setup_addr_v6 : setup_addr_v4;
 
-	listener_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, setup_addr);
+	listener_fd = bind_socket(SO_REUSEPORT, setup_addr);
 	if (listen(listener_fd, 100) < 0) {
 		perror("listen failed");
 		return -1;
-- 
2.50.1



