Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C421ADC97;
	Tue, 21 Jul 2026 22:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671956; cv=none; b=u8uCdEmH009ZnezWOe9RSHuP/kMKeWiTAUDXBxw0Ta8+zikqcHFEZvYtFG90shU/IVbg/JF2vxCtoInDNNls3OYzDU5sZLEIpmSIZDmk5MxgG3gZ9zkmiRSYEyNdc+T9zJSXAXSfqkvZw5LVr80ExJUP2eAdDEYwU2wAfDtTFYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671956; c=relaxed/simple;
	bh=3aR2fLkahuxe5qcH+EydQdh+0kcMMT4+0URxWgauPrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mC2DQptnSCRZ7DpwoQW7fEMDEakuhgjwSgWdDBOXbsweQrdSkfKcPrtFPAWrYmvbt15iXMnATAwcywo5pFjTH3N9fIxJSgDBfK8BiZ+wuB/MZSsIQn3cSOFq2GItAi8pHPUT8JzNr72vjiQCLJlgk/rbmTGvDEG6dJk/MAN/A44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FI1c2xap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FI1c2xap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5242C1F000E9;
	Tue, 21 Jul 2026 22:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671954;
	bh=DeA8ECmkYz4aaXwpoSs2394IsH3EmE9cIMAy7Vrpdho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FI1c2xapAX0K22eR18cNuT0cAe5QeQj1eWWTkv647B6490N7HzX+rmparzeqJJ3os
	 M52x4CfXVGlGO4W1pyDsRq1J1o9hmCqOqeYrxORMw2NR3F/XtLPI2BPgqtLWS7QTpp
	 qNKseESElcZ3mSBCQGl99kGqnnlYFYrWV3In3Ps4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Don Zickus <dzickus@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/843] perf tools: Fix get_max_num() size_t underflow on empty sysfs file
Date: Tue, 21 Jul 2026 17:20:40 +0200
Message-ID: <20260721152415.147618031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 87d3eca9b872d8..e80dacb3607772 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -307,6 +307,12 @@ static int get_max_num(char *path, int *max)
 
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



