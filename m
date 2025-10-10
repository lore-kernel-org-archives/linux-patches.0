Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148FF2F2602;
	Fri, 10 Oct 2025 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102328; cv=none; b=bEW1U9IgSRBPSee+aspKjl5Fj2htcvfXoxBo3mAIGhRZqDeWMSe2yVAPZjNL7L7wpkRb+PD/KKmHSgP5umT3qAZEMBCPbIKYHtT9pjQWdZROBB/y13+JbMKFIKkrguf1W4HET4ZQxN67mxzHs2Vl/czLpy6i08gW3pB5hm8dhfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102328; c=relaxed/simple;
	bh=WzZ0ZGeIEmazbAgND9zPmeNR1+XD8z/WE/tyrHtebdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP+LhARqervrkCDHPy0I/KsE8hQpZzs2npp2b1GVQzeYvZAD4OtLvLFQPufuZOYnJrnGZCA4BZmJLMSErpIwWt1fqq5Muk0OKTGXUhQVJNHwDug0wyT2rPI92183IGt+2IA6oc9p7YaJlEuElfYLDX3JmXpSaHwxWkcyhWI6pH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lG55lMhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lG55lMhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4173DC4CEF1;
	Fri, 10 Oct 2025 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102327;
	bh=WzZ0ZGeIEmazbAgND9zPmeNR1+XD8z/WE/tyrHtebdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lG55lMhcMvoOr/6KhgdvknfsYGh1SNdNK+SEbmj0ptoysQFibD0KIwQ56NDZ6WqkS
	 CnKTtLXTPSA+DxNbRxrRuvR/cbt+/b7aDqLtETZYAqsvuADKXi6mLLMBNyeboBm9hl
	 WFgtfKm2GJBUGLA/R6bcAkVa7g3p5iLg+AV4EHR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hupu <hupu.gm@gmail.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 18/41] perf subcmd: avoid crash in exclude_cmds when excludes is empty
Date: Fri, 10 Oct 2025 15:16:06 +0200
Message-ID: <20251010131334.082671528@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hupu <hupu.gm@gmail.com>

[ Upstream commit a5edf3550f4260504b7e0ab3d40d13ffe924b773 ]

When cross-compiling the perf tool for ARM64, `perf help` may crash
with the following assertion failure:

  help.c:122: exclude_cmds: Assertion `cmds->names[ci] == NULL' failed.

This happens when the perf binary is not named exactly "perf" or when
multiple "perf-*" binaries exist in the same directory. In such cases,
the `excludes` command list can be empty, which leads to the final
assertion in exclude_cmds() being triggered.

Add a simple guard at the beginning of exclude_cmds() to return early
if excludes->cnt is zero, preventing the crash.

Signed-off-by: hupu <hupu.gm@gmail.com>
Reported-by: Guilherme Amadio <amadio@gentoo.org>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20250909094953.106706-1-amadio@gentoo.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/help.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/subcmd/help.c b/tools/lib/subcmd/help.c
index 9ef569492560e..ddaeb4eb3e249 100644
--- a/tools/lib/subcmd/help.c
+++ b/tools/lib/subcmd/help.c
@@ -75,6 +75,9 @@ void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
 	size_t ci, cj, ei;
 	int cmp;
 
+	if (!excludes->cnt)
+		return;
+
 	ci = cj = ei = 0;
 	while (ci < cmds->cnt && ei < excludes->cnt) {
 		cmp = strcmp(cmds->names[ci]->name, excludes->names[ei]->name);
-- 
2.51.0



