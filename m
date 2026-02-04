Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CF52E92BC;
	Wed,  4 Feb 2026 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216726; cv=none; b=uxkKdpuQ2I3FUdMrg3L+3mEzSZA7EtffNFHEBmMciASnccuck+rviVPW1HxLsdW9aTSgF5MnqmC2taR8RKX0gS3yMA2BlZtaOe8DrWs3Wm5Qg40v24nQfAbj4jauX4uBixp7Ob4b96yJLinnO04OixYYbta64QCHs5u78fVetaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216726; c=relaxed/simple;
	bh=LnL4mB+KgPaJ5GmZ5ahVTopjb+rkFodZWXNc2/SKLjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHXlz9nDelrCE/3yBLtFgpohnqtDZ+Ys48jAjrmY+GY4UEqN7WzADevq09fY0gkZO7AhOqaoLop3a39Ucf/E1Cx84F1rcvcfz0pDgZinhqXMqBLHi/vR5rxw0FN2WecnRN24Rw3EpKRsH2UPIJVga8X3x4W8I7VcN+5ypFZ/koc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJb10DTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJb10DTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6C3C4CEF7;
	Wed,  4 Feb 2026 14:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216726;
	bh=LnL4mB+KgPaJ5GmZ5ahVTopjb+rkFodZWXNc2/SKLjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJb10DTUSILXtK0VHhuJ5/Cq0pv2uD2tYiFETwxyyxr3Unzg5O8pGiEKFN0Z6rZWs
	 p341pwvPnPm4GImEkh8pVySdNPR5KJral3a7NN/Qyyf5QYzhDtxWj9Ssp2pPNeA1o1
	 JTLcK8QVWyAoH+b+Rjzv4lD5EjcFZW/piZ35aLno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/206] net/sched: sch_qfq: do not free existing class in qfq_change_class()
Date: Wed,  4 Feb 2026 15:37:24 +0100
Message-ID: <20260204143858.682490213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3879cffd9d07aa0377c4b8835c4f64b4fb24ac78 ]

Fixes qfq_change_class() error case.

cl->qdisc and cl should only be freed if a new class and qdisc
were allocated, or we risk various UAF.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Reported-by: syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6965351d.050a0220.eaf7.00c5.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260112175656.17605-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index aa049dd33a74e..d201bcb5edc42 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -532,8 +532,10 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	return 0;
 
 destroy_class:
-	qdisc_put(cl->qdisc);
-	kfree(cl);
+	if (!existing) {
+		qdisc_put(cl->qdisc);
+		kfree(cl);
+	}
 	return err;
 }
 
-- 
2.51.0



