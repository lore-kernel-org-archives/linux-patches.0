Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079C079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D431C433D6;
	Wed, 30 Nov 2022 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833189;
	bh=hL2bfwoxDhEngUNaznYHMVht1omGZX8sAPnwKju+iyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efp8KF8kf82d9bXVdIiXcD7eMXRET9agUG6Y6mI2MSnZTc/UL8MdNnKVtDYUS5nfc
	 wktIJQrQXpFeqBOFDxVzNQVXrsGDShaRQAx7y7pG1bGnl+ogbxroXzUZtnSyBYUffu
	 67vF2OmVSli9/x4d/x7JdsgYbtIoRv54n+o2C7/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/206] sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
Date: Wed, 30 Nov 2022 19:20:58 +0100
Message-Id: <20221130180533.151238905@linuxfoundation.org>
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

[ Upstream commit 9f0b773210c27a8f5d98ddb2fc4ba60a42a3285f ]

Since commit 5bbbbe32a431 ("sctp: introduce stream scheduler foundations"),
sctp_stream_outq_migrate() has been called in sctp_stream_init/update to
removes those chunks to streams higher than the new max. There is no longer
need to do such check in sctp_prsctp_prune_unsent().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2f201ae14ae0 ("sctp: clear out_curr if all frag chunks of current msg are pruned")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/outqueue.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index b3950963fc8f..6fcc4ff97f94 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 {
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
+	struct sctp_stream_out *sout;
 
 	q->sched->unsched_all(&asoc->stream);
 
@@ -398,12 +399,9 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-			struct sctp_stream_out *streamout =
-				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
-			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		}
+		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
-- 
2.35.1



