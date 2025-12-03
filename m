Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0753081AF;
	Wed,  3 Dec 2025 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776359; cv=none; b=JY9iHSvC4FRUQfonRUqorJpVQR/gc5t86As6I09f7Ed8lQ7x2XmQlf4D+E1NMFQoOLchhecriOqm+LvzoEIrbUtu5vj1lkfmJBPKZiqUafcVYPy7m97+YSQC3kV4tUS8RnFRPBpuXCoCLL7u8TOj+dms+zue4hi9bGWt5Wrimyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776359; c=relaxed/simple;
	bh=42zfVCqQtEe/9NgZZDtcKO+UlTtbJaxJDS4U2Fb3GHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6wbCbh7BWtPXINLenJlGTdIAC6/ahgtD9f4Fq1zmY5i+Wreu/19bOtjUM69j4RUvv/TrGLpYzCbDNxwBCLLEpqtl9XYBabrH7J007JH1lm75p32VtmlCbcfZJFw+DN6DTJ9I0BonMCn2Kf9SWmJ7SOUM22SP+mBBBYRXbM3qNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7dVZuNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7dVZuNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E431C4CEF5;
	Wed,  3 Dec 2025 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776359;
	bh=42zfVCqQtEe/9NgZZDtcKO+UlTtbJaxJDS4U2Fb3GHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7dVZuNO1/jdPJPaOfQCoxVObcbHqX00qNMWSIoTkfxy9lL1i7NCYQZFzPV2u91IT
	 E7+9FmB8nmyQQvPT08YpegJ+99bub2KYLeTuYwIWvZTNCvgwugl570iHZGgHDan17W
	 Z4gBJS38nlufpgi7jlLrXDI0Ego7nudm/xd0hiho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/300] net: vlan: sync VLAN features with lower device
Date: Wed,  3 Dec 2025 16:26:03 +0100
Message-ID: <20251203152406.508518103@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

[ Upstream commit c211f5d7cbd5cb34489d526648bb9c8ecc907dee ]

After registering a VLAN device and setting its feature flags, we need to
synchronize the VLAN features with the lower device. For example, the VLAN
device does not have the NETIF_F_LRO flag, it should be synchronized with
the lower device based on the NETIF_F_UPPER_DISABLES definition.

As the dev->vlan_features has changed, we need to call
netdev_update_features(). The caller must run after netdev_upper_dev_link()
links the lower devices, so this patch adds the netdev_update_features()
call in register_vlan_dev().

Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251030073539.133779-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 07b829d19e01e..7be41986001bb 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -191,6 +191,8 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	vlan_group_set_device(grp, vlan->vlan_proto, vlan_id, dev);
 	grp->nr_vlan_devs++;
 
+	netdev_update_features(dev);
+
 	return 0;
 
 out_unregister_netdev:
-- 
2.51.0



