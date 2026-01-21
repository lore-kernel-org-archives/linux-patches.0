Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB6E34DB57;
	Wed, 21 Jan 2026 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019529; cv=none; b=fyyIkZGu3WoNlhLY/xKxpBVqjTz/WZI13i9EOM9STRcYmRajXUTRaVxltcQiAu5hu4E+lP1WDZVMIe8LClnex65l/gHo5aOMKA5sFnW6G9JypQn3Yas2kmB3nJ1dXOKxMkGCYNNMPc7z1X8Y+MhtTomPql004u7AhD6Jw6yVcZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019529; c=relaxed/simple;
	bh=c64AKbljWelSDcKv04e10x+paNiz8scm/DZFMKx3CqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKw/lbSu4xLVAsweH+ZK/skc0DWt5Whe6hwU/v5PYArS7Kty3idnWuSCKGQN9ndvhpsJFaFVe9n1sQbkK97Lojt3of8YekYfPXhQYugYyHLBQjEKlBiT3m8shtkPcwNnxYBJr73FnWf3vr3+PZrnSntoSh+OMgtDxrqKbeqtze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7CWU7Ud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7CWU7Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BD5C4CEF1;
	Wed, 21 Jan 2026 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019529;
	bh=c64AKbljWelSDcKv04e10x+paNiz8scm/DZFMKx3CqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7CWU7UdWrEEmbVaIaAGk8jYVtCtPvR54ViyAkkJc+IcDrqn2I82L2qSikODTCDZW
	 M0inBPJW/Gdw5FLVpoqBihEAzhClUmEPutvrX3/5iKzpBLltr5F+R8Vi9Ku5bZ0ZKI
	 qTkvozYucXZDQYBECs1XVLLkQI5Yu96OQgMBjl58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/139] net: hv_netvsc: reject RSS hash key programming without RX indirection table
Date: Wed, 21 Jan 2026 19:14:41 +0100
Message-ID: <20260121181412.647132485@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit d23564955811da493f34412d7de60fa268c8cb50 ]

RSS configuration requires a valid RX indirection table. When the device
reports a single receive queue, rndis_filter_device_add() does not
allocate an indirection table, accepting RSS hash key updates in this
state leads to a hang.

Fix this by gating netvsc_set_rxfh() on ndc->rx_table_sz and return
-EOPNOTSUPP when the table is absent. This aligns set_rxfh with the device
capabilities and prevents incorrect behavior.

Fixes: 962f3fee83a4 ("netvsc: add ethtool ops to get/set RSS key")
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1768212093-1594-1-git-send-email-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index d6fe8b5184a99..5f612528aa53a 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1765,6 +1765,9 @@ static int netvsc_set_rxfh(struct net_device *dev,
 	    rxfh->hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
+	if (!ndc->rx_table_sz)
+		return -EOPNOTSUPP;
+
 	rndis_dev = ndev->extension;
 	if (rxfh->indir) {
 		for (i = 0; i < ndc->rx_table_sz; i++)
-- 
2.51.0



