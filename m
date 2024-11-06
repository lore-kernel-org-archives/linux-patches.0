Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830E31F4FBC;
	Wed,  6 Nov 2024 13:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898328; cv=none; b=Kisx2IhmnOgK01v/PwYUPfZA1dOEsOzLZfqWQ1eDTRqq6ICIUEx+QvwoAL2rXhaXuusLUc31gkBWpeG8n5DKEqdsUvDh63GfgsNVK6PvI41krixjucdx64zhtoThSCA/m5i6lbhuEliMcw/vUmYZeaE3r0if90/5VKx1lbE7nZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898328; c=relaxed/simple;
	bh=zXuatlFXFrDEw+PWedYvtGBDvDlwtRz3W/pXUPA9S10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uip7gDzlBuA5uaBdKU+WP6qO/03faeVlohGjrqMPW6ABjvx7bqTjxh9xBgOYL+ECi14ix0MERVvuszFVdvAUAyK/QCLWfkYeNX1zizngLnXgAYaY7dTdQZ8QH7oGCEdOnH1chVhgf1XdG2/eL5AFtN5k1zV+JTUeLcr6PwKqFj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cPw69UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cPw69UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE1EC4CECD;
	Wed,  6 Nov 2024 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898328;
	bh=zXuatlFXFrDEw+PWedYvtGBDvDlwtRz3W/pXUPA9S10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cPw69UNxpkFrF8XHRZy3V8nCPqyk4s8AMrCiU7DXdR0lFrEWc5Z76xx5KJkWkMAT
	 X3QHwDBr1jGwisbW5qQyUSlnbsaexaEB7cVkg6Ry9aztDGsD4vS+ecrHPLx+DtEZM3
	 ubCI/3mZHI66s8WHMxWt2P4Pup3hmJjGFaHJnRbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/462] net: sched: consistently use rcu_replace_pointer() in taprio_change()
Date: Wed,  6 Nov 2024 13:01:35 +0100
Message-ID: <20241106120336.504454665@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7b896be009d55..b8e26013bd75f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1578,7 +1578,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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



