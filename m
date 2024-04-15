Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670AA757EA;
	Mon, 15 Apr 2024 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191686; cv=none; b=KUMI8A2NLsSJ5ptqxm7X0t6FODhXzVehVe9DGIO2wYnILU1paHx54zh+UFnfetwOIDeUpqmunwrzLLao21vQ6Z90n8vp4iu+YO+mSkleMUUa7kiK7sLM97V3pAmA6hLueyEDxOk9Ye6UoTvPiidwr4y4Gvl5lYnbwZ+A1661rhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191686; c=relaxed/simple;
	bh=hIlBBi7ISlHCajDmnyDSm/w1OZOnXva6NRMZoFF6/a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpXS80Hn4JdJ6g3ECGzhs8wi9ee+DTdQV2/gDx+L5nyi2R39w97aH0P3S8wh1Hj+hGml7CfKAzDLwYZvTKUYZ2yk1JHxAi0G170c4eIQtKJ8ivJ3WKYprJYEhVznicEbvVCf7kDbklmUaP0EkN49jReRzFnpb6kpGSfiobMWj9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlVC25Uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlVC25Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFF6C113CC;
	Mon, 15 Apr 2024 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191686;
	bh=hIlBBi7ISlHCajDmnyDSm/w1OZOnXva6NRMZoFF6/a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlVC25UzQ7PoNfkT6y5fmtilofg1Tv05KStxWJbc969gFbz3X/c+fomIxQCbYyPEe
	 wSaYEuxZaP7Y7mM6isebC6AaBRlA+l0k0kzGMUXxAKAleT5V17LJB6b/Rk4fawbz6N
	 tvvkJh1L/pjMDDKI6X8f9OIvgpTtNG+H2NWJPUjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Manish Mandlik <mmandlik@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/122] Bluetooth: l2cap: Dont double set the HCI_CONN_MGMT_CONNECTED bit
Date: Mon, 15 Apr 2024 16:20:18 +0200
Message-ID: <20240415141954.960741572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 600b0bbe73d3a9a264694da0e4c2c0800309141e ]

The bit is set and tested inside mgmt_device_connected(), therefore we
must not set it just outside the function.

Fixes: eeda1bf97bb5 ("Bluetooth: hci_event: Fix not indicating new connection for BIG Sync")
Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ab5a9d42fae71..706d2478ddb33 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4054,8 +4054,7 @@ static int l2cap_connect_req(struct l2cap_conn *conn,
 		return -EPROTO;
 
 	hci_dev_lock(hdev);
-	if (hci_dev_test_flag(hdev, HCI_MGMT) &&
-	    !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &hcon->flags))
+	if (hci_dev_test_flag(hdev, HCI_MGMT))
 		mgmt_device_connected(hdev, hcon, NULL, 0);
 	hci_dev_unlock(hdev);
 
-- 
2.43.0



