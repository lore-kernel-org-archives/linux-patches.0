Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215674;
	b=cK3ivuRBCIm24dFBlFvd1FimMZbFZwYvNjVf/WjrJX0kU6HWFD2QM9/s5yxIb1ydskow
	 8aldNXh3L1678WMoiTM8Q+AaMum0iR3cfnUAv0fnB67KcU+ieLnRTU/EWvXaAR3npaE3R
	 ZBLA8CL1s8dcRP+FWLoMHdcqEtdng8cygKw9UWRm8h9ehhcB9veUyM10uQBEGwf/zn9hj
	 ylkfxQ0DDqGwCJ+6UsLw0YXlUk0CAJJTTICclJYyiqqrkXAFudkYsLZxATrucJ+xFKUK9
	 /ZyyqRhL0MnKbm29wYuTw8/rm3nvX9kOPZE2buLgjbkvJJ00/9kFll0vHccRlfWd5mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=adY+MIRbYHFx1QzTnajdNu8JcCfssLe4M3Nmi/FrQkE=;
	b=3t/3B1anNHRSCJa05HiS7B+yNa/tMqtgR27jGTHWmqnvXRVoo41eehw9uZWuipdrwDPC
	 so7rPG8GIJyoZFLi7Y5n7Wf8OI8h8LBn7Aj8f+7vK6S739W2Nqmjso7n0aJxuujcskCiJ
	 Th90/BM/8l2xafHoZKwjo8LTifh317xVR8IwAoYdyYuXx8st35SeG7Ak7nhS6z4TrxIzx
	 Kt5p6aMn8kMQikJyFodBiMOfYqF4t54g6vABknvu1/4eveFJys+wDkG3o+1sdKx9t6MXW
	 7k4yD8l9tNlZhhMB1IX0KUrxuVs7CELDPErLGecJDQ4W/SVlBEKJWxukoPVbC6u6blQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLZOxe2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42D9606A32A;
	Wed, 28 Oct 2026 19:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLZOxe2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D851F031E2;
	Wed, 28 Oct 2026 19:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215674;
	bh=adY+MIRbYHFx1QzTnajdNu8JcCfssLe4M3Nmi/FrQkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLZOxe2i0TgNRvJZDjBLHUWfnJ8jmn6SVogZ1mB3RviOFWUQLzH97uU66ypNEeb6D
	 QhbiGE6S+FZN8yi5ollUzpxyYqsohDNjtwzYJ0D3ldqWi0AUhe7v1Qso4mOOglMrHr
	 tKygejJ3OyjrlumkoOJ2kx7E556BOEOtJx8uCLhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1293/1887] s390/ism: Fix UAF of sba and ieq during ism_dev_exit()
Date: Wed, 28 Oct 2026 17:56:29 +0100
Message-ID: <20261028170528.849345313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit b1896543ce59c4258625a35cf41e23a9a1f80ea2 ]

A ism interrupt handler can be active in parallel with ism_dev_exit(),
accessing freed data structures.

No new interrupts will be generated after unregister_ieq(). Drain ongoing
interrupt handlers by free_irq(), before freeing ism data structures.

Fixes: 684b89bc39ce ("s390/ism: add device driver for internal shared memory")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260805131043.954639-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 9576e3975c721..c4150dba6cd44 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -153,13 +153,16 @@ static int unregister_sba(struct ism_dev *ism)
 	if (ret && ret != ISM_ERROR)
 		return -EIO;
 
+	return 0;
+}
+
+static void ism_free_sba(struct ism_dev *ism)
+{
 	dma_free_coherent(&ism->pdev->dev, PAGE_SIZE,
 			  ism->sba, ism->sba_dma_addr);
 
 	ism->sba = NULL;
 	ism->sba_dma_addr = 0;
-
-	return 0;
 }
 
 static int unregister_ieq(struct ism_dev *ism)
@@ -173,13 +176,16 @@ static int unregister_ieq(struct ism_dev *ism)
 	if (ret && ret != ISM_ERROR)
 		return -EIO;
 
+	return 0;
+}
+
+static void ism_free_ieq(struct ism_dev *ism)
+{
 	dma_free_coherent(&ism->pdev->dev, PAGE_SIZE,
 			  ism->ieq, ism->ieq_dma_addr);
 
 	ism->ieq = NULL;
 	ism->ieq_dma_addr = 0;
-
-	return 0;
 }
 
 static int ism_read_local_gid(struct ism_dev *ism)
@@ -537,8 +543,10 @@ static int ism_dev_init(struct ism_dev *ism)
 
 unreg_ieq:
 	unregister_ieq(ism);
+	ism_free_ieq(ism);
 unreg_sba:
 	unregister_sba(ism);
+	ism_free_sba(ism);
 free_irq:
 	free_irq(pci_irq_vector(pdev, 0), ism);
 free_vectors:
@@ -611,9 +619,13 @@ static void ism_dev_exit(struct ism_dev *ism)
 	if (SYSTEM_EID.serial_number[0] != '0' ||
 	    SYSTEM_EID.type[0] != '0')
 		ism_del_vlan_id(ism->smcd, ISM_RESERVED_VLANID);
+	/* ism will only generate new IRQs while ieq & sba are registered */
 	unregister_ieq(ism);
 	unregister_sba(ism);
+	/* drain ongoing irpt handlers */
 	free_irq(pci_irq_vector(pdev, 0), ism);
+	ism_free_ieq(ism);
+	ism_free_sba(ism);
 	pci_free_irq_vectors(pdev);
 }
 
-- 
2.53.0



