Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C523E1694;
	Wed, 30 Sep 2026 19:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795326; cv=none; b=IYKvjufvU0RaLrJRukT5beiwKf4rdJn9kKoxbvVddOCsclJDzuDzZyYBxwh7zkE8U25BS1ZjVUxv2Spno7Ji+dP8MWRiM7vYMkpiKp+q7vcpEgb+JPIv0i3f+z/JGJN7+KO4KZiazVuAF1jNUsdHoDhP5zKvMfiyRGuar8U1TtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795326; c=relaxed/simple;
	bh=hcg+PHlKQi9PQ5W+zNO5p6UnDrQPvNHVS1sX8YCsnrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkWpifzrWSLeH+S0bzHaxsMWn0T8BDER4gKX/Zq3QQqWNR+6EM6NUgkjz09reRx6zTW/3FAEgpFFjz41R62vLlZM4ZWBNpfg9P1Ceicv5fz5z0R8PJ8Q1RjXGjHZNVWCQhTgPedtvLJPpxqJt1A0mQ4+9ksWj7jirCg/MJHHuGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWjPB9K8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWjPB9K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387E31F000FF;
	Wed, 30 Sep 2026 19:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795324;
	bh=OQkD3RWuN5rII9vgxQRDER84Uby5Ir1/hpHKBOdzXh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWjPB9K8XyK7RT4px69DXPlmWDVWyqtch7GUB/XxyiGAzWNHc8d4XJwVfNE3AIV2a
	 deQ8juudYgFe86s6hPKcejpWFSHgd+7ZPVkRK3mSP05r2FL4m89Hgw/AFQQxZQC+At
	 hLa4AM0uxdDWYOF5OS0EMclL8FaY5B/JD2VlTR50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0467/1193] bonding: do not clear curr_active_slave prematurely when releasing all slaves
Date: Wed, 30 Sep 2026 17:19:11 +0200
Message-ID: <20260930152444.545037211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 09e2ae6739073..9444982330823 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2496,9 +2496,7 @@ static int __bond_release_one(struct net_device *bond_dev,
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



