Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C91A2517AC;
	Wed, 28 Jan 2026 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614072; cv=none; b=GQ3aKVUOUnEdWgG4GXRToqmYjksFUVrUe7SMm6EYyRxwU4rRKjR1zdwzpqsU3RcxTbUEGJEax2SXXxxAT3UnSmbj59x49TfvUg2eF5FmeF66DgaLCIZtBlSMAnirzN8fteFAVIfAbDFQV9tpXf3OBIIiCuU2csilyMKh4KuOE1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614072; c=relaxed/simple;
	bh=akOCVHoATaa9fmUv3bsA/VIppGIYgC9ghLstoKsys08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRysIFRxnTQy2CBhdC23flCNz5Znx6RKHUnTSrhT4AXTjtmaIxD9vqyvfg5nyoi8rZrwJ3GKbrqyQoM20tLNLtStQ6YR6z1ZJNbGrZ+qr/5vQ9rkZe4aTQbM3390JbMPnrgdngDI5hBeH2lkQe955WTasXkNpXu1+zIsItmc/LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJGVHzbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJGVHzbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477D7C4CEF1;
	Wed, 28 Jan 2026 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614071;
	bh=akOCVHoATaa9fmUv3bsA/VIppGIYgC9ghLstoKsys08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJGVHzbQcnMRzelavHpBFgu5YX6Us4yz0vJ7xZJLz7rdsaAuiA5zH3dlb3Ltttlzs
	 U4Ti5gxqKt8SrveLqfUH5nVpx8blnY/TCMHr9i+MMx4cPBcTapitzYP7wWE8wx37kZ
	 eXutzbn5H3ruaczWN/PI8N/9tZIVldprSRLkw9UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/254] net/sched: sch_qfq: do not free existing class in qfq_change_class()
Date: Wed, 28 Jan 2026 16:20:03 +0100
Message-ID: <20260128145345.681929875@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 29847c28ffaca..7c6b5428b8ed4 100644
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



