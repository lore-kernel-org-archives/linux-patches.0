Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D31339BE;
	Fri, 24 Nov 2023 19:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+dGBKk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCE4C433C7;
	Fri, 24 Nov 2023 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853302;
	bh=bGvP/U6DFO3TV8Yr1orVIvnmKXzTRlE7B+Q6vPMuVjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+dGBKk7AMghYwktQHPqEGqrjiRcM+gWw0mAsUWkED9LLsJShZ1JNMj2a+cFVYnLw
	 lODBxLWTuraoDS5i6POdUL85Aa63smtoxgk158NdF9O31CYI+ZWWRfH6l0sg9G+w7Z
	 bvXiY01bTvT4gGpoX6y/wOmXnB3D+L1BLWqqntlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/297] tools/power/turbostat: Fix a knl bug
Date: Fri, 24 Nov 2023 17:52:57 +0000
Message-ID: <20231124172005.006297559@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 137f01b3529d292a68d22e9681e2f903c768f790 ]

MSR_KNL_CORE_C6_RESIDENCY should be evaluated only if
1. this is KNL platform
AND
2. need to get C6 residency or need to calculate C1 residency

Fix the broken logic introduced by commit 1e9042b9c8d4 ("tools/power
turbostat: Fix CPU%C1 display value").

Fixes: 1e9042b9c8d4 ("tools/power turbostat: Fix CPU%C1 display value")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index a3197efe52c63..045d0db88755f 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2100,7 +2100,7 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 	if ((DO_BIC(BIC_CPU_c6) || soft_c1_residency_display(BIC_CPU_c6)) && !do_knl_cstates) {
 		if (get_msr(cpu, MSR_CORE_C6_RESIDENCY, &c->c6))
 			return -7;
-	} else if (do_knl_cstates || soft_c1_residency_display(BIC_CPU_c6)) {
+	} else if (do_knl_cstates && soft_c1_residency_display(BIC_CPU_c6)) {
 		if (get_msr(cpu, MSR_KNL_CORE_C6_RESIDENCY, &c->c6))
 			return -7;
 	}
-- 
2.42.0



