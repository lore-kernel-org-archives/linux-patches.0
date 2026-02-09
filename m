Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB6137D121;
	Mon,  9 Feb 2026 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647974; cv=none; b=qBzBhu8QTD6yfjVYJTqyEbZihNx9bSB5N/PKddxYHjMNS1QnllJsaXz76yAPAzKIHcWj0FWibx9GjJMZaxa/TJg4ou8XeStDo5hd5xKSkbZvxOamEVv5XEiJ+sjP6Cylt5vPwGOMHIFLHTck2gHk5eCOgbLYyVRmYb4dXKez95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647974; c=relaxed/simple;
	bh=o5wvKI95mB3SXJmlOCODuNkfRsD4C8VfZL2AS/LF5YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZe9QrLT/4pw798F5kX1Xt6d481iAQ3Lt7bD1R8kPwP1gqB2aR3hcmzPutyICuOrGIPrNacfglHgtiQiBIobblJ00dFGNhQ9KuJA6gGrmQrFr+CtO36Hvyu7tFkdGQoip9EnpQXgHOKgYpo/jkYOrbs+ckBasae56pVkBxeg2rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsoV5ui6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsoV5ui6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3267C116C6;
	Mon,  9 Feb 2026 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647974;
	bh=o5wvKI95mB3SXJmlOCODuNkfRsD4C8VfZL2AS/LF5YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsoV5ui6mohva/KnA0Z+mwZzWLa7llivpKIvy/pRMVsjC4/hrN6d2U+RAjPp7H1Ng
	 BrycoITJNCm5CfZJOJ7VAV3eRYYfR6/Znud+RDlvis+VfqnR/tU8E3dpq6uUeXEsLJ
	 lKgxNpKrbem6Bjz9wwKWN55vl5mPdh4f1yeQ36jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Zilin Guan <zilin@seu.edu.cn>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/113] net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup
Date: Mon,  9 Feb 2026 15:23:52 +0100
Message-ID: <20260209142313.165638620@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6cbba46934aefdfb5d171e0a95aec06c24f7ca30 ]

In setup_nic_devices(), the initialization loop jumps to the label
setup_nic_dev_free on failure. The current cleanup loop while(i--)
skip the failing index i, causing a memory leak.

Fix this by changing the loop to iterate from the current index i
down to 0.

Compile tested only. Issue found using code review.

Fixes: 846b46873eeb ("liquidio CN23XX: VF offload features")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260128154440.278369-4-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 62c2eadc33e35..15ef647e8aad3 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2221,11 +2221,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 setup_nic_dev_free:
 
-	while (i--) {
+	do {
 		dev_err(&octeon_dev->pci_dev->dev,
 			"NIC ifidx:%d Setup failed\n", i);
 		liquidio_destroy_nic_device(octeon_dev, i);
-	}
+	} while (i--);
 
 setup_nic_dev_done:
 
-- 
2.51.0



