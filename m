Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2A519DF99;
	Wed, 19 Mar 2025 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394834; cv=none; b=fO/xvToX3DDGTzWsiHM+iADOPw1QMw703EaGAP3UTtbRy1ucgKZr0WaqjMThgAK85kzLy3DMGxJZygSKXfUGQsIL21EMzFAjqEDMJU3dEZ+vgP/svWbjvmZRw2Y0d5Zm1HV6bycRhyl7MeQ1EbNf/23hQsN3JrpA03z2uvSMDgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394834; c=relaxed/simple;
	bh=zQ1XwM+VNq9eqpCeqUcJSJKRpVoCL6POWphDq8xIpME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqTtlDFl2rgzKrOESaRLfeCZaVFm0BwoK69E6GPHU8pGZRFkDT6lKqDTyPmBT5n2KUoB3ny3tsmymraCS9qrft7FV2bLUQB7YbsOrr2TBDG2lxBPvGULPy8T6pe4YjkmRK/oU7ti/krBsBDzMoFB3hdIZ9/GDX5hgbO/J2nppA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgCD6H9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgCD6H9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03F0C4CEE9;
	Wed, 19 Mar 2025 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394834;
	bh=zQ1XwM+VNq9eqpCeqUcJSJKRpVoCL6POWphDq8xIpME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgCD6H9LK8ao4eZplHBVkXkbs6JD/7WfTlUDtUXu9eJQeVUOwrHYy5reDqNOtwhhE
	 17StHRvhavG+3UORQyWABxCx0U8qyicUuWI9zHnfqC6EDdJ10sHTYCG2IyrBfvxOKH
	 7jJw/Tp6Zn7m0jg9CKtSOo5qXSN3iC2YeyNV4UR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yang <juny24602@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 014/241] sched: address a potential NULL pointer dereference in the GRED scheduler.
Date: Wed, 19 Mar 2025 07:28:04 -0700
Message-ID: <20250319143028.061830507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Jun Yang <juny24602@gmail.com>

[ Upstream commit 115ef44a98220fddfab37a39a19370497cd718b9 ]

If kzalloc in gred_init returns a NULL pointer, the code follows the
error handling path, invoking gred_destroy. This, in turn, calls
gred_offload, where memset could receive a NULL pointer as input,
potentially leading to a kernel crash.

When table->opt is NULL in gred_init(), gred_change_table_def()
is not called yet, so it is not necessary to call ->ndo_setup_tc()
in gred_offload().

Signed-off-by: Jun Yang <juny24602@gmail.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Fixes: f25c0515c521 ("net: sched: gred: dynamically allocate tc_gred_qopt_offload")
Link: https://patch.msgid.link/20250305154410.3505642-1-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_gred.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 7d2151c62c4a1..85a32b3f6585e 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -913,7 +913,8 @@ static void gred_destroy(struct Qdisc *sch)
 	for (i = 0; i < table->DPs; i++)
 		gred_destroy_vq(table->tab[i]);
 
-	gred_offload(sch, TC_GRED_DESTROY);
+	if (table->opt)
+		gred_offload(sch, TC_GRED_DESTROY);
 	kfree(table->opt);
 }
 
-- 
2.39.5



