Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6A1DE4E1;
	Tue, 16 Dec 2025 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884855; cv=none; b=iHQogaMWpFvQ9p03KoL++UsqJAzPaUKmfV+xvhm7EF3m/3AxMZG2aFWcZCJpVdJ1Dqr13dD04IL2/RhrvCjlRPR9XiZZyCa7c/BBX0iChRSmF1S7cVBp0Mm1E8zmKZTCFDSMq69tmsAxwXUnonEzF1hkaE1wqQCwq/jCnWDxOvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884855; c=relaxed/simple;
	bh=HpX/MM9moqfUpgf7R2dkUsAMF+zUAsD6X64K5WyPag4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rpb8qOH7aC5FtICBm5P8BDte1sdEguBWg55bVfss8YIBxXcWC+xLBTnjcDNws0f/qcqPBOH/2zXitLYJCOIqOAoOKqPs4z6MRuxBNPI3PRCMkpVw+tDEiUKGfwE6CpZswtIYdgx4sIaqrdOGuuatabDZWJlj1+eQy3xZMJP/Ts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKmn2qNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKmn2qNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403E9C4CEF1;
	Tue, 16 Dec 2025 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884855;
	bh=HpX/MM9moqfUpgf7R2dkUsAMF+zUAsD6X64K5WyPag4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKmn2qNJZ2zU27BFvtk4mVZ/IndIN1FQvUdbhOCM5ws1na1vb4k28xDf3O2HCGLYX
	 dhSSZVJw4PykiACkZtxk0fTSGlTIl9XQLa3CMBG/dHsLLB3PkKSOC50jwqS6KRWIZa
	 IhMupCKQEK8bcpqNYXtoDSuCCPHHNT6hxZeOKzRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/354] perf tools: Fix split kallsyms DSO counting
Date: Tue, 16 Dec 2025 12:14:13 +0100
Message-ID: <20251216111331.274275322@linuxfoundation.org>
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

[ Upstream commit ad0b9c4865b98dc37f4d606d26b1c19808796805 ]

It's counted twice as it's increased after calling maps__insert().  I
guess we want to increase it only after it's added properly.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 2e538c4a1847291cf ("perf tools: Improve kernel/modules symbol lookup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c60e38dc39db7..249de806f8e0d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -938,11 +938,11 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 			if (dso__kernel(dso) == DSO_SPACE__KERNEL_GUEST)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
-					kernel_range++);
+					kernel_range);
 			else
 				snprintf(dso_name, sizeof(dso_name),
 					"[kernel].%d",
-					kernel_range++);
+					kernel_range);
 
 			ndso = dso__new(dso_name);
 			map__zput(curr_map);
-- 
2.51.0



