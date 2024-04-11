Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBEF1448EF;
	Thu, 11 Apr 2024 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830299; cv=none; b=SS8AuPQasyyg49DMcnrKW2kJa2Lr92XTDwHW4INjSJ3w4Vh20Dr9vp88mjkjm+A8ZHvg5aHpoWSI1tT36Cux/ajQMyu6DD9NT2DzY3vdZEKMdWpcJhUHhJxFd6nml3sRZCvUi/XYA4Ng6WEBafS31zIXvO17KHuaYkgUJT5QwXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830299; c=relaxed/simple;
	bh=obBQv44/uyazFttoLg2ylLM9H35w3CTwk9SbERmwFxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkjfh6E8zYq4Xu68/TUbLVMMMzA83tgBUUcbvoe7Qc2HiMFebr7gbyZO5iQYZ4GF7mEIc30kGkpLxtCjoTtqoikrpHirRtwpvHbQ3x0K4P5T+1U8nAiQskmtQRE9EI2aqXEP0iBwqzlbxAvRMPNfNk3Kt7BqtzLvaaWtufNhav4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQc8nbLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQc8nbLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5CCC433F1;
	Thu, 11 Apr 2024 10:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830299;
	bh=obBQv44/uyazFttoLg2ylLM9H35w3CTwk9SbERmwFxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQc8nbLymblslWi7sbpGCLZqCkSM77KpKe1RmaZRy1fYo1dDSM0HUq0OX1qviJIAQ
	 RXqgH7H7c2oZcyokeM6+Mvaq/tnHAYCeyCJE0Mz++DJUID0gpiB6ctoCMB+jFqYdUO
	 reHWgobXL05oRMuw3HPE/4zyfN9jUqhrI/v0UJp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 103/143] perf/x86/amd/lbr: Discard erroneous branch entries
Date: Thu, 11 Apr 2024 11:56:11 +0200
Message-ID: <20240411095424.008480203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 29297ffffb0bf388778bd4b581a43cee6929ae65 ]

The Revision Guide for AMD Family 19h Model 10-1Fh processors declares
Erratum 1452 which states that non-branch entries may erroneously be
recorded in the Last Branch Record (LBR) stack with the valid and
spec bits set.

Such entries can be recognized by inspecting bit 61 of the corresponding
LastBranchStackToIp register. This bit is currently reserved but if found
to be set, the associated branch entry should be discarded.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://bugzilla.kernel.org/attachment.cgi?id=305518
Link: https://lore.kernel.org/r/3ad2aa305f7396d41a40e3f054f740d464b16b7f.1706526029.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/lbr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index eb31f850841a8..4a1e600314d5d 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -173,9 +173,11 @@ void amd_pmu_lbr_read(void)
 
 		/*
 		 * Check if a branch has been logged; if valid = 0, spec = 0
-		 * then no branch was recorded
+		 * then no branch was recorded; if reserved = 1 then an
+		 * erroneous branch was recorded (see Erratum 1452)
 		 */
-		if (!entry.to.split.valid && !entry.to.split.spec)
+		if ((!entry.to.split.valid && !entry.to.split.spec) ||
+		    entry.to.split.reserved)
 			continue;
 
 		perf_clear_branch_entry_bitfields(br + out);
-- 
2.43.0



