Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE69321D591;
	Wed, 19 Mar 2025 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395164; cv=none; b=bLQiEohEx5EvYfTMhQWBWqUBJ6VPEAf+jYLQySrRTgiEk4sJZ5fQbw5Oc4axiRhY8CA44KrbvHNlW/9iT+KEvhoivXFEkVssu9gcKIChl9gi2O2DZRXbz3squeLaOBm+Ew3JXilUlBP+/cNUfQJ9pmSrhPyB9RN21jzKPTMi0f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395164; c=relaxed/simple;
	bh=6h3BxvAEXMRoSnw8FsaVhnAYu48EZidEUtLmZPtHKhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd3BCUtiY88cIu/XL4wZOx322Znzd9ikFmkTmp4UNMesl7mQa5a0wY2utG5BW5uvFtEWXp8Ii2qUyMTgyMH24OVpoqgfdpmYnG0HcRF5v8ei1VMObw+ywcnMjcJVy1KfdbzZRueIUubjVvg/H7Xqzl1ZTVlDaASLpOqvJwQDQMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPUy7MGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPUy7MGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5033C4CEE4;
	Wed, 19 Mar 2025 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395164;
	bh=6h3BxvAEXMRoSnw8FsaVhnAYu48EZidEUtLmZPtHKhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPUy7MGonHIq3GtS/lwVm/YeLsNjlhSTJLEFhbQeFnf7K9sB4mbmRw8DgCup7lAyb
	 DJj/hPPWiZ4bda32iDRXxevPFvllt2CS3GbpUCwegYeMWSgkCTuh7sYIEFCCvWu2QN
	 caqrHTwpU9NNFm9FZwZZEQTRgqMm0jiX2cjscKg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yang <juny24602@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/166] sched: address a potential NULL pointer dereference in the GRED scheduler.
Date: Wed, 19 Mar 2025 07:29:44 -0700
Message-ID: <20250319143020.344010493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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
index 872d127c9db42..fa7a1b69c0f35 100644
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



