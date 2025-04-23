Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22EF2BEC57;
	Wed, 23 Apr 2025 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422504; cv=none; b=hmO+SIE5QQ72Bk6nY2a+0zSmKYfc3BmTD4mb600+HAzT9QjOAT/X+FyyDr1ecitqY7gPwDyRsB02KxH+IaDVmAJgVXlArWYT4W5UbZnzcXk45ehEQp4AWNi1pqOR9qcux3UcUU6pqA8koRzVsWmH+S6SuzmTD9LyYQBTP4emnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422504; c=relaxed/simple;
	bh=1PNNUbFx2wXciHDJ5F4LNqqn7iNP9l8GbN8FbQ9KJpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8ZwzCcpWC8GzoMJHq+U7ncHTewpRJmPR2jqq+AGq9jeH2t3mtD3o6xl1QcwzJWoMtY3mdfl6qB75YU6LKJ1Gk+NIphvhzNfqqeBS57A9xTfxyIJtLxrOXm/K4L0A05lcc/npVdVnJWc4Pag03FLW/D1jhtoW+U7MP4oqOgiBCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As01AszD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As01AszD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8223BC4CEE3;
	Wed, 23 Apr 2025 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422503;
	bh=1PNNUbFx2wXciHDJ5F4LNqqn7iNP9l8GbN8FbQ9KJpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As01AszDmxaTUap1aKF3hbzbfwl2WLmzYjbJcwQyU+kmrL+iAvrxfDd5/P8tg1Ef3
	 E9lz7mBPAfWDuzVu7/vE97+QocFrQTxMcVH7ktV8oZfUJGOewOkN93MH1SY3JwjMY9
	 4XiAZUvDAUgrCvnnb+Dc1ako/3JfU6iBeqNMoUUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 6.6 375/393] powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()
Date: Wed, 23 Apr 2025 16:44:31 +0200
Message-ID: <20250423142658.821992892@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/lockdep.h>
 #include <linux/memblock.h>
+#include <linux/nospec.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/reboot.h>
@@ -1839,6 +1840,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args _
 	    || nargs + nret > ARRAY_SIZE(args.args))
 		return -EINVAL;
 
+	nargs = array_index_nospec(nargs, ARRAY_SIZE(args.args));
+	nret = array_index_nospec(nret, ARRAY_SIZE(args.args) - nargs);
+
 	/* Copy in args. */
 	if (copy_from_user(args.args, uargs->args,
 			   nargs * sizeof(rtas_arg_t)) != 0)


