Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208485;
	b=qlMmUcTknaKNzlZgARBlcRL7lABRHE2C35ABWGHQ+T1ZpoK16+xig8XUV+e3LAm3GV75
	 y3qJwOPyOlfNcI6113Mep8Bg5SFJ2AEVymoweukmQTvaWynZwdrOvhknhnTxalPNwUFnh
	 /1KN/rz6iR+IByiaCU9FdknCTCXlJkYcGCJumVxJuDVVtvoBlzm3ed8063k4ZX2PFKN+9
	 2NRJvTeki+Yir3V9esvqIvpI0h7SmNhECXqAE1aGWjOP5N8nZC9oTNfOe8M4pvI4JrE2w
	 Vhd0jhe5l5tBE+FAkcTsHScaU7t9PLjJpVDgnE1RHiXGOSYbrjHWem60ytLBM4WXdIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kFvIHgG/wKEvjF1o7DgJnEDVfrMcQWkUfQ8hK4w4Os0=;
	b=tjfA+1+Bo9WUx9Lq6fQew7MbY8ss4l6fpe+J6FMz0w44iOyRPJnpznM0r8XL8F/Eqm1T
	 PevQF5eNzjG1cmm8NnYqyiwtb15U9CqRNSeDY0BKZapKo3vybvHSN+eA/mADS77PQxSa+
	 1msP4j67Z61+1vneP52GcJHZEHNopyLivi6Zt6JvuGC+DMiLKkjxX6OOGwIki8LJdtY4y
	 63yMprxDxL4u1tjo7E3bKePZJSiWobQpa0frUtMQkBja4l27PR889+teMJUkHgmj43+Hk
	 SwZG0TjNG4khnb5sueHfmzO9dQML73rvdbknlhCbd4StdwiR1l56P7RlKWfpiMsCNkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vs+qvCKa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098F606A31C;
	Wed, 28 Oct 2026 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vs+qvCKa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE5F1F01825;
	Wed, 28 Oct 2026 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208485;
	bh=kFvIHgG/wKEvjF1o7DgJnEDVfrMcQWkUfQ8hK4w4Os0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vs+qvCKaYEvI18NlgpZfYmY5CWEykQbAoCB7ELmxDfLMDkGO6NiC/wjMwMwfpHp+c
	 K0cHGIynrdmYncAnADQTwmD6OyYkw7KPSgvrVlN/J2oVheHZXJ3cPDKvDagodRXIRY
	 wme94yviWn7mYsS/qAp9zWqeH6dxgqVbFsW0B0/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/516] net/sched: act_api: release all action references on NEWACTION failure
Date: Wed, 28 Oct 2026 17:54:11 +0100
Message-ID: <20261028170005.867363491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 478eb5abb51931a152abab068f8a717b7ff480fd ]

When a batched RTM_NEWACTION request replaces an existing action,
tcf_idr_check_alloc() takes a temporary reference on it. If a later
action fails to initialize, tcf_action_destroy() uses strict release
semantics to clean up the actions initialized so far. For an action
bound to a filter, the strict check returns -EPERM without dropping
the temporary reference.

This error also makes tcf_action_destroy() return before releasing
subsequent entries. Any new action initialized between the bound
action and the failing entry is leaked together with its reserved
IDR slot, preventing reuse of its index.

Use tcf_idr_release() to drop each reference held by the batch without
rejecting bound actions. This allows cleanup to continue through all
initialized entries and preserves the module reference release when
an action is destroyed. Explicit action deletion and flushing retain
their separate bind-count checks.

Fixes: 55334a5db5cd ("net_sched: act: refuse to remove bound action outside")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260909070336.32979-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 4bdfac2f80824..71b33a2716e27 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -759,19 +759,14 @@ EXPORT_SYMBOL(tcf_action_exec);
 
 int tcf_action_destroy(struct tc_action *actions[], int bind)
 {
-	const struct tc_action_ops *ops;
 	struct tc_action *a;
 	int ret = 0, i;
 
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
 		actions[i] = NULL;
-		ops = a->ops;
-		ret = __tcf_idr_release(a, bind, true);
-		if (ret == ACT_P_DELETED)
-			module_put(ops->owner);
-		else if (ret < 0)
-			return ret;
+		/* Drop our reference even if the action is still bound to a filter. */
+		ret = tcf_idr_release(a, bind);
 	}
 	return ret;
 }
-- 
2.53.0



