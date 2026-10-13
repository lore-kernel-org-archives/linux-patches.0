Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E0D4F30DC;
	Tue, 13 Oct 2026 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892119; cv=none; b=PUUrYzu8EY8+6wOJYQxYlOBH8sXUYMR1dKyJLhWhOoH48KSGuOG5T4rtkoZXqTElK3R/bWwhox22/xqfgXVytFKrfZF7YSkAS2EbLLpWLKxsHFKJjHUfk39XgrZmJlfiegL6DGYkA87aSBt895hRW2O0i9MaiGJU+WOWlZRweck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892119; c=relaxed/simple;
	bh=T/Ma0lhRXSJ3h/0uB1MpVi5OrZ49Zpa+NIWds1WAEdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWRvNiLKvTbzAp10Ye5H71cNo9ciK1EB0iR1Sx/kokQFoR2Cuedb/UHxoxzfDzNgmW3WwJEHQkgSZs/9F9qN4CTpioDCrT87jM11+CRtj0U/RvCUadYwcqAIuXE9CClBe7dYMLTWZ6WhfP30VrKnFsm6KyWO6mt/eEQ3Tpxa2aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgLIqvFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgLIqvFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB941F000FF;
	Tue, 13 Oct 2026 11:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892117;
	bh=OjDOC8nJZVb18yO0s0WVKZIP/twtCDmAm8uzfvh+0PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgLIqvFnbugIukwIVMi7deRD7A9dAezVHKFbPgfCytl0aybmTbyBezwtxsqgyaXjV
	 FM8kHNwLEcx5Paq3EKV2XWafUMCyt9oMw3na4YhLr+w0S8WRkPJWfyLct4sl/qZYMl
	 wjKIT9/2OrUAb/n/K/gDbF7whOKuVhQEy8A5uqKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natasha Klaus <natalie.klaus@runtimeverification.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 065/281] io_uring/net: populate CONNECT filter fields for 24-byte sockaddr_in6
Date: Tue, 13 Oct 2026 13:36:21 +0200
Message-ID: <20261013112856.707432985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Natasha Klaus <natalie.klaus@runtimeverification.com>

commit aa5d5f8e502318e783545ba5d04bb40130b83e20 upstream.

io_connect_bpf_populate() fills connect.port and connect.v6_addr for
AF_INET6 only when addr_len >= sizeof(struct sockaddr_in6), i.e. 28
bytes.

The IPv6 connect paths accept SIN6_LEN_RFC2133 (24 bytes), which
already holds sin6_port and sin6_addr. io_connect() passes addr_len to
the socket layer unchanged.

At addr_len 24 the filter sees family AF_INET6 with port and address
zero, while the kernel connects to the real destination. A filter that
denies an IPv6 port or address is bypassed. Denying connect.port == P
rejects [::1]:P with -EACCES at addr_len 28 but connects at addr_len 24.

Use SIN6_LEN_RFC2133 as the threshold. sin6_scope_id stays zero when
absent.

The threshold mismatch was found by an AI coding assistant (Claude Code)
comparing this hook against the net/ipv6 length checks on my
instructions; it also drafted the reproducer and this patch. I verified
the bypass and the fix in a VM on 7.3-rc6 and that 7.2 has the same
code.

Fixes: 899bea8248ce ("io_uring/net: allow filtering on IORING_OP_CONNECT")
Cc: stable@vger.kernel.org # 7.2
Signed-off-by: Natasha Klaus <natalie.klaus@runtimeverification.com>
Link: https://patch.msgid.link/20261009133807.730724-1-natalie.klaus@runtimeverification.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -7,6 +7,7 @@
 #include <linux/un.h>
 #include <linux/compat.h>
 #include <net/compat.h>
+#include <net/ipv6.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -1772,7 +1773,8 @@ void io_connect_bpf_populate(struct io_u
 	case AF_INET6: {
 		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)ss;
 
-		if (conn->addr_len < (int)sizeof(*sin6))
+		/* The IPv6 stack accepts SIN6_LEN_RFC2133; port and addr are in it. */
+		if (conn->addr_len < SIN6_LEN_RFC2133)
 			break;
 		bctx->connect.port = sin6->sin6_port;
 		memcpy(bctx->connect.v6_addr, &sin6->sin6_addr,


