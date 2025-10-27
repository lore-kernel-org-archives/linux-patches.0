Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6A332D7DA;
	Mon, 27 Oct 2025 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590951; cv=none; b=Icnl+MyGNda3+uT4u6pgz6kQqU8QesgcrnKKPOJis06tIm8/EYTIlnBIHeJDiqXjrDTQgeWyc9lwQvihvnJBj2jT5tTj99YzFspC5iPPfzuU0LbeAjq9SvzPXDxIvWjNwNtDg7OFQXYfMdCxPBAuaj00IFh7NgJe+FUycKUN//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590951; c=relaxed/simple;
	bh=EAR5R5Xay42Gr3Em0PqthT2kYbsbG4OiGUXprFcCiFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXByD1uCnOODGsmxCmYJactc+bTXcfeBbaIxBa0pJwoKCjSs5kUh8RftVDa6Oqnjc8oebxL+RGNEGIkTrhyrmyVdaK8V3BjMRIhEq1pgqfPWjhQszilVB7Ky+j/OJNeNxQY88q1HE686S+o05a2qtcQ1gyG20tQM4uEAKG8rlHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bze3TsY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bze3TsY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFD2C4CEF1;
	Mon, 27 Oct 2025 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590951;
	bh=EAR5R5Xay42Gr3Em0PqthT2kYbsbG4OiGUXprFcCiFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bze3TsY5KFeTbXJr7h4DwHhneIobXS9FjwxKG2Ob/5+8gH47wg6xFfr5Eo6+R/c4k
	 3dGPxH1KUwKrpDvO1pDudJ0Qx7kHI2RalKl3v1FMRJNlHExRJOkZroNwoWToS5ZZb/
	 Onh4OJhB2Qj5ZbwSm8vEnftarZVwlGc+gSaVUfo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hupu <hupu.gm@gmail.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/332] perf subcmd: avoid crash in exclude_cmds when excludes is empty
Date: Mon, 27 Oct 2025 19:31:04 +0100
Message-ID: <20251027183524.919763450@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



