Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081A14D431;
	Tue, 10 Sep 2024 09:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961679; cv=none; b=W4FsUVz+o68EJqBto6/p1oJUtwBZwjJh+AZrgNXL54wmCAO2hnOsxWBNiXv3Bw453Rf5107WHsn14WGFf465EIE6edycDdoi+jWZ2mlryxRMqS9pUo4tzxcfEqL6QviooZ9Ud+fIpRsRRh8rtBafaHvbUPlghOW15vvzA4S1mBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961679; c=relaxed/simple;
	bh=awxfpA49x9lHnxEzT92iu1qaCjXyPCcZkUvjLcZ1xM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPLG4whwobNsM0zg0j6uBpoBiqj5OzaSfXd9/zSUgdJqLt5LLPxgkWbg0fGaObYhHiHysFeJMYQN3CMqKMdLpKvApMOIBUQaAqrk9ZyGGOSjV6I3ZtUBE8VcteQAnhWA8Dl/OW7AlgDIAwiUzWQY7sLMbdxg6I9Xn2e+SAzOrc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8tTTEty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8tTTEty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A56C4CEC3;
	Tue, 10 Sep 2024 09:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961679;
	bh=awxfpA49x9lHnxEzT92iu1qaCjXyPCcZkUvjLcZ1xM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8tTTEtyGm4jkjEzSYXY8xHXRnOElGD1i8hT4EMIB4XzQ/CvUOmjRmzkRikjym0io
	 bu2mxAfinCJHoh73t8pJwbTqs5V1M/c4qvwD/b4cgQtWdHL/8OrGGkXUoy46xOpCxm
	 FCaxCBFirDvJMKzcqffX7x0lxZ0VLVT46zvuzbmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 134/375] powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()
Date: Tue, 10 Sep 2024 11:28:51 +0200
Message-ID: <20240910092626.938549146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 0974d03eb479384466d828d65637814bee6b26d7 ]

Smatch warns:

  arch/powerpc/kernel/rtas.c:1932 __do_sys_rtas() warn: potential
  spectre issue 'args.args' [r] (local cap)

The 'nargs' and 'nret' locals come directly from a user-supplied
buffer and are used as indexes into a small stack-based array and as
inputs to copy_to_user() after they are subject to bounds checks.

Use array_index_nospec() after the bounds checks to clamp these values
for speculative execution.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reported-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240530-sys_rtas-nargs-nret-v1-1-129acddd4d89@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 8064d9c3de86..f7e86e09c49f 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -19,6 +19,7 @@
 #include <linux/lockdep.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/nospec.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/reboot.h>
@@ -1916,6 +1917,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args __user *, uargs)
 	    || nargs + nret > ARRAY_SIZE(args.args))
 		return -EINVAL;
 
+	nargs = array_index_nospec(nargs, ARRAY_SIZE(args.args));
+	nret = array_index_nospec(nret, ARRAY_SIZE(args.args) - nargs);
+
 	/* Copy in args. */
 	if (copy_from_user(args.args, uargs->args,
 			   nargs * sizeof(rtas_arg_t)) != 0)
-- 
2.43.0



