Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C48714012;
	Mon, 24 Feb 2025 14:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408983; cv=none; b=pLlBwzrsPW20Z79vksN+hDt4tBLEpjmWrp6vDp95tu3Bf2sKQzv8YpCOZdXqGZv3/6mUnO/U3HEOapKz4Cr/Wes2KziCt1HN/ssCcPvzl1aqA53hk4y2wnsF6DMR+AQag9RRUVTDaHZdOpPDBqr7Z2fc3jdJeqwl0K/esKGWJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408983; c=relaxed/simple;
	bh=Q6X8vAUM6G3VjVvsph51Pqt2XF3iTqTJSP33jkt0R7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOHnwY6bESm2mWxg7TFH7EBwdev9hoIdwhOzrFSL/vM80izlCB7/dqbFqn/hiah2vMLfERg6lT06/+wOpHWUzt5XCjIz0T010WV8dxka0FnpxPjAsy43lWti8XQdlKn/SctBkPaeuFfRpOy9pHYVdV5qzMQOUcJcWFJYc52SfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCElGciH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCElGciH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440AEC4CEE8;
	Mon, 24 Feb 2025 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408982;
	bh=Q6X8vAUM6G3VjVvsph51Pqt2XF3iTqTJSP33jkt0R7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCElGciHZ2C4Ug/8MxrrzqgrC1CyTBBb/rZ33bNq08cd8ptl9mP2scvh09K82/ukz
	 nRVLDkOgb7pceSsf++/91SDD3oQPPOiCE9oNU50wTUSwB/Yiol08Yu4mpEP2Wy6rZM
	 dUfp9XCrrY9DzAWZyOXoF87tI1AzB4TBMZK/vzek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Riteau <pierre@stackhpc.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/138] net/sched: cls_api: fix error handling causing NULL dereference
Date: Mon, 24 Feb 2025 15:34:20 +0100
Message-ID: <20250224142605.653436588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8e47e5355be61..4f648af8cfaaf 100644
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



