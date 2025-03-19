Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B801DEFD9;
	Wed, 19 Mar 2025 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395005; cv=none; b=hPbDd+248LgGI3VENNYumPC7lvd7gzjN/g5oOyQq3EIOWEpdJ4x89Qpp434OUtJaDKqS63yYAXNwJif7VUWV5fioBf9tm7pRhHxsFcBUowhX9Uc7a1aLXWBhw5+n0G4c38On33IUaARYFxGa+XZsTkkOuOJ/v4r9o+gP2OpsGr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395005; c=relaxed/simple;
	bh=N+bC1fGgrN6ZGlDL5L3q1CejtNUy3B1k/81ozsDpFJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa/aipIhCwffdz41R5W11epyfeLUlBCm1FMk+N2sZIF2AGv+b6cyC3qGXVEWIi/jUiYR5tzbjQzQeUdsn6lwx+2q5T75zbvAo9YceVppOsgvXRGMY4izhZ0ssK39wn7WTm5C0WlnhhUgYOQBnqmo0b9WyPMmUQDZCHwdExvf2v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a76uJig/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a76uJig/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A62C4CEE4;
	Wed, 19 Mar 2025 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395004;
	bh=N+bC1fGgrN6ZGlDL5L3q1CejtNUy3B1k/81ozsDpFJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a76uJig/IZPprtlSxoxihtRswM5bPWuKVl3l/4vKoXon/d4qbDdZwRw2ph5uVT/+o
	 ra1X5Dsl6EeL8is5Rj7f9tDZ4C3urSjSapkcpeQSWLOWFrtPXyjXnoqmgBqByJZKAO
	 N1s9vGMDCZ5UvwsVrUGP/h29rEuLnadt/XciKPWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yang <juny24602@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/231] sched: address a potential NULL pointer dereference in the GRED scheduler.
Date: Wed, 19 Mar 2025 07:28:26 -0700
Message-ID: <20250319143027.184210693@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index 79ba9dc702541..43b0343a7cd0c 100644
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



