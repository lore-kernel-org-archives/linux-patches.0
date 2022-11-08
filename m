Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659EA15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC87BC433C1;
	Tue,  8 Nov 2022 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916807;
	bh=VdGxVl4ejXtDm/eo6ir27HlNmZLLx5idMGGymto1Y4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0mJ47B5ncx3J6DiYe0aLtk2YH1Gz8F+TKMKqmFjDmqlvvwL/t8BokwSY2OX+a8BF
	 pkZGotoiIp665ybDTDIpcz9CbZK7h6+vjxLvabHFJiltuvA7zfeci6ZMXRRP1qb6N+
	 +0wPVoV6FDHfWBYNSHKzozEiuqO83HCCmdFQones=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 139/197] tracing/fprobe: Fix to check whether fprobe is registered correctly
Date: Tue,  8 Nov 2022 14:39:37 +0100
Message-Id: <20221108133401.256986876@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 61b304b73ab4b48b1cd7796efe42a570e2a0e0fc upstream.

Since commit ab51e15d535e ("fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag
for fprobe") introduced fprobe_kprobe_handler() for fprobe::ops::func,
unregister_fprobe() fails to unregister the registered if user specifies
FPROBE_FL_KPROBE_SHARED flag.
Moreover, __register_ftrace_function() is possible to change the
ftrace_ops::func, thus we have to check fprobe::ops::saved_func instead.

To check it correctly, it should confirm the fprobe::ops::saved_func is
either fprobe_handler() or fprobe_kprobe_handler().

Link: https://lore.kernel.org/all/166677683946.1459107.15997653945538644683.stgit@devnote3/

Fixes: cad9931f64dc ("fprobe: Add ftrace based probe APIs")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -301,7 +301,8 @@ int unregister_fprobe(struct fprobe *fp)
 {
 	int ret;
 
-	if (!fp || fp->ops.func != fprobe_handler)
+	if (!fp || (fp->ops.saved_func != fprobe_handler &&
+		    fp->ops.saved_func != fprobe_kprobe_handler))
 		return -EINVAL;
 
 	/*


