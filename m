Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8929C1C4603;
	Tue, 27 Aug 2024 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770643; cv=none; b=WOttGBPYTNruw6G2VPK+sOwP9TavPU8pqVR/3i0vAc3Mox+xLUD3lE36KeeiC6YMjkP0mZf3tkxQa/yljatyrSSHFGloZZAIUq7ya6umRToGyGZ2+ScVdpipGvF3RvhQKWemi+scAfFVwyfg1heF2ZvWp2ijzNkxBZGlDYu5zCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770643; c=relaxed/simple;
	bh=UK/5d0cKP7Yxrlg+saywix3XZAevuvRfgK3gJqg31DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRHcqImadcvpNdqaoNif5lPf2d8P/cIuj3NzDBM7xH/CCxY1VoXR3m9163cv6qWHJZIPt4XOmBzFqJJTnTyxVDsIh1S5Ieah2xO6t7iuVAYC2cH+4uV/5dRJs4SqLa3JhV1luABw7qySoQgH4XtLnWhNNZNNS/lNP0raQB0Pn0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3RhRLBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3RhRLBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BBFC61044;
	Tue, 27 Aug 2024 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770643;
	bh=UK/5d0cKP7Yxrlg+saywix3XZAevuvRfgK3gJqg31DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3RhRLBwAyIDEwOiUtR25Fxf90tQHH8T562esIIZO+dNcQP7zJGtE7BLKlQSSapZC
	 9oMmpwmtWMYHQFF81YGBwPUwY9RltK3GS7XQkvgfNB/4wjfg2km6k09sqTEkBmMhTs
	 iJnnOMXS96RV6jvGFZgnNVG77LLVRrTCb/N8zi60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/341] bonding: fix xfrm state handling when clearing active slave
Date: Tue, 27 Aug 2024 16:38:10 +0200
Message-ID: <20240827143853.261233382@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit c4c5c5d2ef40a9f67a9241dc5422eac9ffe19547 ]

If the active slave is cleared manually the xfrm state is not flushed.
This leads to xfrm add/del imbalance and adding the same state multiple
times. For example when the device cannot handle anymore states we get:
 [ 1169.884811] bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
because it's filled with the same state after multiple active slave
clearings. This change also has a few nice side effects: user-space
gets a notification for the change, the old device gets its mac address
and promisc/mcast adjusted properly.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 00a662f8edd6b..d1208d058eea1 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -920,7 +920,7 @@ static int bond_option_active_slave_set(struct bonding *bond,
 	/* check to see if we are clearing active */
 	if (!slave_dev) {
 		netdev_dbg(bond->dev, "Clearing current active slave\n");
-		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
+		bond_change_active_slave(bond, NULL);
 		bond_select_active_slave(bond);
 	} else {
 		struct slave *old_active = rtnl_dereference(bond->curr_active_slave);
-- 
2.43.0



