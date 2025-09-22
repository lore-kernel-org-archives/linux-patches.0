Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF9C2F0C5C;
	Mon, 22 Sep 2025 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570109; cv=none; b=L2AZljc6+rmpO6iBBHHBSN7CbD9AjOpay9KSPPdnCuFmmtprr/ZwMN1QEWoTpWsinkVOez5PVqV0fjO2f6Sq3odLlIrcc29FvqRaRVqvOoSibLCGq4ZZ315koxCwMkJODBJ4r4Kkbg6TUjnLj1dSa8I0vfO6WTy4OsIWmpqUpcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570109; c=relaxed/simple;
	bh=gdMBsV6e2BIEp4B6YddSHvkFkgMxTOiL7Sivh8yupWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkX3jkCY7Qqse2KSHyAxvSxgWkP93S8MFPFMRZkPtxCSPohBm8fTbwOL40rxFVWUXiVl6lNaJhTTV+AFiRLS6JGwdku6aOV9HHqbr0ISnDfPD26o80wBfnoIOkO1DWKzhvd4NhaQxJR8iEWQND629lqGgXE6NH5g3iV0pCZy1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp336UT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp336UT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8DFC4CEF0;
	Mon, 22 Sep 2025 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570108;
	bh=gdMBsV6e2BIEp4B6YddSHvkFkgMxTOiL7Sivh8yupWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fp336UT3tA2v5JW30OjM7che6XuYBBKDoyE58MtBKcpk/hjnBngQrK6Xl/IHVBa9+
	 +j9UnzOBT7DF1okYivBpwx4zRYhwQIf8vGubluLjmXpBFayOwsD0WCSdwkEiTjlZDY
	 2pyKOUeba+bIvhmxzrzNAftEJ2l8JwTMKC2/SMW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Heib <kheib@redhat.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 021/149] octeon_ep: Validate the VF ID
Date: Mon, 22 Sep 2025 21:28:41 +0200
Message-ID: <20250922192413.411442910@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Kamal Heib <kheib@redhat.com>

[ Upstream commit af82e857df5dd883a4867bcaf5dde041e57a4e33 ]

Add a helper to validate the VF ID and use it in the VF ndo ops to
prevent accessing out-of-range entries.

Without this check, users can run commands such as:

 # ip link show dev enp135s0
 2: enp135s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:00:00:01:01:00 brd ff:ff:ff:ff:ff:ff
    vf 0     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking on, link-state enable, trust off
    vf 1     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, spoof checking on, link-state enable, trust off
 # ip link set dev enp135s0 vf 4 mac 00:00:00:00:00:14
 # echo $?
 0

even though VF 4 does not exist, which results in silent success instead
of returning an error.

Fixes: 8a241ef9b9b8 ("octeon_ep: add ndo ops for VFs in PF driver")
Signed-off-by: Kamal Heib <kheib@redhat.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250911223610.1803144-1-kheib@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeon_ep/octep_main.c  | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 24499bb36c005..bcea3fc26a8c7 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1124,11 +1124,24 @@ static int octep_set_features(struct net_device *dev, netdev_features_t features
 	return err;
 }
 
+static bool octep_is_vf_valid(struct octep_device *oct, int vf)
+{
+	if (vf >= CFG_GET_ACTIVE_VFS(oct->conf)) {
+		netdev_err(oct->netdev, "Invalid VF ID %d\n", vf);
+		return false;
+	}
+
+	return true;
+}
+
 static int octep_get_vf_config(struct net_device *dev, int vf,
 			       struct ifla_vf_info *ivi)
 {
 	struct octep_device *oct = netdev_priv(dev);
 
+	if (!octep_is_vf_valid(oct, vf))
+		return -EINVAL;
+
 	ivi->vf = vf;
 	ether_addr_copy(ivi->mac, oct->vf_info[vf].mac_addr);
 	ivi->spoofchk = true;
@@ -1143,6 +1156,9 @@ static int octep_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 	struct octep_device *oct = netdev_priv(dev);
 	int err;
 
+	if (!octep_is_vf_valid(oct, vf))
+		return -EINVAL;
+
 	if (!is_valid_ether_addr(mac)) {
 		dev_err(&oct->pdev->dev, "Invalid  MAC Address %pM\n", mac);
 		return -EADDRNOTAVAIL;
-- 
2.51.0



