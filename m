Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07BE749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FCAC433D2;
	Thu, 12 Jan 2023 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532800;
	bh=gVoGTNCQwQJSeT4t06tzvI7xbJnc1gGSINpoAHKQ+ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dES2hE8JwNeo1y1OlHg9QrKACk0rAm4bds8rQByCbej9edanBvJ02ol8F2J4ooyFk
	 JI22RUXAmYOHYsXmQm33Ts1ac1cXJox5enDLpObbGSYlZG1rD+Xp3UyEEGFAade4WF
	 QUp8zFQG8TD7tK8ilSF/JPWPC0eBBMWG63WQxVYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/783] crypto: nitrox - avoid double free on error path in nitrox_sriov_init()
Date: Thu, 12 Jan 2023 14:49:57 +0100
Message-Id: <20230112135537.427135054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Natalia Petrova <n.petrova@fintech.ru>

[ Upstream commit 094528b6a5a755b1195a01e10b13597d67d1a0e6 ]

If alloc_workqueue() fails in nitrox_mbox_init() it deallocates
ndev->iov.vfdev and returns error code, but then nitrox_sriov_init()
calls nitrox_sriov_cleanup() where ndev->iov.vfdev is deallocated
again.

Fix this by nulling ndev->iov.vfdev after the first deallocation.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9e5de3e06e54 ("crypto: cavium/nitrox - Add mailbox...")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/nitrox/nitrox_mbx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index b51b0449b478..a131dbbbcb86 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -190,6 +190,7 @@ int nitrox_mbox_init(struct nitrox_device *ndev)
 	ndev->iov.pf2vf_wq = alloc_workqueue("nitrox_pf2vf", 0, 0);
 	if (!ndev->iov.pf2vf_wq) {
 		kfree(ndev->iov.vfdev);
+		ndev->iov.vfdev = NULL;
 		return -ENOMEM;
 	}
 	/* enable pf2vf mailbox interrupts */
-- 
2.35.1



