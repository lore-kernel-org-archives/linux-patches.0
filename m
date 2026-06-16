Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EF73BFE5A;
	Tue, 16 Jun 2026 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634280; cv=none; b=qm2Y1TcNUyVhOKp8+WPlopMR/Lye0dunvZ0Cb8IhHVNvGvs8BWGGJ83SV8KhIhfDwedYd83+02hnD2qRWLmliBOQnNcJfRRGhPJwKIuFTDaq9xrHT4U/mJ5iDrDbi6CV2ZHhs/RX86qqwTxVIp8tsVlhGY0NJ3cg3pJLyV2zSDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634280; c=relaxed/simple;
	bh=+fzLOKZVm98/3437/xu0mtMCwTcZScx6ZgTjL25/b6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWjTuN8/V5ybxoUfuFXO582ieiTY7NCFQ7m3NshVyWjuvN6bO7qt5+zte7eNwUz456cGzUUIvyexaGmICkRdPckqkS2FrjwIHzFAXYJRcpks0xbAGvKDi8kHcCbxZHVRVhJq+AzCFgjxMRm++2BTEDiFz4V9/lZRfmPFkdUPVC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJ+zpTUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJ+zpTUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332B41F000E9;
	Tue, 16 Jun 2026 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634279;
	bh=qgVvirZm8Tsgrmjjl2Uj+hOuct9zWN62orGiMU/m8e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJ+zpTUB88jWPC+OGNmnniezrvCh1gMFj0cfpQYHDdTwL5lo5Ev86AoEZN7DnK2hK
	 1/2nntUUMCA2kh4hCShNheEDqjy0wbUjOm06/wFF64xzVw3Z2OHPIbqrCyBcKo7h46
	 +73k34HpsnUOymxPbASCB6ZRunNqVrFzefiPR5qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 236/411] sctp: stream: fully roll back denied add-stream state
Date: Tue, 16 Jun 2026 20:27:54 +0530
Message-ID: <20260616145113.380548910@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wyatt Feng <bronzed_45_vested@icloud.com>

commit a5f8a90ac9f77c678a9781c0a464b635e0d63e49 upstream.

When ADD_OUT_STREAMS is denied, SCTP only shrinks the queued chunks and
then lowers outcnt. That leaves removed stream metadata behind, so a
later re-add can reuse a stale ext and hit a null-pointer dereference in
the scheduler get path.

Fix the rollback by tearing down the removed stream state the same way
other stream resizes do. Unschedule the current scheduler state, drop
the removed stream ext state with sctp_stream_outq_migrate(), and then
reschedule the remaining streams.

This keeps scheduler-private RR/FC/PRIO lists consistent while fully
rolling back denied outgoing stream additions.

Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/d78954ecd94954653ee299400e98d74a03a6f7d3.1780603399.git.bronzed_45_vested@icloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -1038,6 +1038,7 @@ struct sctp_chunk *sctp_process_strreset
 			stsn, rtsn, GFP_ATOMIC);
 	} else if (req->type == SCTP_PARAM_RESET_ADD_OUT_STREAMS) {
 		struct sctp_strreset_addstrm *addstrm;
+		const struct sctp_sched_ops *sched;
 		__u16 number;
 
 		addstrm = (struct sctp_strreset_addstrm *)req;
@@ -1048,7 +1049,10 @@ struct sctp_chunk *sctp_process_strreset
 			for (i = number; i < stream->outcnt; i++)
 				SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 		} else {
-			sctp_stream_shrink_out(stream, number);
+			sched = sctp_sched_ops_from_stream(stream);
+			sched->unsched_all(stream);
+			sctp_stream_outq_migrate(stream, NULL, number);
+			sched->sched_all(stream);
 			stream->outcnt = number;
 		}
 


