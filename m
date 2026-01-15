Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6733BFE49;
	Thu, 15 Jan 2026 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500061; cv=none; b=eHPM7OJ6pbsQmnxxkI3XtIx04uN2O2//OlHnWCrfw7XXZet+jzbmA0L674YfAvsZR/AWaATOTXh4wpbll7jw70tpWZJqHSVknp1YPbiQJwJjhrb0gYUqcDXUDpbsqXkKYORIzclrDhLcdLlBQq7Mzwrtm3ls9HbffxaqTMzlALI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500061; c=relaxed/simple;
	bh=DyBhaoAOHciw7wo0E0fMaiXCOgxz4hg4+vRroqupvEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXuk9/FGIQZucDuudj3A1o5FOzEsohsTPCJPBx4YOn8GF3ZRh9qqhfGwxmAZnRrCW602M+S7cCAw7RHldO31OvIli9bNWHWK1FNymVXv2EoTr829fYAz2FiYruLY2oniXZaMRfO3g7UopoqVMHbMLrw6OR5hCdDYd2wvF8zVysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZMNMInZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZMNMInZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD9C116D0;
	Thu, 15 Jan 2026 18:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500060;
	bh=DyBhaoAOHciw7wo0E0fMaiXCOgxz4hg4+vRroqupvEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZMNMInZGHTUY9Si6Cvd640gInEczYXit28PrppIuoAJR2BLzUReXr0/q95lFqUCS
	 jeOYwndvFNG2zOGCsXGHpXK/xvl0aSxmk2lP5fZHyWDRW8pMHscprkQ0UrV1l2eBHY
	 T3O077Jxm4/kSbyXIul6w3g8Wria3rysvPzm59HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 443/451] net: usb: pegasus: fix memory leak in update_eth_regs_async()
Date: Thu, 15 Jan 2026 17:50:44 +0100
Message-ID: <20260115164246.971982868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 138279bbb544b..e3ddb990dc543 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -193,6 +193,8 @@ static int update_eth_regs_async(pegasus_t *pegasus)
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



