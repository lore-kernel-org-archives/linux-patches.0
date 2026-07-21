Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0846EF73;
	Tue, 21 Jul 2026 19:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662579; cv=none; b=qCMmMy2DFO0KMM6YkSYDJh808ZLkX2pNREonSuSttFHy5LgXo8OuGIX1BuyKS2KGObR5fch+zKYYr20CfJXAuKqQvLvukmg2ICKQCHCmOgjqb4zlV1aURO+brxwNwNRtJz6/K2v5Z1x2ITaYSAU2G2dzSVjBhq94V0fiI2CN2H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662579; c=relaxed/simple;
	bh=xXUmTsPQmzaD6owYRknI4+kR2F22uUUqr5Xrl93mFHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RH7r3FmB0ePx2Rfha11w77BumT5k5nXF0ACaMtzIT8epPaHoM+jm1PDuqtLrtn49J71C+1wxJShXCeKfwoxxqn22+MDHd9YvSzMw7j6L+cjBpK4zjH0lDD1ARa+shKOlMUu7rBLu2oWO9mJNC4H2zILP9iMhz17nqRNEhH5MJFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpMXOAs3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpMXOAs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258ED1F000E9;
	Tue, 21 Jul 2026 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662578;
	bh=Qm0dNV/ATqCwyZMampMsmqUN2nxN/Iuim6jcZsFSGSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpMXOAs30IsEXetsTQChQwkH2m1TnOEqSSgOMJo+dl4fjdBZ9a6cIex6klrg/dAHF
	 tviK53IXNyVRaTncjARdUcibIgNxh/nkcQiRLFasHXiBebS0FPaIrYhdW1iSB3Pia8
	 DSk3K4HlofrZZ2pDKnFfD1FcR0gX0jsw6WQsoL5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Don Zickus <dzickus@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0497/1276] perf tools: Fix get_max_num() size_t underflow on empty sysfs file
Date: Tue, 21 Jul 2026 17:15:40 +0200
Message-ID: <20260721152457.225873501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 0a012113bb3a44482c163f16f4db03ccaa37a339 ]

get_max_num() reads a sysfs file (cpu/possible, cpu/present, or
node/possible) and scans backward from the end to find the last
number.  If the file is empty, filename__read_str() returns num == 0.
The loop `while (--num)` decrements the size_t from 0 to SIZE_MAX,
reading backward across the heap until a comma or hyphen is found
or unmapped memory is hit.

Add an early return for empty files before the backward scan.

Fixes: 7780c25bae59fd04 ("perf tools: Allow ability to map cpus to nodes easily")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 7cafa6672d4fb4..388755a4eda2f2 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -402,6 +402,12 @@ static int get_max_num(char *path, int *max)
 
 	buf[num] = '\0';
 
+	/* empty file — nothing to parse */
+	if (num == 0) {
+		err = -1;
+		goto out;
+	}
+
 	/* start on the right, to find highest node num */
 	while (--num) {
 		if ((buf[num] == ',') || (buf[num] == '-')) {
-- 
2.53.0



