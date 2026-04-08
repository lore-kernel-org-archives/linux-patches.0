Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FFA347503;
	Wed,  8 Apr 2026 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672090; cv=none; b=bhKbai+vSczMmiCff/FR9Jn/nEM+iCpuxb7odPNur7hPi8NSDzaAufXCrSv/zYZAAyQ38Y79nkS42Kg0Xe44pCp3tg4h5FJkNaOrI0LOVdeslhgZAeytL5Kiscu0CXMQqTCWNiaKJgJI+B4Bnn/85pxJ85kD34/2tgsXrSyak4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672090; c=relaxed/simple;
	bh=mZUZBZ7zq6XHd4rmNXn4dk6GHIZKzCf6IwEfl2IVipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyRgSz9y6+RbBZcb8y3c3yOperKNPU76nQGOYXQCJa21ajnEBby5c+1REaj89tyCwwtVyDCC+rLiU6cZzmQjeGHbNfrd4naJg0hWCHeO/gjxE9UE9Qd3MbXQmsW756PFEvkXZZg6WXP3GGDyPdIVTtFOcloDATBAHXCTkle+xac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0p/5juY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0p/5juY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19B5C19421;
	Wed,  8 Apr 2026 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672090;
	bh=mZUZBZ7zq6XHd4rmNXn4dk6GHIZKzCf6IwEfl2IVipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0p/5juYmL63hy2tIXXQ2ESXwR71oEM8VnNblFLrWijMiCjyicmRzh/qqEFGrvUYD
	 bPVL93n12AgXpNky9n9uyBBHGuHKLgXgsXhNYGSgNejvfFcOqTtvSl2h+jvUCbRpBp
	 Ldi1MR53RciFHJj065nMw6fHGDub39iKA1kl4wxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/312] net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak
Date: Wed,  8 Apr 2026 20:01:15 +0200
Message-ID: <20260408175939.667120409@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yochai Eisenrich <echelonh@gmail.com>

[ Upstream commit e6e3eb5ee89ac4c163d46429391c889a1bb5e404 ]

When building netlink messages, tc_chain_fill_node() never initializes
the tcm_info field of struct tcmsg. Since the allocation is not zeroed,
kernel heap memory is leaked to userspace through this 4-byte field.

The fix simply zeroes tcm_info alongside the other fields that are
already initialized.

Fixes: 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260328211436.1010152-1-echelonh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e5d4e64ce479c..0ccd8bf57a93b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2726,6 +2726,7 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 	tcm->tcm__pad1 = 0;
 	tcm->tcm__pad2 = 0;
 	tcm->tcm_handle = 0;
+	tcm->tcm_info = 0;
 	if (block->q) {
 		tcm->tcm_ifindex = qdisc_dev(block->q)->ifindex;
 		tcm->tcm_parent = block->q->handle;
-- 
2.53.0



