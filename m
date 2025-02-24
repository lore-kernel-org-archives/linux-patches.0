Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836C42A8D0;
	Mon, 24 Feb 2025 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408004; cv=none; b=udZzizUczKs/QS4g5JkiGUF8WmBLf9jk1W5RrYrHf47N7NMn1Xml3hbtvAJ22XBmmK7a0pNVE3PkbUVijF0/tdKgLU2HyMyNRPsWAn2tz/d4hUFKiMoiXFJdbNSJWF7og5A2Y1UKV2q9u0+NzgA/xzNQRcRevgntmKrzpt2C0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408004; c=relaxed/simple;
	bh=lpUMDqkt/DAdGXzEz6TdVmgZvWOSmVnq2PKSxIWT5sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mosxJxqJ2eKWVax6hV4T2OQcC0HXykf/y4iUPDhRSoEDdv2gdA6mxnchUvjU1Eq8fd2Cwxi4HfAT83KoJcKdsulE7sHHAZrOinq7Wl8GL3S/nTek2U7vIewO0/Tjp9bU9DnWvq6JUuzoiq/ZlVTqG+0S1e7lVgquiku9M9ao0YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suX9q+41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suX9q+41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3194C4CED6;
	Mon, 24 Feb 2025 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408004;
	bh=lpUMDqkt/DAdGXzEz6TdVmgZvWOSmVnq2PKSxIWT5sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suX9q+41+6qk1tgTRRaLzTONsLF8/3bdSecm+dt95kdaeq5zxtG38u0ceyrclNx5l
	 D/uP1ryJgBqMwc8q12voBpjRJHoCgYSXceq21YQ0uwJ6NJEJ2OjeSTJgf6JzMZhPLB
	 rGTi1E9+ByAiibYBlLOnn6j6yMdZOJPuaWHxVheQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Riteau <pierre@stackhpc.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/140] net/sched: cls_api: fix error handling causing NULL dereference
Date: Mon, 24 Feb 2025 15:34:31 +0100
Message-ID: <20250224142605.837029870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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
index 84e18b5f72a30..96c39e9a873c7 100644
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



