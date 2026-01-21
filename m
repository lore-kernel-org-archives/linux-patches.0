Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF812DF134;
	Wed, 21 Jan 2026 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020083; cv=none; b=koqlOZcKj0UfN6T2BkMnuTT5KnFkMME95N8+ZjKw0G+/y4yhkbu2c6RTFzE7wCpsYd6Zn+tHfcYoAE3N7qrBHxoW4QiUxL98c60FpdHTnXI/mKrKIC7zWNpjvqdOJ49hQhimnKgQliHFYxNLeXdR1LXn9bPjEVsgWctm2xFutdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020083; c=relaxed/simple;
	bh=xAjOZQFRZcNMFjFGyYT47XKNfB2Q/20V9rAhQBpPSdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB6mN7r3/YWa02oera7cVnPzKfJoxle3V/vKlzjtuyLgk0RxgVdqZA+esudMTjpEmKj4v/iqVYlK91bwJ2aEv4nOau+xKyKAbgBrPi+WHGDbV4QLU6joWdXGelmEIQINTZ88El4KEe3He37/Slg5qHuEHejm3nI/KO6coo3mE9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agwHDHYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agwHDHYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEEEC4CEF1;
	Wed, 21 Jan 2026 18:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020083;
	bh=xAjOZQFRZcNMFjFGyYT47XKNfB2Q/20V9rAhQBpPSdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agwHDHYOg72IHBG6L1awUL0PIKO9ONx/UrdNvyFXkHpGnNuTLCugzCFRBfdDsuxeF
	 Q+7Qmr7FKTWLzy+lO6fQbJino1FhN1zZhrsOQjzPE1I5hu6fzDDjjzDOr3mMiegshl
	 cJQZ5CXtTg32JtroWExLrJqdDt4RqZBNpLqiwPX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/198] net/sched: sch_qfq: do not free existing class in qfq_change_class()
Date: Wed, 21 Jan 2026 19:14:42 +0100
Message-ID: <20260121181420.499363700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
index a91a5bac8f737..9b16ad431028f 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -529,8 +529,10 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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



