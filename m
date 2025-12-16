Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E63314B4;
	Tue, 16 Dec 2025 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884852; cv=none; b=AoASQHKmSrY0aa17LKopxChexCY0wOZ2qo/NqXw0uLzwVUOWYINbW4tFJAyNCTUTchU8UNoNHC7BgwzsMlSF+/w86d/2DD7tARDL2Oy4SvLkNuHwTl9EfqEQ/3YE0RNsOkuitpBQW2+IcxAX7MQ5iynznTklYxcu40pCXzhOF+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884852; c=relaxed/simple;
	bh=nl5PfJBrkGtwTcqqtM0hi4mi6A5iCdEi+TwJzhMKCLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmBp9dKv6uWx09JN/va5jeNsED9RGnD1jT5X9q9lKAwCwDdUWqcxmzSLv5f5Pb6pmvYd7op5/EI7TLZw5Pdmws9oowOxEcb6WL0e2180HJKFmdeBI8Jml1CLYobcQRzRKhFyfOfdSXnxjh85JEyILD5YrbEMsCbAMIZ4KN5J/98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOQLziie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOQLziie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E1C16AAE;
	Tue, 16 Dec 2025 11:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884852;
	bh=nl5PfJBrkGtwTcqqtM0hi4mi6A5iCdEi+TwJzhMKCLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOQLziieEJgMWRBS5mKrZ3sOhAzkF6DWZ6+0DFMwTmMRM5fUiehqDH12PxTDSsakI
	 wc4LyrcQwy2RoiAiBkx/VFv5RzHlxZXT7lRRohDv9Bk0oprJq+/R8h5AXiebdPlAtc
	 t06GipzsAFZZL1dyA9D3+/6KSAyFvKjZUCVzA9+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/354] perf tools: Mark split kallsyms DSOs as loaded
Date: Tue, 16 Dec 2025 12:14:12 +0100
Message-ID: <20251216111331.238829995@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 7da4d60db33cccd8f4c445ab20bba71531435ee5 ]

The maps__split_kallsyms() will split symbols to module DSOs if it comes
from a module.  It also handled some unusual kernel symbols after modules
by creating new kernel maps like "[kernel].0".

But they are pseudo DSOs to have those unexpected symbols.  They should
not be considered as unloaded kernel DSOs.  Otherwise the dso__load()
for them will end up calling dso__load_kallsyms() and then
maps__split_kallsyms() again and again.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 2e538c4a1847291cf ("perf tools: Improve kernel/modules symbol lookup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c0ec5ed4f1aa4..c60e38dc39db7 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -950,6 +950,7 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 				return -1;
 
 			dso__set_kernel(ndso, dso__kernel(dso));
+			dso__set_loaded(ndso);
 
 			curr_map = map__new2(pos->start, ndso);
 			if (curr_map == NULL) {
-- 
2.51.0



