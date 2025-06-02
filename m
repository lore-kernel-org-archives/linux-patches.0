Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7A722539F;
	Mon,  2 Jun 2025 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873476; cv=none; b=u9SdlnZMKC4V6156TZRcmjK8arYokBsxXLUdcZji40Y+BcNKw4o/eGzlujGIH6T/jzVyfIBOPNfd603lEic2Ll45iI9+ObYNFuPGQmfOkg9bErcblahmpe5AwVCI60V4SaVsKeyvnpQ/4IYs4Mg4ZwYX52+wMwWzR79vNjZNAIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873476; c=relaxed/simple;
	bh=HUBPuTYdz86RYGiqkHq3Y0rQsbfADyeYr2zFNsSc6WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4U2TIEdZeMMYI93CVkv/4lRylZWyrvkZWU04j9fQ+gVcQsV0lUtKgSbHA+p335GLi8ylp4qxT2k9Z5EUnY9okEKiLhccfNr9N3q4rGdN9L9XE7t6/lQSwdGIz7bb5wy87axEKZ+WcPD/DweYXzdqmzsh1LEVUrsVyc3If2m/JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czgiTahH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czgiTahH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D360C4CEEB;
	Mon,  2 Jun 2025 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873474;
	bh=HUBPuTYdz86RYGiqkHq3Y0rQsbfADyeYr2zFNsSc6WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czgiTahH88uSnSwyrALse4vE3cGij9AbSPD6rTvhZ9XUE7Fw2Cz/dvBBZmgpvzXva
	 MyA6NaT+0DFVLtKFeBV5yqc7GkFudk+4Zo2uU5l5VlGQOLn0bFHCp8vi1IQLM8uwaA
	 js/AhC6MYwXPiVyv2GeUaUwNmffmJtrNxstPytl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ian Rogers <irogers@google.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/444] perf/hw_breakpoint: Return EOPNOTSUPP for unsupported breakpoint type
Date: Mon,  2 Jun 2025 15:43:37 +0200
Message-ID: <20250602134347.118565538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 061c991697062f3bf87b72ed553d1d33a0e370dd ]

Currently, __reserve_bp_slot() returns -ENOSPC for unsupported
breakpoint types on the architecture. For example, powerpc
does not support hardware instruction breakpoints. This causes
the perf_skip BPF selftest to fail, as neither ENOENT nor
EOPNOTSUPP is returned by perf_event_open for unsupported
breakpoint types. As a result, the test that should be skipped
for this arch is not correctly identified.

To resolve this, hw_breakpoint_event_init() should exit early by
checking for unsupported breakpoint types using
hw_breakpoint_slots_cached() and return the appropriate error
(-EOPNOTSUPP).

Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: https://lore.kernel.org/r/20250303092451.1862862-1-skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/hw_breakpoint.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 6c2cb4e4f48da..8f3f624419aa9 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -950,9 +950,10 @@ static int hw_breakpoint_event_init(struct perf_event *bp)
 		return -ENOENT;
 
 	/*
-	 * no branch sampling for breakpoint events
+	 * Check if breakpoint type is supported before proceeding.
+	 * Also, no branch sampling for breakpoint events.
 	 */
-	if (has_branch_stack(bp))
+	if (!hw_breakpoint_slots_cached(find_slot_idx(bp->attr.bp_type)) || has_branch_stack(bp))
 		return -EOPNOTSUPP;
 
 	err = register_perf_hw_breakpoint(bp);
-- 
2.39.5



