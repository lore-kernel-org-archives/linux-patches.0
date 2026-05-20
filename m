Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B903B0AD6;
	Wed, 20 May 2026 17:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298681; cv=none; b=T6JerT7VPW+bBSM/qDc6WOLBRmhbvpq50I3tL/XJmxUfEO2p+oXfz8cadMZrzfoRXIWg3zK4Ph5wavqFNW4mcpWI0x+4bYjSlMDlhjnEdjgie41siP1Lf4Z2nCNsS5C4dzmMYi6fT0LCo3itxRbxEgY3i6mFx6DnZ9axMmHCY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298681; c=relaxed/simple;
	bh=C/Xqa39n5lQdIxY8gwGGerG+rGYJBq1PkPs2LreMlPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smJ7tO6u9Pp2GRN0Vlk1aOwo8PizhRncvvExK8GsE+NVUBBW3EB5d7FrKm9NiCTDmewuqiO4+vSaWD883ufuREFMxcmCzNGzQaCOq2H/ChgOqmhLAKJg0z06hxGnPuTiITE6CRPErnFT1tyJ09a8waQMENmTC1/F1AvWaljJqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W//MXshW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W//MXshW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86771F000E9;
	Wed, 20 May 2026 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298680;
	bh=+diRldzVdtfpISQdUKbEqCLN36oUPLvarUvnP/dz47A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W//MXshWWjlnOTxG8fidOlPp/j1zoq9t4bsd26snBZJDen61QWQ/HZWG1xv7J0rte
	 PgNRnoYPAkIwcAKqEpeM2Lc8Ivj1FWBXavDpo9ZXw2hhkJrrY8DKT+37XXDD/QGdCD
	 S2mdcngOb/M5EDsbiqGXCXAaL9C2qNYiwEfwxLc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 503/957] perf branch: Avoid incrementing NULL
Date: Wed, 20 May 2026 18:16:26 +0200
Message-ID: <20260520162145.440669134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



