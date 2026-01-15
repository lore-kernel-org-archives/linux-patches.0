Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF642D73A0;
	Thu, 15 Jan 2026 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496637; cv=none; b=BvrBL7kksXl6spAmSzknuT+tXJjhjr45lxNBOp6Wo+w4XiavH6W34x+pRdnsV455/Ipv5cIz8h2r1PjRD87Bae2lBsq/d2q+qh0tTJP0lxbfQwuEkTKzr3k66mrBWxd3crT2P29WIMjGcZm9sYUK81NnNP+UsrfalzEfajOqDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496637; c=relaxed/simple;
	bh=qX7IEhsNPF9qsXc9jvtga8HArkCk833s9EWLEmpaZcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkeRlzQgtePxaiPoh/yz51/jIr/zglL+9yFE2NiMGAREcP/nh5iJNVHGCMdlvGkIcWV3m1tBj0cgZ7EkGs52uXQO4/ur8IaJDk0DVsxCkX0Hds+iZh0/jbdEuicRsS8jlwMsizFIF0qPoR/9PZ2ok/FO0yhxrVUvKOKy/VKhEro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTJztD4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTJztD4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CEFC116D0;
	Thu, 15 Jan 2026 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496637;
	bh=qX7IEhsNPF9qsXc9jvtga8HArkCk833s9EWLEmpaZcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTJztD4Qd+QBeG8DTA5G9wSE7yAtiyOAHCECp20295Ud/xe4Dj9r6QL3Megf0x9Wu
	 zLfXibYdGYUENs3QTAbJ/ehGbqrahJm/8lgKDvoIhgVtSG/2YUOmYNupMDBDekg2rk
	 K4usBqUNVB4Qzonrvm89FR0Y13HDMKxB5+NaC5W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/119] net: usb: pegasus: fix memory leak in update_eth_regs_async()
Date: Thu, 15 Jan 2026 17:48:18 +0100
Message-ID: <20260115164154.946290583@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Petko Manolov <petkan@nucleusys.com>

[ Upstream commit afa27621a28af317523e0836dad430bec551eb54 ]

When asynchronously writing to the device registers and if usb_submit_urb()
fail, the code fail to release allocated to this point resources.

Fixes: 323b34963d11 ("drivers: net: usb: pegasus: fix control urb submission")
Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Link: https://patch.msgid.link/20260106084821.3746677-1-petko.manolov@konsulko.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 81ca64debc5b9..c514483134f05 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -168,6 +168,8 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 			netif_device_detach(pegasus->net);
 		netif_err(pegasus, drv, pegasus->net,
 			  "%s returned %d\n", __func__, ret);
+		usb_free_urb(async_urb);
+		kfree(req);
 	}
 	return ret;
 }
-- 
2.51.0



