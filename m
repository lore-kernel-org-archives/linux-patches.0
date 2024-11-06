Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28551E0B84;
	Wed,  6 Nov 2024 13:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898787; cv=none; b=AaQnOZ7fzr8dTVVV4XElbL3Js95jr9txJBjCZH+76sxqwnFY5dRR2q6hbM+RZFaAVyfS790aH8DNtFY1WJVoLreehxwvYQ461+3OUEY5Tr1Z66orsC9RBmxDYt5l5giuQoPGQYYVqokgZx733C+ONRA5erVEdlEfYj/wPfrmPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898787; c=relaxed/simple;
	bh=pLzrJ+qOedT79+ZYrVfI7nMxiNxe7/JGos9i6Dz9Urw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2dvGNzdObWU7LGsEU573X3Y9csEyg/AWfUBYKJOnaCuu3Dj7vF5orw8J2vr9wcHvW94ll3LBY3SBTZJuaFV6OTRrVIPE4FF8O7UFSs/G/FbnvakYhu5q60B8mlZuyQjhptnd58aaPkJberPFBErcf+D80kdN0pzK4q8v9Cfbrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd4fjX38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd4fjX38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32893C4CECD;
	Wed,  6 Nov 2024 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898787;
	bh=pLzrJ+qOedT79+ZYrVfI7nMxiNxe7/JGos9i6Dz9Urw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd4fjX38CFaFwAfCPX3mgttRWRiXSK5nvUPfWCDvGnTWICqS5blUe840H8P2IqaLf
	 r4nVVwfJJN6yHhufxc5DLhvcIWX4YLVjmD9StgSH3KI+dpC1cKz8yUMaxP6FBZrl59
	 kqEy25SjfgqKls48okP21/LtkCtPM7EelZzwUckI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Laniel <flaniel@linux.microsoft.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Song Liu <song@kernel.org>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.4 356/462] tracing/kprobes: Fix symbol counting logic by looking at modules as well
Date: Wed,  6 Nov 2024 13:04:09 +0100
Message-ID: <20241106120340.324141277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ Sherry: It's a fix for previous backport, thus backport together to 5.4.y ]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -741,6 +741,8 @@ static unsigned int number_of_same_symbo
 
 	kallsyms_on_each_symbol(count_symbols, &args);
 
+	module_kallsyms_on_each_symbol(count_symbols, &args);
+
 	return args.count;
 }
 


