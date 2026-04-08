Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5519B3B0AFC;
	Wed,  8 Apr 2026 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673717; cv=none; b=cVEE5GkA4KOkFdcK5TLh82jnxlGuPe0HA+SrOuzd/mKa0Vmp769UNNyRkbhEhvB9MiUBvBCNZhHBZKZb9mOLrojOHybuCEjid3DbyMmuLBJ3LVQxr7MxrPcS5aSZ7oYuxpoSh6jTbYJbW/9Vx3Oar30DQ9gJVboPcQEqavFUtbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673717; c=relaxed/simple;
	bh=6JQn+xWZpb/sGKdUV8Q2jcxQakbnKQ1JEvCC0zhLP/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMOKKO5rnbiDXSMBl5wNfPXz85KKs3/J3+c6irsxtl03PGWxZ2e4dgt7ISlks4M7ZbXYdXPE4PT5N4OOaP5AwHaY/DojTqFjKyiicDsd7lzq9DvRa/KyL/BKXs0hIT2w2ASPW3L/AMaqDHofcnEdxzoNbXOrfIJeQ+1mUj5/zvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bogaxcLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bogaxcLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEF7C19425;
	Wed,  8 Apr 2026 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673717;
	bh=6JQn+xWZpb/sGKdUV8Q2jcxQakbnKQ1JEvCC0zhLP/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bogaxcLKO2ZB3MwDQAqYQzAl18YtrBuI3gXDmOyyFmW4bxgyPzYH5Ja9BV312wiR3
	 1EF51VOch68GUrv8pIA1Q+ltX8TYoMMuBZbNu9FYbQF4HnG4TYhMDP/zYa5U8E6aBT
	 y+JXjJF4o8ImWgaly2J2n7yF0vbc3yJdZucoO8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/242] net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak
Date: Wed,  8 Apr 2026 20:01:42 +0200
Message-ID: <20260408175929.402001600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
index d301d0ea2d315..24c1d0480bc54 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2958,6 +2958,7 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 	tcm->tcm__pad1 = 0;
 	tcm->tcm__pad2 = 0;
 	tcm->tcm_handle = 0;
+	tcm->tcm_info = 0;
 	if (block->q) {
 		tcm->tcm_ifindex = qdisc_dev(block->q)->ifindex;
 		tcm->tcm_parent = block->q->handle;
-- 
2.53.0



