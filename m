Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756F1DD0C9;
	Tue, 15 Oct 2024 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998331; cv=none; b=Qb3DGb0sHxSLWPy5hXv+Yv+ajLZaEns6nHj4w7H+wCxQxtAPr/Ec+G6SFJP/fC07S4olYTZ8UGW7ISsWa3iFASYjkOw3iHxB2+ZClxORBa4rdlGbrdhYqnS1v0WWzkOrsBDsGts95Fh/tZ2iMJ39I4EYR0K5L/tSz5D3zaLjDiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998331; c=relaxed/simple;
	bh=wKiuE0sNAXS0eizeC+VV9jGsBvyFKDIHUgfJi6gFKtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUk9ZiMTlhzA+A4RZRwa0TmwxqHOjCW6eA6RbHsVcaEE3eG5mm3Np+1N9QFQq8EaqhA4ghEOOFPMW8sj85i1ob41e6/oMqziLDWSVxfoHy+VvxIUrQoxJvCN8ce5ldU4P8HX5IIlAP1Xq+AJ9FxPFpxQEgi+tgVXYUlOhsvyBUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z4iFSlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z4iFSlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93406C4CEC6;
	Tue, 15 Oct 2024 13:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998331;
	bh=wKiuE0sNAXS0eizeC+VV9jGsBvyFKDIHUgfJi6gFKtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1z4iFSlzrIyAU1pVDpE6mwOWbNIDZIwdHrSy7aEgie/T/A1za+y+rhtCT5IRGoHMm
	 a2Yq7APWttP650T+IQRuTmfIcz3ITJZzOgUkuyPkpl4QT78OR0HV2DeXmIVqvpGAes
	 rkl3re1Q+mem5rxjLGxwfinKelmlJPbzR6O1t5rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Laniel <flaniel@linux.microsoft.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Song Liu <song@kernel.org>,
	Markus Boehme <markubo@amazon.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/518] tracing/kprobes: Fix symbol counting logic by looking at modules as well
Date: Tue, 15 Oct 2024 14:45:51 +0200
Message-ID: <20241015123934.257419279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 926fe783c8a64b33997fec405cf1af3e61aed441 upstream.

Recent changes to count number of matching symbols when creating
a kprobe event failed to take into account kernel modules. As such, it
breaks kprobes on kernel module symbols, by assuming there is no match.

Fix this my calling module_kallsyms_on_each_symbol() in addition to
kallsyms_on_each_match_symbol() to perform a proper counting.

Link: https://lore.kernel.org/all/20231027233126.2073148-1-andrii@kernel.org/

Cc: Francis Laniel <flaniel@linux.microsoft.com>
Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Fixes: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Markus Boehme <markubo@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Sherry: It's a fix for previous backport, thus backport together]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 91dfe8cf1ce8b..ae059345ddf4c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -742,6 +742,8 @@ static unsigned int number_of_same_symbols(char *func_name)
 
 	kallsyms_on_each_symbol(count_symbols, &args);
 
+	module_kallsyms_on_each_symbol(count_symbols, &args);
+
 	return args.count;
 }
 
-- 
2.43.0



