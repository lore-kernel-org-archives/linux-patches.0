Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055594;
	b=ADQaa8tRWoUWqeYzy/KZDcmYVJUz4PLWAJiehwk0XuPW497CdkJnzzieOCCFNVbFE/DC
	 0ugF0BdsjmHgz23wb3qeoojYAV8x0cmW7eBbmikRy+Zv5NqlkPmn/UT7pJq0IqEAeXrpL
	 wZn0hTHieAetaWQfcspy6z65Ls6FAFut0CxtWm1P7MUputi8BXDv0RNggeWLT53l2TqCg
	 L/JvjiQpx76t7HRxBEJEZWd/a95Y7h+7FqhQ3R/0LpkSH7g2Q85fC+PqqYXkqgfbJNwXo
	 gpW6jAqY8tYKBa/5c1TrnYNOK2Ie+O0xRnHWL77WXy1eLK/JPEnOiYBvZkyI0gxBPLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBZLaLi4MdOCxMkcAQBoDTpaQA0zlMuxGcMc+Om0JDw=;
	b=QOSfOq9pDd3X4x5/rEZ7Wq6mHOoF6prtjdNyRFNOXZs68tjCqVGjES7rtZL7xPXDuwtu
	 k0BDvAj0CewCGFg1ihdX+qV7pHa9BIMZWAR+Ac+NDxEPbRL+vEXV1rYSOzKq9I1vs5lJw
	 5DLbx0w05OwbvuZjg+BS5tQdwny/anREdMz6XcOeKwqU7Tq8DBONCnzFNRkxipMv3ttoV
	 24BK75ofBvOxSkJk/Z80UIYkrhaA8Bmm3LCfLp2kSvRfgGdx772INQvlz81fW4eflLA9b
	 tu+BokKaEfx3jfR4N4wztPg5fn1d8JXMzGbCNRsD/yPL6XLV0EZXu/IRidKH1KWoCHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ve1zed+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C5606A332;
	Thu, 19 Nov 2026 02:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ve1zed+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8801F000C4;
	Thu, 19 Nov 2026 02:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055594;
	bh=bBZLaLi4MdOCxMkcAQBoDTpaQA0zlMuxGcMc+Om0JDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ve1zed+mYDcvqQ+Fu4d0kwlYbywRQBLZ8InNrO7a6nicfOn8pWRJIGWC/YDfNh204
	 oL1Jf1jkKZFNkWg2yJyBGjOwZcePfwFocrooY+qs+CcFah4r6xDeeOB9LfsIoxK71b
	 3Gux0aMVGD0lejLGL3y5HPOSxuHUL6iBf/F2yex8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1680/2214] RDMA/hfi1: shut down the trap timer before unregistering
Date: Wed, 18 Nov 2026 15:55:56 +0100
Message-ID: <20261118150119.041168505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit a1c9d476c2316685f85fffb6450ad88d01836357 ]

MAD processing arms a trap timer embedded in each hfi1_ibport. Device
unregistration does not stop the timer, so its callback can run after
the port and its containing hfi1_devdata have been released.

Shut down every port timer before unregistering the IB device. The
shutdown form also prevents a concurrent path from rearming the timer.

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134151.1213-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index dcc167dcfc61b..418d25d38044d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1906,6 +1906,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
+	int i;
+
+	for (i = 0; i < dd->num_pports; i++)
+		timer_shutdown_sync(&dd->pport[i].ibport_data.rvp.trap_timer);
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-- 
2.53.0



