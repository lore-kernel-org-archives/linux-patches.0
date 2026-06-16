Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977564534B3;
	Tue, 16 Jun 2026 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626126; cv=none; b=cLtmLlqUwLJt7MAkgXoZ+L1OM/jibADJNsBG8EXtvgCL81mOLBcNCgSzBWxgIlrmglboXjHjeBUSrahscKivbTVLtxtj9akU5phmpZaJy2JX47YMB8rFasGdWgxyjtJ83tlMH6SCxZM/zDQ3A69ZRnJbpW+qle5E8vdhFwiPQk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626126; c=relaxed/simple;
	bh=cUIuNzrBO1kk+i5SPb/QGFoKMlF6Bv9VkEoHrDOrz2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUdedppAJU8hmLj3o/L6qBQwIHDPywEeZP8ZeKoGZFe2Ch4SMK/Fi4DEK+ad/SU1xDALMgQqsTa2AaWrAoNv0RZdskWwHJZWpNBT6xVFVAOcTaDPB9rC9WJty4PF0nD0TeZD7F5S5sS2wqFh01sXcxADSz6lqcperT1wjv7xLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuF3mGiK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuF3mGiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AE21F000E9;
	Tue, 16 Jun 2026 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626124;
	bh=ThmZBUEvXL3/O+YxxLEAD6Jo1ex24PGQAhqnTidA9DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuF3mGiKJQZ5abdFUA67OS8EaXidWSwESrtaAf35YFBP0+FSdoTbuEDMeEBpFFUo4
	 itqNyrfC2sETgEx354hcoku/vYCsn4klJ0s0tMRhr6re3C1JkeKZr/nORcKR3b8XjQ
	 zS4b+dusvgLzYokzY3o91CGVkwW/KoSC30OGQx1U=
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
Subject: [PATCH 6.18 268/325] sctp: stream: fully roll back denied add-stream state
Date: Tue, 16 Jun 2026 20:31:04 +0530
Message-ID: <20260616145111.996048227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


