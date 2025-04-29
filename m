Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0EB25178C;
	Tue, 29 Apr 2025 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947051; cv=none; b=pc3R1vANBY0NMPHL+XQJ5ZSEhvE3DAlgVD4C3Qqb3ftgVvhvgZqg/Zj8G5sa6zxOR5wUDz/5U2/fi3Xmuwk2O4RcLw/V9K7Nm1Xmp30ZDuiEUvRsw2u7JeZ4fMNg4cZw0i3MptufJoTB2Vn0yhbboCOoHJode+/np4iKomkK6pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947051; c=relaxed/simple;
	bh=lY0m13+f1HoCvVXg13XLEm42isQ1BDo1lAprtzdWQGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCHHNvxPk/Lsa19Th40eBYH1ubbfizOWqINCzmlioZEtBNwZhrL6OVDADPwS6NiNf6iDkQe4VsJ1Lux87VuzXcEiso73vIGlOFg5YtJy5qn+qxcMGoZ7IxdsZPtYCuGSj8LZ90A0Pxzw1KOQmINnt4HZzig10T43A1svlerLDdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0yzfQGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0yzfQGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6210C4CEE3;
	Tue, 29 Apr 2025 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947051;
	bh=lY0m13+f1HoCvVXg13XLEm42isQ1BDo1lAprtzdWQGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0yzfQGqeKz3DQrGrtjOXwNT/ZmwpshvpQSDIVsUp0wIr2qTwXz/teV6J3b31BBt3
	 56EEW7iVtuwNo+OGUsWfV8ghjJZBL5zAPPN2+wS96ZjAbTMoYAfvZo+8c0nFSckwGs
	 6LdkZckcf6mrKZt2Uk6AZ6bTag1Y2XnE5hhXeHBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 155/286] powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()
Date: Tue, 29 Apr 2025 18:40:59 +0200
Message-ID: <20250429161114.260362565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,6 +1174,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args _
 	    || nargs + nret > ARRAY_SIZE(args.args))
 		return -EINVAL;
 
+	nargs = array_index_nospec(nargs, ARRAY_SIZE(args.args));
+	nret = array_index_nospec(nret, ARRAY_SIZE(args.args) - nargs);
+
 	/* Copy in args. */
 	if (copy_from_user(args.args, uargs->args,
 			   nargs * sizeof(rtas_arg_t)) != 0)


