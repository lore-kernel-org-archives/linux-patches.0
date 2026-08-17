Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53F279907;
	Mon, 17 Aug 2026 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974852; cv=none; b=DOh+q1BPZICpfo6UIbj0V19ao3zBikkM12S2dcRBlXUR3qG3ajT1dbpjT8j+ssUhj9FxPviLM6+TDrxZJiuCyY6Hn2e6oaIrfPAzr/Yp3n8R2hYoRG/nSJnN21XN3sHnXAiR/ylIiPzi6pxtkEBRnBftXxmHacCEIpb69/5xisQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974852; c=relaxed/simple;
	bh=YvOCW6qb867AoTF1RSP8mTa/9UYuE//gw4DYN4iddAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMLNtdxMxvn4ydfldDmu1Pynw/q4cD8Mly8wvmx2Dbekd9tumIg+0jqObz67YE5zgrCXFso7e0MUNOv3LVtPBbADLJodQqU3ffdnGsRrfUyDf3TOQNQIGvQ8In3ZThjn/edaFqGIH6mJvhdQ3a+eRgowr3Tk1CqzqrynGssf/Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMBvoCKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMBvoCKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268BD1F00A3D;
	Mon, 17 Aug 2026 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974844;
	bh=lmCK8xtHy/B7jSNdkm9zULcSJTSJhTPiEzSdaHkyel8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMBvoCKkveg9eKHk+Ry/q84hQ9Wk6vzlIUl97Kn9D86R3VQdX8DyE7n8JwEy6hn8Q
	 ERms3xVJ/rVN9NBkX7KL6BD3zfGjVPF/CRM2Vv5z26hT3wWLDQkzFwK1JLFHqdxtd4
	 3cYdBJN0X8LpbwihB82PcXq0wXO912nmlZJe/5aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satish Kharat <satishkh@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/250] enic: fix tx_hang_reset use-after-free on device removal
Date: Mon, 17 Aug 2026 15:29:55 +0200
Message-ID: <20260817132537.849612348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 6bc8dfdb3d4be..2a8b41d8eb883 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2959,8 +2959,9 @@ static void enic_remove(struct pci_dev *pdev)
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



