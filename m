Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE91C84DE;
	Fri, 10 Oct 2025 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102527; cv=none; b=ZtGO6KmYU+ZGzcy1ypE7//QT3wMEHL8yRIcLnadISjyX2mU4FQ8pIUsVLPdBAIiUCWVr+1FxbKOMZYFH1xkcB5kItlEw1HwK0y9PzcssQ4KYFSpvqTXuQTIeciocAykw12PcD3jRSuF9zAsrUG2Px4FfPQjOI9Z5GrjJLy6b0V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102527; c=relaxed/simple;
	bh=u6sdhf2Ho5b7EjQw+aflC6r4iLDaZ0KltIj6Is25DUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtDDumIpZ3mVF/l4UNEft5NtQqdOoNI0AMi0ILTW/Bf5nhTxk/LaM0Rnf5NuCgLN6Hgidyflp36IUY4nJI1DtTfSrlF28y5yxIyInfmM11ywv6WZXCL+OBbKT/F+NDOj9Y4K523cUjQkvx5tnaziqzBowTjt43ni9KbH6jT/Mn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSgdFMA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSgdFMA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E5AC4CEF8;
	Fri, 10 Oct 2025 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102527;
	bh=u6sdhf2Ho5b7EjQw+aflC6r4iLDaZ0KltIj6Is25DUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSgdFMA84mXNj7ga0Su2CLUIHBCjYUnGuQJtVZBkQp1PaJ3JJXcvE2khwLnVr+cht
	 ud/hFoMLREr7KpKj0z2Kc+5IFFgamfBb0S2mkqJHc0TKP1N/4UG6geh4hfDPyFJ9SC
	 ovo8L++I45L9hxtjTvV5/RuKe1DIZTjh7MBM020k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hupu <hupu.gm@gmail.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/28] perf subcmd: avoid crash in exclude_cmds when excludes is empty
Date: Fri, 10 Oct 2025 15:16:28 +0200
Message-ID: <20251010131330.738471603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



