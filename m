Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317573F65EE;
	Tue, 17 Mar 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767363; cv=none; b=uZRu9JQQErfopEMlKEoNgkitcz/z6Fmi2GicouwC+2NdHj6ZLmyP5CvSHPbMayQADQCv7HicoJ6p4QsX8LDKzOv2XkjOcOCFxyVIj4RruTcWxcLB/m//vAHF8fBdXE9rGylMhJ0PtZvIjn256O2B0o2KRWoF0dYDI1RwVlpjIBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767363; c=relaxed/simple;
	bh=10LSTFglE6Bb7O76NalUqUrq6n6AtVqLq05hEF5WLlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipYhd4wi+ui6Wqyw8HfS1bjmvT45Ab9BbtSK8EOuMoCH1fKUK1h5VGisoY6Pn4xQq8FxmkTP3kuXNE9ArKGBWVg1mi7BBYcVqrzTr8/BdUWvhFYyHFnkRztw5aUMCyoR0+3IEIzn0/0b572TEtZH4JvdUTuP5pfTKmegWKdkr3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/L/71Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/L/71Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F91C2BC86;
	Tue, 17 Mar 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767363;
	bh=10LSTFglE6Bb7O76NalUqUrq6n6AtVqLq05hEF5WLlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/L/71Syxs6VV3YT17UqyCuGq4Hekgr+YgqL7JhQZ74VEmmoia4EdITuK+Tfe8Gzz
	 xugq67k3IFe9Z68ipr1coIVZhlAF9nSo5E2j3usqZ0Q3ubzahYeCXVJOxOBQw30113
	 dNIC36fboQgdrcirMxh/lOfIOBw0Rd1/o7MzW4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/333] bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states
Date: Tue, 17 Mar 2026 17:31:07 +0100
Message-ID: <20260317163000.775518704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3348be7978f450ede0c308a4e8416ac716cf1015 ]

Before the fixed commit, we check slave->new_link during commit
state, which values are only BOND_LINK_{NOCHANGE, UP, DOWN}. After
the commit, we start using slave->link_new_state, which state also could
be BOND_LINK_{FAIL, BACK}.

For example, when we set updelay/downdelay, after a failover,
the slave->link_new_state could be set to BOND_LINK_{FAIL, BACK} in
bond_miimon_inspect(). And later in bond_miimon_commit(), it will treat
it as invalid and print an error, which would cause confusion for users.

[  106.440254] bond0: (slave veth2): link status down for interface, disabling it in 200 ms
[  106.440265] bond0: (slave veth2): invalid new link 1 on slave
[  106.648276] bond0: (slave veth2): link status definitely down, disabling slave
[  107.480271] bond0: (slave veth2): link status up, enabling it in 200 ms
[  107.480288] bond0: (slave veth2): invalid new link 3 on slave
[  107.688302] bond0: (slave veth2): link status definitely up, 10000 Mbps full duplex

Let's handle BOND_LINK_{FAIL, BACK} as valid link states.

Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260304-b4-bond_updelay-v1-2-f72eb2e454d0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index dca0bec7240ad..322f910b06fc8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2860,8 +2860,14 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			continue;
 
+		case BOND_LINK_FAIL:
+		case BOND_LINK_BACK:
+			slave_dbg(bond->dev, slave->dev, "link_new_state %d on slave\n",
+				  slave->link_new_state);
+			continue;
+
 		default:
-			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
+			slave_err(bond->dev, slave->dev, "invalid link_new_state %d on slave\n",
 				  slave->link_new_state);
 			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
-- 
2.51.0



