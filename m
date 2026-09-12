Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A93367B65;
	Sat, 12 Sep 2026 19:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243000; cv=none; b=RUIJzijqtut9lFTDa0f2rZzpPDafK8JdmvpVdametU37xyHnzxiI7PVR7cJnLYVbwpSH//KWlVljJEiANFjhbs6n4wf1hOAkNMlwcA7LN3eDSJuSngtIo+rJOmaL/ipbinGeHQQZEClmAUihesUYKt3T4fxnGjfvABgK5U3Lxjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243000; c=relaxed/simple;
	bh=hQI9+cRVQa2T9ye7APyyyeNi2vvnxe9VF+xiUhqLXH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSWRGxFd5kqf8vlhlQvM/gi2B+pOkB2i4NdxCiM02XbTgy0nA5re4haThgHHupIfllSsevfo/sWkZgjuTuNRAC7euIoBcSJsiXWKSKqANkFy4p5zAgxlSiQ1FxZRxwhs6Hlv9TqtC8Y0j4++fhlxHh5SzskCtgrDD8XcIeArYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbhlcXYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbhlcXYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC81F000FF;
	Sat, 12 Sep 2026 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242998;
	bh=JloEpyOPc/vyfVSp87jK3G9nbQ3T1WLHEtAVn1i6AyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbhlcXYw7Ah8AqpHeMk8EMWepZ5xM9+RC77iccxXGnIjN+0gO8JYbS+ZBxsPHNhUu
	 eWnjP2sxLUxQxVGJ5P6nktuFmt9FmLKgfwrU3BW3DLQ4Rp22w0Sz6NXDfvZLXAVEPV
	 7LtY1DPuu0xCN5BI08bZqi5Zx2A1Dg45Ee5lrFNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 599/798] rapidio: clear mport->net when rio_add_net() fails
Date: Sat, 12 Sep 2026 09:03:47 +0200
Message-ID: <20260912065530.854819123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b74030fbf187b43c1f85b66a7082e9946511cb5d ]

rio_alloc_net() stores the newly allocated rio_net in mport->net before
rio_scan_alloc_net() registers the device.

If rio_add_net() fails, rio_scan_alloc_net() drops the device reference
with put_device(), which releases the rio_net through the device release
callback.  However, mport->net is left pointing at the freed object.

A later mport unregister path can then dereference the dangling mport->net
pointer and may try to free the same rio_net again.

Clear mport->net in the rio_add_net() failure path, matching the cleanup
done for the destID table allocation failure path.

Link: https://lore.kernel.org/20260708070628.721010-1-lgs201920130244@gmail.com
Fixes: e842f9a1edf3 ("rapidio: add check for rio_add_net() in rio_scan_alloc_net()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio-scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index dcd6619a4b027..3cc25d0534513 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -874,6 +874,7 @@ static struct rio_net *rio_scan_alloc_net(struct rio_mport *mport,
 		net->dev.release = rio_scan_release_dev;
 		if (rio_add_net(net)) {
 			put_device(&net->dev);
+			mport->net = NULL;
 			net = NULL;
 		}
 	}
-- 
2.53.0



