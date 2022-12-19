Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115806FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7129DC433F0;
	Mon, 19 Dec 2022 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477964;
	bh=2ktixRPzbKnwNXYxtSVgA80LeEe/dN1cRmpSm14PV1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS899v1wWEekyQ8ffWonHMOeTCiWRQBHfzO+pxXDqdOFJLhAqSAXdR0f0ZKjk/DX/
	 WOYF4vFaMob8cqJ4QVbYGjSaYpoabAx0vtLA+p0P2jcfkg01nM8zD9H7CRae4MzsHf
	 fNznic53BaZv1QXd+/4Wx7bcfNlGKfORzhXxp2L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martynas Pumputis <m@lambda.lt>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 03/28] ftrace: Add support to resolve module symbols in ftrace_lookup_symbols
Date: Mon, 19 Dec 2022 20:22:50 +0100
Message-Id: <20221219182944.342333467@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

commit 3640bf8584f4ab0f5eed6285f09213954acd8b62 upstream.

Currently ftrace_lookup_symbols iterates only over core symbols,
adding module_kallsyms_on_each_symbol call to check on modules
symbols as well.

Also removing 'args.found == args.cnt' condition, because it's
already checked in kallsyms_callback function.

Also removing 'err < 0' check, because both *kallsyms_on_each_symbol
functions do not return error.

Reported-by: Martynas Pumputis <m@lambda.lt>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8261,6 +8261,10 @@ struct kallsyms_data {
 	size_t found;
 };
 
+/* This function gets called for all kernel and module symbols
+ * and returns 1 in case we resolved all the requested symbols,
+ * 0 otherwise.
+ */
 static int kallsyms_callback(void *data, const char *name,
 			     struct module *mod, unsigned long addr)
 {
@@ -8304,17 +8308,19 @@ static int kallsyms_callback(void *data,
 int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
 {
 	struct kallsyms_data args;
-	int err;
+	int found_all;
 
 	memset(addrs, 0, sizeof(*addrs) * cnt);
 	args.addrs = addrs;
 	args.syms = sorted_syms;
 	args.cnt = cnt;
 	args.found = 0;
-	err = kallsyms_on_each_symbol(kallsyms_callback, &args);
-	if (err < 0)
-		return err;
-	return args.found == args.cnt ? 0 : -ESRCH;
+
+	found_all = kallsyms_on_each_symbol(kallsyms_callback, &args);
+	if (found_all)
+		return 0;
+	found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
+	return found_all ? 0 : -ESRCH;
 }
 
 #ifdef CONFIG_SYSCTL


