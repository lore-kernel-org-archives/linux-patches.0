Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2372DF3CF;
	Tue, 22 Jul 2025 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192678; cv=none; b=OmOnp4sRqdfiUWO+UE0mczUX1sp4ZmEayQsrhag18h2UWLGF3c+6gZv3Tl2fgrebJ9d8XpwB5vsaTBJE97jNAE3UhTS9nUTMY6cHR+C01FdxQvTZs5v3Z8lUauJjSp//5X09NmlurmtUIADW5S0LDGQcid/DyWAG/y4EXgAiL7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192678; c=relaxed/simple;
	bh=f22M4RVhMbmE66LRzxXAy87AOHoJRnUVjIGZ1yj9Q4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q19BpBa/NicsYLh0JjPFAmjxRRS0RzI2jW29v4r6tvGs5Nqo2LGL10OnET+MLBOtDcTL1+3qNP0/39jTrqAIG7hYEQi3UJ/d80Sw5480zWeTHk94Rn/EkEht9gAwV7bUPZ7cnRnb8Iy9AWKyKNpG9QbEw8B9mq55Fe7sUGhP6Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6PzPl0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6PzPl0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7ABC4CEEB;
	Tue, 22 Jul 2025 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192678;
	bh=f22M4RVhMbmE66LRzxXAy87AOHoJRnUVjIGZ1yj9Q4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6PzPl0p4AvrnDIk8Tq39R9CB+34hZFaNg+QK8HShK0CQka2HevDUJOJBoE7RhGSm
	 PmrUIM6axh4K2obDdsIzypjCY8gb8l859ovLD73UnYzV8o/NcA7E8s6gt7zLG7kqnf
	 dnR4XL/78fgkMVEb0+VKlZ+MBJhf8hmxYAyG0jxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 025/158] tracing/probes: Avoid using params uninitialized in parse_btf_arg()
Date: Tue, 22 Jul 2025 15:43:29 +0200
Message-ID: <20250722134341.682349070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 1ed171a3afe81531b3ace96bd151a372dda3ee25 upstream.

After a recent change in clang to strengthen uninitialized warnings [1],
it points out that in one of the error paths in parse_btf_arg(), params
is used uninitialized:

  kernel/trace/trace_probe.c:660:19: warning: variable 'params' is uninitialized when used here [-Wuninitialized]
    660 |                         return PTR_ERR(params);
        |                                        ^~~~~~

Match many other NO_BTF_ENTRY error cases and return -ENOENT, clearing
up the warning.

Link: https://lore.kernel.org/all/20250715-trace_probe-fix-const-uninit-warning-v1-1-98960f91dd04@kernel.org/

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2110
Fixes: d157d7694460 ("tracing/probes: Support BTF field access from $retval")
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -657,7 +657,7 @@ static int parse_btf_arg(char *varname,
 		ret = query_btf_context(ctx);
 		if (ret < 0 || ctx->nr_params == 0) {
 			trace_probe_log_err(ctx->offset, NO_BTF_ENTRY);
-			return PTR_ERR(params);
+			return -ENOENT;
 		}
 	}
 	params = ctx->params;


