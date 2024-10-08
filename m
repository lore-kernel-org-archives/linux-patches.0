Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5934818FC70;
	Tue,  8 Oct 2024 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389878; cv=none; b=bHn8xb7sqBjzjCjUMbz/QWVFXB7b3FCqurKqsG/Kyb9BiBMgevriDbxB+sot7R0VZsMv+VTqEVe5foxeGADjvwgd4K1tLqLbq73tyrkAJ7SQhnDPLLjMOE7C7eqWXb7Y8kX9xenXIDZODDSFYaURixtXfsFtT/Ua/1QtzAOwb4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389878; c=relaxed/simple;
	bh=XaOvqgydZo7az2MPu2ND+FwIS5mbhOgzKEMiFjJHHiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6FUDR7ZKRkig61gSXEe5pB07IQrOXUT2XxPE+js6XTwlI6u+eDguFWZ8bGH6rt73/kDnatNPzkBqPhHFry/7bBsizI9iLHXfJW3vJUtdQmhkb7Owb3fpv+yPE50yACKyEfGR82+uApFCqaSuk82VN0x/d8khZ8GPI9yMWqiN+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xdef11tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xdef11tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC98C4CEC7;
	Tue,  8 Oct 2024 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389878;
	bh=XaOvqgydZo7az2MPu2ND+FwIS5mbhOgzKEMiFjJHHiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdef11tfTcTVV0M4fJD79U5tG7vABBB5VFZRnDQkZ/SQELCuPA9EQBl5Xn9bKQYEC
	 wv7YAdqRZVwTT0uRv/DdhdTYS2wS/BKkFjNeiTw0GzUB/4ALOSUMmxzVzPEbDQrEEH
	 bb0Iateio9gGf0Q2rwPzafclywyNU2sZ/DjLiouA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 092/482] net: sched: consistently use rcu_replace_pointer() in taprio_change()
Date: Tue,  8 Oct 2024 14:02:35 +0200
Message-ID: <20241008115651.931913517@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d5c4546062fd6f5dbce575c7ea52ad66d1968678 ]

According to Vinicius (and carefully looking through the whole
https://syzkaller.appspot.com/bug?extid=b65e0af58423fc8a73aa
once again), txtime branch of 'taprio_change()' is not going to
race against 'advance_sched()'. But using 'rcu_replace_pointer()'
in the former may be a good idea as well.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b284a06b5a75f..847e1cc6052ec 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1952,7 +1952,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			goto unlock;
 		}
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		/* Not going to race against advance_sched(), but still */
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 	} else {
-- 
2.43.0



