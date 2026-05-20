Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD450366542;
	Wed, 20 May 2026 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294751; cv=none; b=LFlJjlJdiXH8j8AvTbfPwv3Eu4mKOgZBT2aZiAR4lyUGS/O/sqdRc+nepZ3N+0tkwyQdgbhyfDg343OyFWtPOPnNwTTu8hpG7MsEZh5no4VSHsV0TSO25aN81AIE580ECJcti8PUWpW7uK3ko6Vkawu1eOhVKbOn8/FhgTM/AbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294751; c=relaxed/simple;
	bh=mJ4Zk2/n5ikigvqBfzEgxz7wRQ27vsZDO8NjDpUbnts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E75f4nGZVFyh4Yzq7fh08qOfHNQRPH1YVa/CP7SmjgcIPpqBtDqgH8SpW3UMrgOAoHe8Uhx0xeK/39QvVpOK7KC3jsdqkOSe4R94fd72bIEZFSg7jSaWoa7zoWTsTmD/ccl7dn7bSLXHHBChnaQLLDJ2MqoC38iLMeftUYf1HB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ConRCf8A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ConRCf8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E44D1F000E9;
	Wed, 20 May 2026 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294750;
	bh=l60iTYtQnxaeGhilKuhiVHCYJdooq9OteLW97aCWY+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ConRCf8AAcH77uDqAHzQta3hLRR3hoY6T/GkcAieMgM/EPvWsNode9JYNnDb3KeR8
	 MHzdd6Sr3Df3Dj/ARb+JXAx6cyq79YdVwHxQUesRr8oByLCQduhGRu/Xq0uU5IikiW
	 hWEBrUeNnqoR2J+ehdhwb0fWMl+3QviMXB7BYLqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0157/1146] bpf: Prefer vmlinux symbols over module symbols for unqualified kprobes
Date: Wed, 20 May 2026 18:06:47 +0200
Message-ID: <20260520162151.853210168@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>

[ Upstream commit 1870ddcd94b061f54613b90d6300a350f29fc2f4 ]

When an unqualified kprobe target exists in both vmlinux and a loaded
module, number_of_same_symbols() returns a count greater than 1,
causing kprobe attachment to fail with -EADDRNOTAVAIL even though the
vmlinux symbol is unambiguous.

When no module qualifier is given and the symbol is found in vmlinux,
return the vmlinux-only count without scanning loaded modules. This
preserves the existing behavior for all other cases:
- Symbol only in a module: vmlinux count is 0, falls through to module
  scan as before.
- Symbol qualified with MOD:SYM: mod != NULL, unchanged path.
- Symbol ambiguous within vmlinux itself: count > 1 is returned as-is.

Fixes: 926fe783c8a6 ("tracing/kprobes: Fix symbol counting logic by looking at modules as well")
Fixes: 9d8616034f16 ("tracing/kprobes: Add symbol counting check when module loads")
Suggested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Link: https://lore.kernel.org/r/20260407203912.1787502-2-andrey.grodzovsky@crowdstrike.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a5dbb72528e0c..058724c41c469 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -765,6 +765,14 @@ static unsigned int number_of_same_symbols(const char *mod, const char *func_nam
 	if (!mod)
 		kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
 
+	/*
+	 * If the symbol is found in vmlinux, use vmlinux resolution only.
+	 * This prevents module symbols from shadowing vmlinux symbols
+	 * and causing -EADDRNOTAVAIL for unqualified kprobe targets.
+	 */
+	if (!mod && ctx.count > 0)
+		return ctx.count;
+
 	module_kallsyms_on_each_symbol(mod, count_mod_symbols, &ctx);
 
 	return ctx.count;
-- 
2.53.0



