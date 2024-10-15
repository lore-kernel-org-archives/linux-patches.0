Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01919B3FF;
	Tue, 15 Oct 2024 11:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993547; cv=none; b=W4arqhqK0vUxfFxy7G1lwwobdJ1v7gZ/Uy1SaeYhalJmZRFgbrihNw4W69O7sIY6Bkh+oMeAaABcB5vrIcpneWygs4EIBAbj3dmRfI7PTBcsF1a+A24s7Mg5IEyT7hJ2LB9LuVUS8HfxnRgsjo3QLqZMUt0+ZB7heC2vlJQvnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993547; c=relaxed/simple;
	bh=R+DMvKMpszcPGiIeCFIzpbgf35HnYgpMXAg3pcp3cmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7YuqKkkvrfm9D8ayu+Jamlwmo0oOYFBF9tNIwPqLwJ3weFpVTuQRoGrAztNTgf3tTgmj+0aRChXnGRlEsR9oc0CvGPgc/E+RTes8xwlJ+y2jg/UCKUav2ez3eznSOwZQDHDKAYGxdY5LoYao3tpQnChbdJNaeePnAynvUqqNhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6xjO4vL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6xjO4vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD14C4CEC6;
	Tue, 15 Oct 2024 11:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993547;
	bh=R+DMvKMpszcPGiIeCFIzpbgf35HnYgpMXAg3pcp3cmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6xjO4vLgudZfVNYLrct1iLGJb7ML0klapN55EQ2nVuTvy72M2/O71G3wCX5793KV
	 GjKIAFeR1O1/bYaCLgxRIBeITgGPXXEEb78aE14rmRp1KIUL+PsdSkdZfHyRs1qaJr
	 MLqgwko9uWh/7QTLroIhY6rA/ppbg+GPhOOUmq3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/691] net: sched: consistently use rcu_replace_pointer() in taprio_change()
Date: Tue, 15 Oct 2024 13:26:05 +0200
Message-ID: <20241015112456.893827584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4a0986843fb5d..49831bd6a37d5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1599,7 +1599,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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



