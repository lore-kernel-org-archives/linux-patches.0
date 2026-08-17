Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE1043D50C;
	Mon, 17 Aug 2026 13:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974036; cv=none; b=akQIao6GoBbTfR/peK2tc2iXsoXsN1tT5LddQX9C7szakvzgf/uvj8o6pAvR8NXnqmxG9IK8o9iFgPWB8bjatgx0wFOMQsR+sKEXGvAaiu5H7uWMYt78sJ6AWORWt22PU4MDAGKC9c3VXYrnLJtb38pV+N5g83FQWXNfmz2JuGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974036; c=relaxed/simple;
	bh=k3um3xjFBGSmtfoyniVcss9TSjdfEGO2v7T98ZT3aQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDHML8k8JXuUpw8FFOjRFZroA0hbhVCTr/Gn6b2ldTjNqwlbUzeuzkQxmNGEQHIkVrcnD9foVG0sjPZbDrSP+dj8XGLaQ/W8x4tgQo4L8waHqd+PrliqG5oWflBx7GIl1QZuY5V3rWnuR8xaHZJvlJ0L5QGasDeq9R7SdS65wI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N871OnCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N871OnCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16F41F00A3A;
	Mon, 17 Aug 2026 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974034;
	bh=jwPawwNC7hJD8CXJrXattx2nSnyqGMg2DfJP48KHhMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N871OnCWkeg6f/cAvi8qUHUnY6ncDG4RlSsjhIPtz0jQMLWCUP2WjH0StHvhuoZXY
	 kjhHVhtp4wCUiH48dVnXakZeq+nZ/LRw6Of7lSPxEZMSI9yhdtEmRyZcGRgPcRgDCO
	 hq/BpQWjqZGXDZMnaqFb8kM0NCZFtNL28p/ucVK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satish Kharat <satishkh@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 039/271] enic: fix tx_hang_reset use-after-free on device removal
Date: Mon, 17 Aug 2026 15:29:24 +0200
Message-ID: <20260817132538.351618888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satish Kharat <satishkh@cisco.com>

[ Upstream commit ec680ea4ba1bca92a767fb7e7869758bfdd886e3 ]

enic_remove() cancels the reset and change_mtu_work items but does not
cancel tx_hang_reset. A TX timeout that fires while the device is being
removed can schedule enic_tx_hang_reset() so that it runs after
free_netdev(), resulting in a use-after-free.

cancel_work_sync() alone is not sufficient here: the still-live watchdog
and notify paths can re-schedule these work items in the window between
the cancel and unregister_netdev(). Use disable_work_sync(), which
cancels the work and blocks any subsequent schedule_work() from
requeuing it, and apply it to the reset and change_mtu_work items as
well so the same requeue race is closed for all teardown work.

Fixes: 937317c7c109 ("enic: do hang reset only in case of tx timeout")
Signed-off-by: Satish Kharat <satishkh@cisco.com>
Link: https://patch.msgid.link/20260728062730.2394873-1-satishkh@cisco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index e7125b8180879..d98f7e7ccab9b 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -3011,8 +3011,9 @@ static void enic_remove(struct pci_dev *pdev)
 	if (netdev) {
 		struct enic *enic = netdev_priv(netdev);
 
-		cancel_work_sync(&enic->reset);
-		cancel_work_sync(&enic->change_mtu_work);
+		disable_work_sync(&enic->reset);
+		disable_work_sync(&enic->tx_hang_reset);
+		disable_work_sync(&enic->change_mtu_work);
 		unregister_netdev(netdev);
 		enic_dev_deinit(enic);
 		vnic_dev_close(enic->vdev);
-- 
2.53.0



