Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04AD1CEAAF;
	Tue, 27 Aug 2024 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772631; cv=none; b=jq0n0ngvDxiGZts1lA6r5MCPWu/qGa1JtVOW83p7ObYKKVXdmmkbvMqeVvta6YudsnyVuQ627AlwpfA7LYw77VH96Mf9MYU0cn4yQI9yV8JdHawGPRNSTO7gqJekpn58i67AmVH1cP1AiKEPgfdxW75c8kEbHZQh7TI9kEl8EYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772631; c=relaxed/simple;
	bh=aJe7TvTETCHT86xX5abo8SHtoVVcE8ciW4c805+4vzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2NZ57ItWdel5DlAG9PSVg5+uqc4c8CpjOkVGhPzxqeshUrQbkymBEYCh/XFCicgxTZg02Y6LNm+/CE2MvqKKEiMyPRj3I5CDUtxDTsWoIscqzt5ZFSiCpxlUKcUBSxfMH2RhFL9vy07V+CMpl7w4vOESzo+MO5SMjpUWagZvdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDFVqHd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDFVqHd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CE4C4AF65;
	Tue, 27 Aug 2024 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772631;
	bh=aJe7TvTETCHT86xX5abo8SHtoVVcE8ciW4c805+4vzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDFVqHd23i9r0buOCxDEb+x4uo3MFJbDn2Dd78vQy8bz8+qFeuRYeKTbg7sdj+ocT
	 If0RBoMb8Q5YhbOApfc606SfGr/z2V1H9Qnuk/YGyJ/c9P32xB6MEvIZpLuPd4ZXAu
	 ogY3r6qmrmb9kffZWyTbVhvNGqIgbEg5ek0o5M6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/321] bonding: fix xfrm state handling when clearing active slave
Date: Tue, 27 Aug 2024 16:39:09 +0200
Message-ID: <20240827143847.413600500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 685fb4703ee1f..06c4cd0f00024 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -932,7 +932,7 @@ static int bond_option_active_slave_set(struct bonding *bond,
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



