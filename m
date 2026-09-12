Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FECA34BA24;
	Sat, 12 Sep 2026 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223353; cv=none; b=KMfxvOhEmJUwDC11nuFq8HT9n9tbChK9o0wqKc7cSDZHOX8EaC0nsMGFqSrFkx5vQppDPYo4eFSQoQQa0exPEix5qReWRLU+YFW5Spf4Vk+WvZbjPhMoWL3cISKjOkPksAiayOgjgQENV5Q+unr0gZgcVy0968Aj6+79aiqtXn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223353; c=relaxed/simple;
	bh=0JLwNQqMxar06UvssRFPCws7RfuFd/9jrBnstwYdytE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuuEGrIEAgaxzBDzgKJvymH476eI2DDzpII6IA0DApzMiV0A+eGNzZt5W3sM9fVn/fOa4qxCq+FVntolBPPp2bcKEjr8BohcXudyUZL4HxPvEz5/HAEOFqOMZ9h0ohPTAscoYSH9TnF5OrW4ZRo5nFvkv+Xqw5wiOQ59WyOfSnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2dqH3Ga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2dqH3Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C5A1F000FF;
	Sat, 12 Sep 2026 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223351;
	bh=lX5ULudRuudWbWnspVA1i6wj7gNyR9xD9l3OcwJtOxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2dqH3GauSozNMk3D/ICVC5a2DKmyNIAZLRhuD74qcQ87PWAcu8uF6jQiusfhWQ59
	 fgox9kppX48QXXZqGUt/AL1I3FjS+MR9TXnCOm3saOdByv0haQEJQ4DrngObuq3l9e
	 8OhcCMC/3/nY2dxahB8UHzuLu3ryLUrGnkI6Mv30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0729/1424] RDMA/hfi1: Free RX data on late probe failure
Date: Sat, 12 Sep 2026 08:52:41 +0200
Message-ID: <20260912065623.615372766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 8e17e101e04a3dc062e2719da57ff78c1c060632 ]

hfi1_init_dd() allocates the shared AIP/VNIC RX support before returning.
If hfi1_init() or hfi1_register_ib_device() later fails, init_one() tears
down the device data without calling hfi1_free_rx(). This leaks netdev_rx
and its dummy netdev.

Free the RX support after IB unregistration and before postinit_cleanup(),
as done on normal device removal.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-7-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 070e5d6c78f43..0a14f0ad38361 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1679,6 +1679,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
-- 
2.53.0



