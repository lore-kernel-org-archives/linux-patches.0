Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BAF8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74860C433D2;
	Fri, 10 Mar 2023 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457538;
	bh=08JKqLomuqR8Z+WnXh9Rr9/MR0OoAsnToT9vuZiLzkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+ofMxx6jAaa1L0ZwKPpQjrlwzr9fbjeXSG6ZGZzmSliHrZlLctZLi2oEYENzfSpI
	 XOH7b24C8rjTAANHbEOupJloqbAcINMY1PSUIJnP80ab+3EeyZCigNSj9hDmdJlenN
	 pze5ODHBCigEDEkVKqGuwFZmsBHei+pisiX5PVkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 172/200] RDMA/cma: Distinguish between sockaddr_in and sockaddr_in6 by size
Date: Fri, 10 Mar 2023 14:39:39 +0100
Message-Id: <20230310133722.384562012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 876e480da2f74715fc70e37723e77ca16a631e35 ]

Clang can do some aggressive inlining, which provides it with greater
visibility into the sizes of various objects that are passed into
helpers. Specifically, compare_netdev_and_ip() can see through the type
given to the "sa" argument, which means it can generate code for "struct
sockaddr_in" that would have been passed to ipv6_addr_cmp() (that expects
to operate on the larger "struct sockaddr_in6"), which would result in a
compile-time buffer overflow condition detected by memcmp(). Logically,
this state isn't reachable due to the sa_family assignment two callers
above and the check in compare_netdev_and_ip(). Instead, provide a
compile-time check on sizes so the size-mismatched code will be elided
when inlining. Avoids the following warning from Clang:

../include/linux/fortify-string.h:652:4: error: call to '__read_overflow' declared with 'error' attribute: detected read beyond size of object (1st parameter)
                        __read_overflow();
                        ^
note: In function 'cma_netevent_callback'
note:   which inlined function 'node_from_ndev_ip'
1 error generated.

When the underlying object size is not known (e.g. with GCC and older
Clang), the result of __builtin_object_size() is SIZE_MAX, which will also
compile away, leaving the code as it was originally.

Link: https://lore.kernel.org/r/20230208232549.never.139-kees@kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1687
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 26d1772179b8f..8730674ceb2e1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -479,13 +479,20 @@ static int compare_netdev_and_ip(int ifindex_a, struct sockaddr *sa,
 	if (sa->sa_family != sb->sa_family)
 		return sa->sa_family - sb->sa_family;
 
-	if (sa->sa_family == AF_INET)
-		return memcmp((char *)&((struct sockaddr_in *)sa)->sin_addr,
-			      (char *)&((struct sockaddr_in *)sb)->sin_addr,
+	if (sa->sa_family == AF_INET &&
+	    __builtin_object_size(sa, 0) >= sizeof(struct sockaddr_in)) {
+		return memcmp(&((struct sockaddr_in *)sa)->sin_addr,
+			      &((struct sockaddr_in *)sb)->sin_addr,
 			      sizeof(((struct sockaddr_in *)sa)->sin_addr));
+	}
+
+	if (sa->sa_family == AF_INET6 &&
+	    __builtin_object_size(sa, 0) >= sizeof(struct sockaddr_in6)) {
+		return ipv6_addr_cmp(&((struct sockaddr_in6 *)sa)->sin6_addr,
+				     &((struct sockaddr_in6 *)sb)->sin6_addr);
+	}
 
-	return ipv6_addr_cmp(&((struct sockaddr_in6 *)sa)->sin6_addr,
-			     &((struct sockaddr_in6 *)sb)->sin6_addr);
+	return -1;
 }
 
 static int cma_add_id_to_tree(struct rdma_id_private *node_id_priv)
-- 
2.39.2



