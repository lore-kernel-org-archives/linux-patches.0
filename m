Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AFD1DE88F;
	Tue,  8 Oct 2024 13:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393177; cv=none; b=gouPAPrq/7b/hiBeRUBQagQMQnrtutpHgxf/wzluxicRy/MdqTWNe/4cqRH1+EFj0zURFfTI+hcsSgDmMLu8Exz7q+LWNOJGz3heMopF4+81E7szq5CNTTNpV1z3qU/Q1MlePY3OvtqyjjhEFXkBiwCe0rS1aGauvJO8PsFeyCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393177; c=relaxed/simple;
	bh=3MFAbxwQEmKE8jRm6WdAtfw4Bt2zU4kPbyBdJKI1384=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUD97Abkcef6Bc2ShdMKh0Ol4E6yTcUUtJMIcdlj5e/gk0eDVPALeWy/0QdBnvQAr0TwmkIKFyIzcTm2bAiJzR0JsYY17zdEzM6ph24+edcuKdu5k5oLUnTO/RE3U6G8yIDOJ81HVzyOrJoZ6seUqNvTCjGH+N2HKfipVfMcb4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBkX6fF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBkX6fF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DAAC4CEC7;
	Tue,  8 Oct 2024 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393176;
	bh=3MFAbxwQEmKE8jRm6WdAtfw4Bt2zU4kPbyBdJKI1384=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBkX6fF8BrBE3imNnWuiKisKjcoVu7BE+k6rRYr31ZihHjsMvBfCz0gqHhbDQCRUq
	 /HwADiTC5UTxanCcp/9/COmCi3CN66IS7s1lUIFUmoP0z45uDChYOiUuZ505ZoMJ11
	 UOsn1gpZrLxWZa3tvxULCveaJvS5NGdf1MMkVLbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/386] net: sched: consistently use rcu_replace_pointer() in taprio_change()
Date: Tue,  8 Oct 2024 14:05:20 +0200
Message-ID: <20241008115632.412954100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 418d4a846d04a..87090d6790362 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1975,7 +1975,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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



