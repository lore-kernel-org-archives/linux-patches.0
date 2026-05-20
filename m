Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252937D101;
	Wed, 20 May 2026 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295997; cv=none; b=AdYagKc26V/ZWE/7aETqy0TcnzOMFj4E8GOg+UyIZ66cD8MePqUb6iHBhA98EcVBHZrcs+yQgr5qpHARV4ofqIRYtFNFwzZtuDmWwWR5TmTbaeLHItRO2PQu0u1LtKmrKZHex19/Rl7iQbrtk6yrpXZ2zRm8fsXvyMJ6xMscwnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295997; c=relaxed/simple;
	bh=Oppwd2PnB2snD9hCfxp1suLZmxx3F/FTmxnL6N3g/so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+wHqtB757DAK0Z1ZxnuSDp3Gh7YX0zKFewVLOUD3RTV0VKKGPjGpSTwgb2ENegU2EUOjFrVQxq9KUjtWzvxhMPWixG/Bb8RRmF0zIhpoHuLZ8KnerSkFYEq+3l38UtIDAPSpvnpqLZib0VHcW3vc/86h0iwdPb/Wsdv2o3r+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeU7BpRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeU7BpRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E611F000E9;
	Wed, 20 May 2026 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295994;
	bh=jNqQXRB3EoSoUSOQ+HYC2xtGepccCJt8fZkIAZTN0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeU7BpRhP/Xfn1cwzrqwL7ba04XEyBLHu5iMiD98GluOIqppeuPxsvUZFL2sncMq8
	 QzqYEbvZFImS716MuFu+1QMv5iNQF/PIVgrLt12rmCNAbkBg4p6wqcJXSBcnXMWynH
	 le7+3QFJgKDL6YOZk1sqXd8Z+Fwa/9Fevrxy5jY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0631/1146] perf branch: Avoid incrementing NULL
Date: Wed, 20 May 2026 18:14:41 +0200
Message-ID: <20260520162202.467028333@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit c969a9d7bbf46f983c4a48566b3b2f7340b02296 ]

If the entry is NULL the value is meaningless so early return NULL to
avoid an increment of NULL. This was happening in calls from
has_stitched_lbr when running the "perf record LBR tests". The return
value isn't used in that case, so returning NULL as no effect.

Fixes: 42bbabed09ce ("perf tools: Add hw_idx in struct branch_stack")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/branch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/branch.h b/tools/perf/util/branch.h
index 7429530fa7749..a1d4736497c40 100644
--- a/tools/perf/util/branch.h
+++ b/tools/perf/util/branch.h
@@ -66,6 +66,9 @@ static inline struct branch_entry *perf_sample__branch_entries(struct perf_sampl
 {
 	u64 *entry = (u64 *)sample->branch_stack;
 
+	if (entry == NULL)
+		return NULL;
+
 	entry++;
 	if (sample->no_hw_idx)
 		return (struct branch_entry *)entry;
-- 
2.53.0



