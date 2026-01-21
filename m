Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF9437E319;
	Wed, 21 Jan 2026 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019540; cv=none; b=jv0IsKXB8IOISaNXE15R5UGUXBpwkqPuq5ZgpALvitlZnQNsrt2z9Df+AJum+sUbCu7kvvU8azAdkTEQUvuyaINX9dFzK9Kq8EJpM6BwK69KTeDMSCX6TuQ0rl1PL9Omd3VnsPOczNQI0UndpTnAjk4wMEcESqclW3fk+H4WJEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019540; c=relaxed/simple;
	bh=winyWNybnMG2g7fP8HyaLD5ovgiSlAIhHKcNFXpdZtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDwuGA0Da6lAWFp0GKp7Qu1c+ObaOgNK0FjLj4vFwkc96IHzFo0RuaEDMcBbksp51ntUfR6TiV8LmigD2oTXhzlt9LX/ZaYi5jtp8oOpQgDQlOsMXN0riZw0WjCa/DmfJSsEGiEMHgg1HVluS8bIvOILYytguDvnZ7us63AhpKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKnvoGjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKnvoGjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6615FC19422;
	Wed, 21 Jan 2026 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019539;
	bh=winyWNybnMG2g7fP8HyaLD5ovgiSlAIhHKcNFXpdZtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKnvoGjNQcjXGf7DEIkjeD3v3TwpSnHahcENawzrF4Mc2T3XEklL3Kd4W6ZwDpveg
	 rnKknUuD5FH6h3vpDM4gEDRLYxb9COcP3NX+UwEcAGB8nY0dAVmF3wI+oubc3xIdh/
	 sooqJ3kiCYk17EY8N2P3R7VbWfYlIXOGLA+01Hcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/139] net/sched: sch_qfq: do not free existing class in qfq_change_class()
Date: Wed, 21 Jan 2026 19:14:44 +0100
Message-ID: <20260121181412.754142818@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
index 998030d6ce2dd..d8dabc1a620bd 100644
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



