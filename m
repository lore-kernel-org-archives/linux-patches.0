Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D4255F52;
	Mon, 23 Mar 2026 15:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278234; cv=none; b=AdsKfMz+w2MSU7pgAOlsb36CMsxnNSPA8Vz/pU0XTmpj7emkAlzmKvYPX4bJor0DLW6S3cZAEXvQMv8mV+BUQr3AzGOxYomuLb2O5aXlY2ZCvxalvNTjD5K6g5XB5NCRcHloGEPUjqKdwYHuN4ytpLiPNO6K7cF60V/Ddu/sqso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278234; c=relaxed/simple;
	bh=2gDugrjuEBfIaTnu/ke0rP76WCwVxSY8Fh1K95fDdOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDROzpNKA70r8hrH1lwwL2KYQSUJfShbp0TRVpDEum3AX/Nu1XstNe/Zc2pcuVPCiIx2Oa1fWTmjUElGhT9xGhd6pqyVPZGV2QRFt47C+sxAtZlX3NGr4CL9r5ioxl4RfZuanAsQLbmnMLeF7PlVTWtUCJ+mUX2vO6eD6Ua90qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxkK5jPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxkK5jPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAB8C4CEF7;
	Mon, 23 Mar 2026 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278234;
	bh=2gDugrjuEBfIaTnu/ke0rP76WCwVxSY8Fh1K95fDdOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxkK5jPSL7zA5E6H8Jtk7q6TGY8Pds65YByv2S9XSy98agBcMtRZAJ/09BNBDcHUu
	 HSnaB1YSB03G8Lf4Zcmm9882AhRRAhNxLkW7o3rwStHV1Pr7sI6acG7BwzK7u/FwQz
	 F+0DwyxxpLLae46Fn6fOpW0jIne17rx2iBhGCCK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/567] netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels
Date: Mon, 23 Mar 2026 14:42:44 +0100
Message-ID: <20260323134539.870315667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Tan <tanyuan98@outlook.com>

[ Upstream commit 329f0b9b48ee6ab59d1ab72fef55fe8c6463a6cf ]

IDLETIMER revision 0 rules reuse existing timers by label and always call
mod_timer() on timer->timer.

If the label was created first by revision 1 with XT_IDLETIMER_ALARM,
the object uses alarm timer semantics and timer->timer is never initialized.
Reusing that object from revision 0 causes mod_timer() on an uninitialized
timer_list, triggering debugobjects warnings and possible panic when
panic_on_warn=1.

Fix this by rejecting revision 0 rule insertion when an existing timer with
the same label is of ALARM type.

Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Co-developed-by: Yifan Wu <yifanwucs@gmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_IDLETIMER.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 9869ef3c2ab37..92a8289b1cb35 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -320,6 +320,12 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
+		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
+			mutex_unlock(&list_mutex);
+			return -EINVAL;
+		}
+
 		info->timer->refcnt++;
 		mod_timer(&info->timer->timer,
 			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
-- 
2.51.0



