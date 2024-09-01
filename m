Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29C5376EC;
	Sun,  1 Sep 2024 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210384; cv=none; b=je1Yf37HCE+bPPfUdidjNWlaSLXm2x4UE5+GZoB+lvRFlTubY+VxGCJqNWJCKTejEc55bwaf/FeXBXpJ7DJwPZytxaOOyqaOOq9x/qCmlRhaVQJVqt2bZ8lRtBfywy4/OSgWyTsoc/UixMsL7Wn1XhOQG9wn5jAQAKFVKB3HkeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210384; c=relaxed/simple;
	bh=TN+B/kxbvakHEM77WpDg8frHpDF4ifn7L5RxLSgBtaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9ci7eHE456m6JY4CEoAkTSQuvmmb4pRil8B5MucDGQWB1LEqvUy8R8dz3rrGT7cQfskO9F19R2EWubocwFK9INihhXCg4DggCkAjxNIIoYcyqBHBkNZPpoSgA0slfl+JGJxmZ2Vp1huY/CV6mA79KixZoNLDTjj2z2/B2MEvwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Me3/eXUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Me3/eXUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2963AC4CEC3;
	Sun,  1 Sep 2024 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210384;
	bh=TN+B/kxbvakHEM77WpDg8frHpDF4ifn7L5RxLSgBtaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Me3/eXUFb5rSelKjdnABWcjCNw/KWtLyBKMmPG0liARCvpnJOozgcP+8iBiNGBmg7
	 ic40KgLssWVnHQRgnMAUPVSpYPtsIZ2+0zWsBwcURgpThW3kmEWxRbUFhRIkreE0B4
	 caNA4kzO/n4njSVYitrRt+OzRBnrcRDkiAuhrScU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/215] bonding: fix xfrm state handling when clearing active slave
Date: Sun,  1 Sep 2024 18:17:34 +0200
Message-ID: <20240901160828.733330817@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 1f8f7537e8ebf..5da4599377e1e 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -893,7 +893,7 @@ static int bond_option_active_slave_set(struct bonding *bond,
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



