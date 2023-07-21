Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A49527F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3BC433C8;
	Fri, 21 Jul 2023 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965400;
	bh=WsmBUdyI0dqLhBR8ZpFMzmgIPm5B4DFwPzqsK/2CcT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljIRnq9SEoT0tiBdTF7XPxqhalR5C237cwV2yUnBosyF+Sc5HKEbKShr71BQgMcCC
	 DkH54yA2UW4VlgmjVnVSX1hsqEhZUS7qG3ktE/wTDYAQBFqrv8s2WJnDc7130CMFKk
	 x7pu4B3iMY+bvWtknyeF/y8H0SbRfacyg60g0GBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.4 270/292] tracing/probes: Fix not to count error code to total length
Date: Fri, 21 Jul 2023 18:06:19 +0200
Message-ID: <20230721160540.540584032@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit b41326b5e0f82e93592c4366359917b5d67b529f upstream.

Fix not to count the error code (which is minus value) to the total
used length of array, because it can mess up the return code of
process_fetch_insn_bottom(). Also clear the 'ret' value because it
will be used for calculating next data_loc entry.

Link: https://lore.kernel.org/all/168908493827.123124.2175257289106364229.stgit@devnote2/

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/8819b154-2ba1-43c3-98a2-cbde20892023@moroto.mountain/
Fixes: 9b960a38835f ("tracing: probeevent: Unify fetch_insn processing common part")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe_tmpl.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -204,6 +204,8 @@ stage3:
 array:
 	/* the last stage: Loop on array */
 	if (code->op == FETCH_OP_LP_ARRAY) {
+		if (ret < 0)
+			ret = 0;
 		total += ret;
 		if (++i < code->param) {
 			code = s3;


