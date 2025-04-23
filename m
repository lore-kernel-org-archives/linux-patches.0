Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE006242D64;
	Wed, 23 Apr 2025 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422268; cv=none; b=cVg8qvblTn7Q2YtYZWLWn59JOhfJpl7RmEIPx6jlvlUcAxNPgeprlwPz+X/9nXnxUeL6EFmT/0pRgQIOYppV0s+lYrlSLvS7Gfbfug05ECaFcE/Zrh1R0d9g40FYpnls7Sl7pJUzdXxqXGCsBfBiXP3iKpRnBvz98btE9+pr4RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422268; c=relaxed/simple;
	bh=CUhL5/O+f79TXrduLbU25qiOQxYtnKun1jL9FBBpjv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaRAc/vE3CYdTNFdnAcoTnPavRu+EljfurS+psfORKs2oN3PyQPgfxPmBYx+GH3cNwM0WL+2cTPcezGBXX1atvBIT9335P4dTPGFd0x5HQaN01B4iyLobCAFnbSjC2CMQh+li5cArtOfDh5lXhqeF7WycgL4GkXLrbEVSsZ47CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uY2PAl9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uY2PAl9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE35C4CEE2;
	Wed, 23 Apr 2025 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422267;
	bh=CUhL5/O+f79TXrduLbU25qiOQxYtnKun1jL9FBBpjv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uY2PAl9hYUva1VoAtXhQOxAfEiochn0NCc7DEC5qUknj45H7I0ypDXaj+kTCkNmg2
	 G4wT6f3kpHwhFfC+Abbuf4kuJu8zizCX2v26h0MnLPKQlxmZwX4+8aaUAjFdkYkG3G
	 y7IFLmGFUJTTbf1r4Db+G6s7EXYx9Yr17oYTYc8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 6.1 267/291] powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()
Date: Wed, 23 Apr 2025 16:44:16 +0200
Message-ID: <20250423142635.333823482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Nathan Lynch <nathanl@linux.ibm.com>

commit 0974d03eb479384466d828d65637814bee6b26d7 upstream.

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
[Minor context change fixed]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/rtas.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/nospec.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 
@@ -1178,6 +1179,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args _
 	    || nargs + nret > ARRAY_SIZE(args.args))
 		return -EINVAL;
 
+	nargs = array_index_nospec(nargs, ARRAY_SIZE(args.args));
+	nret = array_index_nospec(nret, ARRAY_SIZE(args.args) - nargs);
+
 	/* Copy in args. */
 	if (copy_from_user(args.args, uargs->args,
 			   nargs * sizeof(rtas_arg_t)) != 0)


