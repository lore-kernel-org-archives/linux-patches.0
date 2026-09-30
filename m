Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C53F42C513;
	Wed, 30 Sep 2026 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791404; cv=none; b=BOQFTDj4i7NH7UI7SNSdL6oaZhjQF45ZEfYt7UEpqqmNu2VWtB5Mtq25MAsBF0FqFMltZT97Y75YkB5pCYPNNA3RIB+n5wLERa0OL83K3gdhHJULTaq5mtxmY7uMkiBcRbo/gQdz/ZzjvCQgK/GYQYhXy/ZOXeLiYhUdGkPF6Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791404; c=relaxed/simple;
	bh=hANuhBYUFRJ/zcShckqT85ZPqlIGhmlHiVbUYFwZTwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ7nIokCwQ6z2kTdTDQdbqNKL/b3Wqcl017nedGVp8f8CYoBPHm8bLxa+Toqcg6cYbuWsz13tEiZA5cR1UkwUeGmK+lxQWf7NMpD0g0P2Di2tE6XZ4sSJNU+gX3TM0ch/hdjzfujQV/dBTodDRGwwA+D1HlvAxC32AVnFYlSk8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLZ914O0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLZ914O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87491F000FF;
	Wed, 30 Sep 2026 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791403;
	bh=l/TIQ3SRu693SiQfnZqW/teZri0+pt2OV8iyEcaOv54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLZ914O0DYWJMdVKqMcJ09BjFSQpjmJn7YIrAD23UvsRzjVf1ShuLPy5W4yvThqOW
	 q+HNPdiIcF2iDA3WjPPJLTK7wb+ZcwtDVUwWkSahx01PuzWb5tEIH/cGrSaKj33ydH
	 rMzqBTG9b84TE25SzCnm0wxotrJICIhH+OstvgRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/752] bonding: do not clear curr_active_slave prematurely when releasing all slaves
Date: Wed, 30 Sep 2026 17:22:40 +0200
Message-ID: <20260930152404.566666068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

[ Upstream commit af602c7aa5fedc9be3043244017aef4f26c96b70 ]

When releasing all slaves during bond destruction (all == true),
__bond_release_one() unconditionally clears bond->curr_active_slave to
NULL in every iteration.

If a backup slave is released before the active slave,
bond_alb_deinit_slave() triggers rlb_teach_disabled_mac_on_primary(),
which increments the active slave dev promiscuity counter and sets
bond_info->primary_is_promisc = 1.

Because bond->curr_active_slave was prematurely cleared to NULL when
releasing the backup slave, the subsequent iteration releasing the active
slave evaluates oldcurrent as NULL, so bond_change_active_slave(bond, NULL)
is skipped. Consequently, bond_alb_handle_active_change() is never called
to decrement the promiscuity counter, permanently leaking promiscuous
mode on the physical device after bond teardown.

When oldcurrent == slave, bond_change_active_slave(bond, NULL) already sets
bond->curr_active_slave to NULL. We only need to avoid selecting a new
active slave when all == true. Replace the if (all) branch with
if (!all && oldcurrent == slave).

Fixes: 0896341a44bf ("bonding: fix bond_release_all inconsistencies")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260831203042.164466-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f4322b4d8f6b3..b74732d2924b1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2393,9 +2393,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 		bond_alb_deinit_slave(bond, slave);
 	}
 
-	if (all) {
-		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
-	} else if (oldcurrent == slave) {
+	if (!all && oldcurrent == slave) {
 		/* Note that we hold RTNL over this sequence, so there
 		 * is no concern that another slave add/remove event
 		 * will interfere.
-- 
2.53.0



