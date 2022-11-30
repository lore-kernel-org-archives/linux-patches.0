Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F311C433C1;
	Wed, 30 Nov 2022 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833192;
	bh=8nTnG9hu8oT2NRcUp/J54lLllLrNZvDdpuy/MhuIf/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRvojP8FdOMWzUsUs9+5hByeh/Ygq2yGA8iJPDR60oe4K9aorz9m96Nlw396TWoaU
	 8b8rh2eFVVGfluVBzJS8rP1X1qnR5x/dyJwj1B2uB6ZA/vrqKu/1hG/Qk3ppKjyGR3
	 v+y6ibghi1Cm0DnTxnzKQj67LlTtxK8AgPScyb10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Chen <chenzhen126@huawei.com>,
	Caowangbao <caowangbao@huawei.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/206] sctp: clear out_curr if all frag chunks of current msg are pruned
Date: Wed, 30 Nov 2022 19:20:59 +0100
Message-Id: <20221130180533.177426918@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2f201ae14ae0f91dbf1cffea7bb1e29e81d4d108 ]

A crash was reported by Zhen Chen:

  list_del corruption, ffffa035ddf01c18->next is NULL
  WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49 __list_del_entry_valid+0x59/0xe0
  RIP: 0010:__list_del_entry_valid+0x59/0xe0
  Call Trace:
   sctp_sched_dequeue_common+0x17/0x70 [sctp]
   sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
   sctp_outq_flush_data+0x85/0x360 [sctp]
   sctp_outq_uncork+0x77/0xa0 [sctp]
   sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
   sctp_side_effects+0x37/0xe0 [sctp]
   sctp_do_sm+0xd0/0x230 [sctp]
   sctp_primitive_SEND+0x2f/0x40 [sctp]
   sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
   sctp_sendmsg+0x3d5/0x440 [sctp]
   sock_sendmsg+0x5b/0x70

and in sctp_sched_fcfs_dequeue() it dequeued a chunk from stream
out_curr outq while this outq was empty.

Normally stream->out_curr must be set to NULL once all frag chunks of
current msg are dequeued, as we can see in sctp_sched_dequeue_done().
However, in sctp_prsctp_prune_unsent() as it is not a proper dequeue,
sctp_sched_dequeue_done() is not called to do this.

This patch is to fix it by simply setting out_curr to NULL when the
last frag chunk of current msg is dequeued from out_curr stream in
sctp_prsctp_prune_unsent().

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Zhen Chen <chenzhen126@huawei.com>
Tested-by: Caowangbao <caowangbao@huawei.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/outqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 6fcc4ff97f94..dc29ac0f8d3f 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -403,6 +403,11 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
+		/* clear out_curr if all frag chunks are pruned */
+		if (asoc->stream.out_curr == sout &&
+		    list_is_last(&chk->frag_list, &chk->msg->chunks))
+			asoc->stream.out_curr = NULL;
+
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
 		if (msg_len <= 0)
-- 
2.35.1



