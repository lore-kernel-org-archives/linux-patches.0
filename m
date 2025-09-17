Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3221E489;
	Wed, 17 Sep 2025 12:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113024; cv=none; b=HajP/i54MKiN2O0i3mxIyedSVH+aJoWE4fqvOA2W/lNaf3Vg0EPyCDeisI9Z61b8U37LKHkmGBz3UluvNIHE4+mZqAu2hxPAMoUkG9M4UUtTsk/xrQTxVSIL54g8pFtcPpc9HgGXIug916m16ppuzjg8U6u3YzuaFGUUTix8bkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113024; c=relaxed/simple;
	bh=I7gifj+nZ+xPqtpd+ID89J/D+Xb8Q5YUs5X02csJiTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9hwzKgg/ES/hsA83Lu138FptWW97Ft0KFB2WyNMG4VFiXp5YYICyVjJBGbcPNUdmyp0pcQQrC2yRx2QivdCDtjRn5KA4dupzH8WrHUHYF7W+IB9OSSuDplfk5m6LU2P5SNFB6bl3LfQMDTPjl/22uPUrNK25oXSGbB2S3CyePc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDracnVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDracnVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64B4C4CEF0;
	Wed, 17 Sep 2025 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113024;
	bh=I7gifj+nZ+xPqtpd+ID89J/D+Xb8Q5YUs5X02csJiTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDracnVywLySpkqcHHIHRbgPYZ0d3nGGc0d/enMOgT4lGrDVz6jpApOCezyRYbiK3
	 u5tdauvd8hvvWbGQsl0gEvBTISgV9tIUYfzHQIM5eVd/9gWGzzDVXXmGRgiJf+Hl6M
	 I8YID94gzJ7onxKYABqyahgevVecJ1V9QO5jOzOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e0f89fb6cae5d002de0@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 146/189] macsec: sync features on RTM_NEWLINK
Date: Wed, 17 Sep 2025 14:34:16 +0200
Message-ID: <20250917123355.435193987@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 0f82c3ba66c6b2e3cde0f255156a753b108ee9dc ]

Syzkaller managed to lock the lower device via ETHTOOL_SFEATURES:

 netdev_lock include/linux/netdevice.h:2761 [inline]
 netdev_lock_ops include/net/netdev_lock.h:42 [inline]
 netdev_sync_lower_features net/core/dev.c:10649 [inline]
 __netdev_update_features+0xcb1/0x1be0 net/core/dev.c:10819
 netdev_update_features+0x6d/0xe0 net/core/dev.c:10876
 macsec_notify+0x2f5/0x660 drivers/net/macsec.c:4533
 notifier_call_chain+0x1b3/0x3e0 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
 call_netdevice_notifiers net/core/dev.c:2281 [inline]
 netdev_features_change+0x85/0xc0 net/core/dev.c:1570
 __dev_ethtool net/ethtool/ioctl.c:3469 [inline]
 dev_ethtool+0x1536/0x19b0 net/ethtool/ioctl.c:3502
 dev_ioctl+0x392/0x1150 net/core/dev_ioctl.c:759

It happens because lower features are out of sync with the upper:

  __dev_ethtool (real_dev)
    netdev_lock_ops(real_dev)
    ETHTOOL_SFEATURES
      __netdev_features_change
        netdev_sync_upper_features
          disable LRO on the lower
    if (old_features != dev->features)
      netdev_features_change
        fires NETDEV_FEAT_CHANGE
	macsec_notify
	  NETDEV_FEAT_CHANGE
	    netdev_update_features (for each macsec dev)
	      netdev_sync_lower_features
	        if (upper_features != lower_features)
	          netdev_lock_ops(lower) # lower == real_dev
		  stuck
		  ...

    netdev_unlock_ops(real_dev)

Per commit af5f54b0ef9e ("net: Lock lower level devices when updating
features"), we elide the lock/unlock when the upper and lower features
are synced. Makes sure the lower (real_dev) has proper features after
the macsec link has been created. This makes sure we never hit the
situation where we need to sync upper flags to the lower.

Reported-by: syzbot+7e0f89fb6cae5d002de0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7e0f89fb6cae5d002de0
Fixes: 7e4d784f5810 ("net: hold netdev instance lock during rtnetlink operations")
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250908173614.3358264-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 01329fe7451a1..0eca96eeed58a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4286,6 +4286,7 @@ static int macsec_newlink(struct net_device *dev,
 	if (err < 0)
 		goto del_dev;
 
+	netdev_update_features(dev);
 	netif_stacked_transfer_operstate(real_dev, dev);
 	linkwatch_fire_event(dev);
 
-- 
2.51.0



