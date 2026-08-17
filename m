Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C90439F71;
	Mon, 17 Aug 2026 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978432; cv=none; b=toZbvjAccaZ9aXczUAaFZuPKlBksFTo1x3pD6c6Z3JS7tFzbl5dJPPsXVuDEmJBnbBpYlUfNlssDsjUPd2rqgyQdfgiqjbnpnyboAPubgEFjgUr7ooRDJeWl3vkjhCtrN/malPpuUygbxGXviIH7dfcg6papQz6vTrUscvMV0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978432; c=relaxed/simple;
	bh=seqLmLXKg4pVTZwb7H15zaM1oeYg7lW7Y+OSO2FIGjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nb2OsnRXiDjga/4009ZuU0zrTMCTSBZo5U1yjgKTqN8eJ1OX5VvS1uLJCGTSwxEe+6Ig53/SDNsozq9TRNQK50w11I+ee1nC8slBqDs+whMPvfG8fV4Hl6lHgYgeKpb8Q6wuaz1AIzWBhdeMT4HRRUyFKCI1jvrJNOR0+MDbIL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRZT5sWm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRZT5sWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7BF1F000E9;
	Mon, 17 Aug 2026 14:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978430;
	bh=07b+EsgVfudgfRruiZ8BnpznliVnVlmEy+OK4FOTX0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRZT5sWmzGG3YeoEsSugWvU5x63L+ZaKCiNY/Wl14ofmY5gr8W557PxF6VppUzu7K
	 0xGj/e8I6sifdnp3Q6KsL0J0Nuu0CkWVencpMW9jEg6/Bh2cfCeHJXjzGnruoSfepx
	 zhaG+RqoZ1gRjUdMaex1SxJowF8essh8ohoaQLaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/156] net: sched: cls_api: add skip_sw counter
Date: Mon, 17 Aug 2026 15:32:47 +0200
Message-ID: <20260817132535.917434177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit f631ef39d81956a2ee69d25039781ceae1162f62 ]

Maintain a count of skip_sw filters.

This counter is protected by the cb_lock, and is updated
at the same time as offloadcnt.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a347304b2ca1 ("net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 +
 net/sched/cls_api.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 385af747b0b4e..5df841ed0aeaa 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -477,6 +477,7 @@ struct tcf_block {
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
+	atomic_t skipswcnt; /* Number of skip_sw filters */
 	atomic_t offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
 	unsigned int lockeddevcnt; /* Number of devs that require rtnl lock. */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e259ec6ed145d..792e7040ebc1f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3478,6 +3478,8 @@ static void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
 	if (*flags & TCA_CLS_FLAGS_IN_HW)
 		return;
 	*flags |= TCA_CLS_FLAGS_IN_HW;
+	if (tc_skip_sw(*flags))
+		atomic_inc(&block->skipswcnt);
 	atomic_inc(&block->offloadcnt);
 }
 
@@ -3486,6 +3488,8 @@ static void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
 	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
 		return;
 	*flags &= ~TCA_CLS_FLAGS_IN_HW;
+	if (tc_skip_sw(*flags))
+		atomic_dec(&block->skipswcnt);
 	atomic_dec(&block->offloadcnt);
 }
 
-- 
2.53.0



