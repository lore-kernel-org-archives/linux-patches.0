Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B54221579F;
	Fri, 10 Oct 2025 13:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102428; cv=none; b=WpMVGHHDa91Jcuny6SgsGHN4RP/f+nlvCIMppUhR8edZ9bg4v3saTfF0yJqjFcPcM8ZyKfafpl0CX2bqIbOh5Id3MBmirswRXNa9LYrw98JR997OvyBgcYHyM5cqnwRG8P4iaCGhC1hyeaT4AxYXARTjBEap5bwkm1SvKHnQADA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102428; c=relaxed/simple;
	bh=1BHjjyQNT/lTS7xxvhvBwqfr88hAUOMpVo5YpnQV4gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1UM0k/awEcVuhMDgi6lUPzFgDmVgMVUxqwLDdqGZWPb/rHBUdQtZzYEeu8xSXS8cYxWsTRKXvRjRWolYmBg2kNlsKhYTb//XUPSpHJfUFeCbRFtW1FMbD+T9HdbP5LmzDqHu6qIkf8U1titJ4hobjKR0PvmqxOS1gD4Ma3m7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzCVC6Yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzCVC6Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A117FC4CEF1;
	Fri, 10 Oct 2025 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102428;
	bh=1BHjjyQNT/lTS7xxvhvBwqfr88hAUOMpVo5YpnQV4gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzCVC6YtnVFAsRhftR6BJBrg+MYxKTI6T1A4gShJ515EQCyFfxCbjcm8/MmbrSlOe
	 xX/tDGx1H8m9r3+w4y+LZfCJzVBDyJUr7NgHCbe2bk6qHgsuf/msA1NsRLBYxEoqH6
	 3i0jnP0JhdzXS0kAmFzsMvFkBNx0JbUZVHrERQBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hupu <hupu.gm@gmail.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/35] perf subcmd: avoid crash in exclude_cmds when excludes is empty
Date: Fri, 10 Oct 2025 15:16:13 +0200
Message-ID: <20251010131332.199727804@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



