Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904F33D522C;
	Wed,  8 Apr 2026 18:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674592; cv=none; b=k7lFMOKNEUw7ChwUGnwY/NpQLlB4oTHXGITsBWLaerTQB9TCl5QosSd5V51vnQ3UUCbOhWfTySj8AcDYJ5WndpjV1aFJ0BnjhpKDefiKgAzjeAsH6/LJtd13KUEW/DPEKZiMQBSocls/nezXn2sQyLqJ3HhThDrHZ+M/KdFHLAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674592; c=relaxed/simple;
	bh=xSMhfAPyXw2PdtMgF8dlwxLFdl1Qp/k43ipim1nG3sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQ3WDMgQ5Zkso+2Jgu32fHjAL46pHLttsyItErUfyNUfrMjI2pOGxCckNCCiGIfAXPpIkzph2Jpznycash3R8fjxr3Qc9U18d4kG8NWzBrj0W2jG1sWofcnT8+uhrCbRy+Q4pyB/oYfDpRnHySv0omtjBo6Z/DbgfylmjRSYv5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbvwfpmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbvwfpmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A29C19421;
	Wed,  8 Apr 2026 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674592;
	bh=xSMhfAPyXw2PdtMgF8dlwxLFdl1Qp/k43ipim1nG3sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbvwfpmPbVd8LfNDKtg6lb23WRn1U0tNMsz94sdi1iSofvQRviZBbUcQVoQBmqRd0
	 L1fYCLZ7zdwI9xjJa0o8G6+hDg8GVrHJkEoEjYHSJ53rfV2R/cWr3iif97b5PlxzPe
	 KK3Sqq4syY3slVGH7/wr8cICJFjX9mQau6lBpCa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 157/311] perf/x86: Fix potential bad container_of in intel_pmu_hw_config
Date: Wed,  8 Apr 2026 20:02:37 +0200
Message-ID: <20260408175945.268422821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit dbde07f06226438cd2cf1179745fa1bec5d8914a ]

Auto counter reload may have a group of events with software events
present within it. The software event PMU isn't the x86_hybrid_pmu and
a container_of operation in intel_pmu_set_acr_caused_constr (via the
hybrid helper) could cause out of bound memory reads. Avoid this by
guarding the call to intel_pmu_set_acr_caused_constr with an
is_x86_event check.

Fixes: ec980e4facef ("perf/x86/intel: Support auto counter reload")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Link: https://patch.msgid.link/20260312194305.1834035-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 20f078ceb51da..bebaac1dbaeb3 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4594,8 +4594,10 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		intel_pmu_set_acr_caused_constr(leader, idx++, cause_mask);
 
 		if (leader->nr_siblings) {
-			for_each_sibling_event(sibling, leader)
-				intel_pmu_set_acr_caused_constr(sibling, idx++, cause_mask);
+			for_each_sibling_event(sibling, leader) {
+				if (is_x86_event(sibling))
+					intel_pmu_set_acr_caused_constr(sibling, idx++, cause_mask);
+			}
 		}
 
 		if (leader != event)
-- 
2.53.0



