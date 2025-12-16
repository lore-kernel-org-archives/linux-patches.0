Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E43314D24;
	Tue, 16 Dec 2025 12:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888506; cv=none; b=AL7qccB/Tf6dENGZpl+/W3ZzYeOzIYGnbMJJJYT4a45V++eDMnJHpuG/GnGiSFbZkIY5ltjRze/MpoHC7UflYCwCAL5J78ZskucsxUYndpXr03oNPaTgnDhxrtRyTwSQMb94ZNTu2dDY+j6vZvA9gRwxIiEPL2hPeMEq1E6Axlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888506; c=relaxed/simple;
	bh=Oz0ynnMGdh2kQSRtTSBikUFuY1EDKdru5JCtC3ktSBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pn3HW7Cc57p7FpFJZ4/nfsxuJMnMh0lDs8Flb45SQdWLWtScLngTcw0fa8AaSfhwIPg97vQexyLnNxrbRL0UpJqsB7S+DccpgYRMFHTxpPcUvBp2NBFSqhIHzN8nmU0rgcYilkaktcOHITTw93AYr99Skgcv5atxvEXo8M9KRtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2L4cTMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2L4cTMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D40C4CEF1;
	Tue, 16 Dec 2025 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888506;
	bh=Oz0ynnMGdh2kQSRtTSBikUFuY1EDKdru5JCtC3ktSBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2L4cTMeRCroJS0I0ab+ziHS8VDKHS0swXG5HrBC4pKvJ0p4d4bSuJuxCLr8toGh6
	 QZ/x6hj5+8k6VAjsovrBvwAtX2CXwT4obgjtShZC/Nt5eBRq51YJJS8JBQf9mLlKJj
	 Sw9GZ+hQIlS7e5+KH+Gyg9rCrAfM7X3Vj1EW7nPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 527/614] perf tools: Fix split kallsyms DSO counting
Date: Tue, 16 Dec 2025 12:14:54 +0100
Message-ID: <20251216111420.470801019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aed65b1abe669..f6c268c588a56 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -964,11 +964,11 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
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



