Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E646AF3C;
	Tue, 16 Jun 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627631; cv=none; b=bSysqbHz4jDpZw7zJigo8l4DG84TYqrv8iFfavvVV1N/3DbdwoV0wHTv295hVlxfLSCA5ZFkCFEyaumIOrVa7uLnTpUuj+Tqdlhl2c7bH+Pa48nqGGbA5U3dIwC07vxJYE2UuaVjm4sRY+ckq7hUeldqu/vj0oAzlS2U/9vdOH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627631; c=relaxed/simple;
	bh=ZeRjB0zekM58wxkgW9zZ0E1kGqnjVAg1P4gAzMpCGQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6H1V4Uj4IuEsZNpQ4RuOXU+Wmf+i2bvDW4Y8HNowH9L1DVEs1hLlnOQ91DV08ZGucezRq32CrAGklpsF3Mm3EQQZo5H0a1zGEK2/J9BabnOyprChRHrLC1dl5DB9gISfnOKbs/KDdi/w6iVPTh/diXtdIWViw0nAkjhqrnSJJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUpZpYLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUpZpYLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9E21F000E9;
	Tue, 16 Jun 2026 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627630;
	bh=VvEOr1Xr7dcGWe3XPe6A3RGeAKMyx6ar0Opp0DX3RE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUpZpYLLWf9Xi0KCC4cbU9Zhv1z0hRybLS3bvCr86jlwyTvu8+x1kLYXRjsWpvCow
	 Zdt1VoTacifjj/jaJraNcrJ2MGygRkwcH4hHsrd/RKk2v5GsZYo4R/bWFOqNWQxhOg
	 UoPjnLKoM0QamO57d85ZN/zwzW+c96lFI+7x6FTQ=
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
Subject: [PATCH 6.12 201/261] sctp: stream: fully roll back denied add-stream state
Date: Tue, 16 Jun 2026 20:30:39 +0530
Message-ID: <20260616145054.369087609@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
 


