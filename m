Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793C91C1AAA;
	Tue, 12 Aug 2025 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025534; cv=none; b=PVTopK0tEEktROi+5OW2RCfrCHM+4dI3VaOZMIWqJ1AvW6QZ8iOPTIBpNQlQUGjVC4c19aDvDA+KcjryNuJgfGu0EDGIW55T4B9YQP3obr+dIj3puUMPla8oCwH3ZGowI+8pavI2JC1dC8E4qVQHStIAR2LffsbSEHlSCCuT/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025534; c=relaxed/simple;
	bh=lA8HPZMYqFwxGiCjHxeUI5kmv1Wu/CKrxaemqCYfAtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lA1u81JWRpMVVooEToCSshz2T5qqcrJFBI6iOW7htNet+uhjM+d7gF2c3/j2G1P4ugRWlYF83M6c8OBFTNqjPo9pFPOTYFkpSAVgKzvF5YAbK4doudMS6Cbwh4o2F0CjF2sbuT1qhIMGM7kg0NQEO7aLP1b+/FMsY0u56plLNV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaNuzbBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaNuzbBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1800C4CEF0;
	Tue, 12 Aug 2025 19:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025534;
	bh=lA8HPZMYqFwxGiCjHxeUI5kmv1Wu/CKrxaemqCYfAtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaNuzbBBLvLVyyZR58uKnMviOJv1wr3tjPp+KK2xSDx8q/BRgX0PlXW8lilhX6dw6
	 JNn7+P8C/XGdNmeNiiJVBvme2JM+snjMcQ1nTBkgZ9z0CjpANgEhLpy7SkUbmXZrQP
	 /aMCXMDW32hwSFB74F1MtnXSTmyLgWD1yqf/7zb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivan Zohar-Kotzer <sivany32@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 069/480] powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()
Date: Tue, 12 Aug 2025 19:44:37 +0200
Message-ID: <20250812174400.267871902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sivan Zohar-Kotzer <sivany32@gmail.com>

[ Upstream commit 46dc57406887dd02565cb264224194a6776d882b ]

The get_pd_power_uw() function can crash with a NULL pointer dereference
when em_cpu_get() returns NULL. This occurs when a CPU becomes impossible
during runtime, causing get_cpu_device() to return NULL, which propagates
through em_cpu_get() and leads to a crash when em_span_cpus() dereferences
the NULL pointer.

Add a NULL check after em_cpu_get() and return 0 if unavailable,
matching the existing fallback behavior in __dtpm_cpu_setup().

Fixes: eb82bace8931 ("powercap/drivers/dtpm: Scale the power with the load")
Signed-off-by: Sivan Zohar-Kotzer <sivany32@gmail.com>
Link: https://patch.msgid.link/20250701221355.96916-1-sivany32@gmail.com
[ rjw: Drop an excess empty code line ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/dtpm_cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/powercap/dtpm_cpu.c b/drivers/powercap/dtpm_cpu.c
index 6b6f51b21550..99390ec1481f 100644
--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -96,6 +96,8 @@ static u64 get_pd_power_uw(struct dtpm *dtpm)
 	int i;
 
 	pd = em_cpu_get(dtpm_cpu->cpu);
+	if (!pd)
+		return 0;
 
 	pd_mask = em_span_cpus(pd);
 
-- 
2.39.5



