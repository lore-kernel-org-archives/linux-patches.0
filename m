Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B64330B00;
	Fri, 17 Oct 2025 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715925; cv=none; b=LoaSKgMw7MK1CPH6BY8YSWXxrVxUY4Gc4JIgU8bd9FJ5Lg7JdzsgA8tLUtt1wU6XgnfaEwXwkYdaoQwwvEaiQThwplFA6NIKSs+eeHG8tSa6L5P6+TH2VLKKap2c75Qcl5SlQPpbT2t10uq02pgN4I0UAUTsS0i0oon22SpQPBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715925; c=relaxed/simple;
	bh=Uw7qoxz+AOJ63hesYAdCv+BbJgAjPeFOl63Uj0FNZ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1dL2+BwYQGOQ5Dc4zvgrgV45NwNOGuwHAY+oN8JcrUgSBuLWxjSLJ9i1dckCaxHAPqsIxQlU05JTxJTTy4OO0HsJKPsCX61llwjlZQTJzndz2eldW4z8O5wVBEj8zB3SkJlsNWW+Ub/s3rErSPxnQ2kYh5WotJ0GHyIUv8ns+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDNAl7VA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDNAl7VA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A1FC4CEE7;
	Fri, 17 Oct 2025 15:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715924;
	bh=Uw7qoxz+AOJ63hesYAdCv+BbJgAjPeFOl63Uj0FNZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDNAl7VA0uA3gE52BbW429llql17ijQ69lYHxcvAT7QgJG6bONvWMTwTftnHdopXX
	 icLNX47bkvhBZXbVjhmrzKeoUlrP3nwGCgCDMPlyINbutNUlq9Ift9vzdEy1WB2+3r
	 aPdsKbXUMaFVmCr/Kz8ZQAmrJTQ4IVpwaXkm40YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hupu <hupu.gm@gmail.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/276] perf subcmd: avoid crash in exclude_cmds when excludes is empty
Date: Fri, 17 Oct 2025 16:51:46 +0200
Message-ID: <20251017145142.884260760@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 42f57b640f119..687307f2fe0f7 100644
--- a/tools/lib/subcmd/help.c
+++ b/tools/lib/subcmd/help.c
@@ -72,6 +72,9 @@ void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
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



