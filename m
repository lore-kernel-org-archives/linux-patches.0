Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B92343D2;
	Mon, 23 Mar 2026 14:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275349; cv=none; b=SjrMR8tZbTIxmq208C4sZXVs5az7vRBTHykdxTK7zGs5ez/frG5H2TH/qQSxMImc+3LpmTZlCHY4r+jyhxLW9tAvc2BZpcKahKctXOuXRBlFjG48rR2JKhYUmp56hBppg3DL3NCBNSAC3d2kab6HiL8iMGOmX52pPZYi8JkbJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275349; c=relaxed/simple;
	bh=v4Ml8UJYqJdDg/yu6NNjQQPF1N39Q6FKIX/KKwnxe/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b78VnwIjg8Ql2rUV1jsEkJLCGRLQHtelEUqxC5UDASmlxjaRrO/RQ1QAYwc2y/7NhuDczr/Jx0DJJLXopBqo0xPqzeBer49H/+51k7+9+VWmBUuySuBhOFgPe5UdBwEQBQ+iR+AjgrTIdFRZCab7HMFpkIkIj+9hoSUmpMHoQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEMYwrxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEMYwrxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02294C4CEF7;
	Mon, 23 Mar 2026 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275349;
	bh=v4Ml8UJYqJdDg/yu6NNjQQPF1N39Q6FKIX/KKwnxe/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEMYwrxC0u8E/KuVks1Aufve84JURWGfn34MHzgtpE4XAtFr4RUi0lJ0zF35nu4ck
	 6Ef3mj4bdBNVUZ8gbEjHFK7JIlGC82DNcb1H7vtZXTuETFOpiZcHJENemBCOd47X0m
	 cXY0P08UIxwjpO2YwPTUmJ+7tXDPRUeSWoiweBmo=
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
Subject: [PATCH 6.12 067/460] netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels
Date: Mon, 23 Mar 2026 14:41:03 +0100
Message-ID: <20260323134528.348815625@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



