Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B122472B9;
	Tue, 29 Apr 2025 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949089; cv=none; b=d+avFzaJVd0d7TDWs4080Rj8gALtN90XR22sOJCy1bFKYSRLoKGIqiW37um9XhKcvj9/as6j3s4iCetHlBK0mIJNP3vACpVE7v7BER3o+9mzw7C/wap3VG8eVXZQJ27nVgxs1cMgoH3V/1SkUGcCLUPGv2oXDh4UR5mZ1WVXrmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949089; c=relaxed/simple;
	bh=wogJ+Ds91KAvssFspM3aMszO4fUbX+i/Hmcpomg2BMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuE+jIm6XG3bStJzfPiTNvL2V8hCExI8iybC/GLfu1Z4hTk7ByaTE+UcYTHjWhNPO5ghvwwPU9Vzn8CU5JP2K/iU1/CKrT15raSSdjYMAcGWYmX8ivzEfvtqLmEHSMmBAuczZK8Z85OihOuxlbjbuGNS2uog7AR1OwIH1FqExoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APnsfyDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APnsfyDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53EDC4CEE3;
	Tue, 29 Apr 2025 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949089;
	bh=wogJ+Ds91KAvssFspM3aMszO4fUbX+i/Hmcpomg2BMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APnsfyDgPt5Yt3L8ceTOA61+k2PkCiufJ3nSOfyCWHMKvQgMENtwQCYObrYy05i97
	 Xnhx+fczzR5iY70bIb9Cq4UEBcG0M3wm76q3Mq8DJ8S+KJ/bQOyv0KM+Ff3aIMfY+e
	 JSs3ZNF+vrygwqjZuqZ9W43yGkf1PH8u8pwwEqJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.15 210/373] powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()
Date: Tue, 29 Apr 2025 18:41:27 +0200
Message-ID: <20250429161131.801562074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16,6 +16,7 @@
 #include <linux/capability.h>
 #include <linux/delay.h>
 #include <linux/cpu.h>
+#include <linux/nospec.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/completion.h>
@@ -1076,6 +1077,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args _
 	    || nargs + nret > ARRAY_SIZE(args.args))
 		return -EINVAL;
 
+	nargs = array_index_nospec(nargs, ARRAY_SIZE(args.args));
+	nret = array_index_nospec(nret, ARRAY_SIZE(args.args) - nargs);
+
 	/* Copy in args. */
 	if (copy_from_user(args.args, uargs->args,
 			   nargs * sizeof(rtas_arg_t)) != 0)


