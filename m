Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A73123BD1D;
	Mon, 24 Feb 2025 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408568; cv=none; b=pODHu5OGTTPKWObNTevr4TvfTctF0ET4lU5099uwxHMCfMcn7r/uZJTM7RMHhVgEMg3Y7xa7TVBv6CaKh3aXLIt5R88IOa9x/m18nlq0K5DzM44PMvhewI2akYTL3brBYAJIi/GLumTPiGgbWxIVP3OHeGwjrqEBdE+GXsYWaCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408568; c=relaxed/simple;
	bh=t78vH593wOMIUWY0/hB+GDmchf+c63sB4Wh1KNAu1/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5qLMfRVW/Rm/uExHhSLBuxm13Za+p61PVqzDsS4O+sfrHuBYJBUIa+bmI/tEjd0hQY0TwOk0DNzXx+gS31lpOFo2oitdDxwRCEfkBiv2B8HXZcZwkIJUdB57d8MglEe43v+4K85DNczKIXf2iq4Udn1Qf38MWRSOgfjoxjx7Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkH5EtEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkH5EtEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37F1C4CED6;
	Mon, 24 Feb 2025 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408568;
	bh=t78vH593wOMIUWY0/hB+GDmchf+c63sB4Wh1KNAu1/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkH5EtEm2QV19GXv4u/lAsL6dsCU1xiDYFEwvK1V9RU7NSMJL4wh25Z2QoRRO3j0d
	 Gakp2QnT5u6jYPS5fEGYr6TKd8RV4Z6E198i0JKkk0sf9KlBhtoS6wCdDLXSZfz0Jb
	 0ND3rh5BRaIZLb2V5Txv+ZGsMSXH4LIKlRXy3Mhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Riteau <pierre@stackhpc.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/154] net/sched: cls_api: fix error handling causing NULL dereference
Date: Mon, 24 Feb 2025 15:34:13 +0100
Message-ID: <20250224142609.206347293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Riteau <pierre@stackhpc.com>

[ Upstream commit 071ed42cff4fcdd89025d966d48eabef59913bf2 ]

tcf_exts_miss_cookie_base_alloc() calls xa_alloc_cyclic() which can
return 1 if the allocation succeeded after wrapping. This was treated as
an error, with value 1 returned to caller tcf_exts_init_ex() which sets
exts->actions to NULL and returns 1 to caller fl_change().

fl_change() treats err == 1 as success, calling tcf_exts_validate_ex()
which calls tcf_action_init() with exts->actions as argument, where it
is dereferenced.

Example trace:

BUG: kernel NULL pointer dereference, address: 0000000000000000
CPU: 114 PID: 16151 Comm: handler114 Kdump: loaded Not tainted 5.14.0-503.16.1.el9_5.x86_64 #1
RIP: 0010:tcf_action_init+0x1f8/0x2c0
Call Trace:
 tcf_action_init+0x1f8/0x2c0
 tcf_exts_validate_ex+0x175/0x190
 fl_change+0x537/0x1120 [cls_flower]

Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
Signed-off-by: Pierre Riteau <pierre@stackhpc.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250213223610.320278-1-pierre@stackhpc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index dfa3067084948..998ea3b5badfc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -97,7 +97,7 @@ tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
 
 	err = xa_alloc_cyclic(&tcf_exts_miss_cookies_xa, &n->miss_cookie_base,
 			      n, xa_limit_32b, &next, GFP_KERNEL);
-	if (err)
+	if (err < 0)
 		goto err_xa_alloc;
 
 	exts->miss_cookie_node = n;
-- 
2.39.5



