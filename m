Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868CC313535;
	Mon, 13 Apr 2026 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098717; cv=none; b=dpIQ9qh+/pW5mydwlUbqiwG3VJLF/Ut0jHxytqlwrUgo6wCXjpCzL8ly2mJ3lBCTf6vho+ofN0aJJ9ZA0w9gEOWwLOpp74kichB/M/qmy5YO9cblZtEeXAz5OpJJEumRAtzR1ltUsKOizgACzznEk+8lTe5GkiZl+IjwAIms7fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098717; c=relaxed/simple;
	bh=I1oMgeVAGmG+cyEh3AQe8D9einXMqyOrxGioUh92gvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3BUVDV+frym7JtPVvkIqcXxIkAIFHGROTl2sOTVCnz2MDgEvf3uazpokk5yVd6AI0tnvjmgffQ6B17r/QL75lzh64FvF3fSUWC91YysSt8j55Eo0jwNcGJ8JWyh4Nd53CQcq27JYVcVeDuch4R7blr6yo+8PCDHfMdcfw8IAPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNjBVloT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNjBVloT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9C9C2BCAF;
	Mon, 13 Apr 2026 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098717;
	bh=I1oMgeVAGmG+cyEh3AQe8D9einXMqyOrxGioUh92gvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNjBVloT9tOFbMVOK5FZSvPI4g/080D96+/e4Ajss/8D00UHphZEwOPbSuwfuXdJ5
	 zbiFTg9KHu1NDPyChSQ0WSsLlGUb3+VO8L1cqykMDjqw7Ln7Ox8KIUkk5+hynuPgUn
	 bRHk4Vgqg+4GgKnfc+MtXTqTrRyJVsiwC4ImgFpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/491] bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states
Date: Mon, 13 Apr 2026 17:55:06 +0200
Message-ID: <20260413155821.332654595@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 87e23796680b3..812e1792c232e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2592,8 +2592,14 @@ static void bond_miimon_commit(struct bonding *bond)
 
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



