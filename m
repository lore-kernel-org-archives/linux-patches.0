Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70A1328635;
	Sat, 12 Sep 2026 14:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222818; cv=none; b=fARVJYGLjdUgOLV+rl31i/2XONDogKn6bz+Z06p3dCjcMiu8Cx/EBQ6e6xE1ju8mu/Ap+XmVzu8Y2IvedYaPhFlnHczGt9crJiT/rr0CK0FPc7dq/dyal+sBkwucdzKifqJs19PmtEUTV19fH6p4TGEujLvu040tbQ4S0AKuJhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222818; c=relaxed/simple;
	bh=PYKoKhYi1rlldQ/3M/jeFfo6joTnrelg0k4gvFTIh5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKgyMLtHCkrJjzbx90PBt/c2JAtG47EchThIJt+OgC13fm1M8gM7nO4O4kDUgdyr2rxwNZi6k8239wRdbHuIH7gvwdoQ8fOmsoovxq2uVqXVjkwnp52WhDCy20DBkPywvG7cbV0dNQTwJX4kxQy7G8VSagXueW131BybK46SBRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhR6O3FE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhR6O3FE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CE91F000FF;
	Sat, 12 Sep 2026 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222816;
	bh=VfISTGgGWBBqJBQlQOtdSwjQXgauTOk8CtgbXxLcjYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhR6O3FES3HFGHYvqLxmfSsNPNJrmW7XvumBsZWz4hFkiyztorh2CaFx9SKtc5Mr7
	 tdWQ64AKRmK+5WeetqamsXAksXExDuUHHA7fKgxOkgaQZPdV9dY6nbuL2DkinReoyL
	 r18mzeYBFtoTMIP0HfZbPhyUdLQFfS8ktxQI8ryk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0662/1424] staging: octeon: ethernet-mem: replace pr_warn with dev_warn in free functions
Date: Sat, 12 Sep 2026 08:51:34 +0200
Message-ID: <20260912065622.119846572@linuxfoundation.org>
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

From: Ayush Mukkanwar <ayushmukkanwar@gmail.com>

[ Upstream commit be5e8d5f61b31105e0ed7f51cd591653aea5054f ]

Add struct platform_device parameter to cvm_oct_free_hw_skbuff,
cvm_oct_free_hw_memory and cvm_oct_mem_empty_fpa. Replace pr_warn
calls with dev_warn, using &pdev->dev for device-aware logging.

Signed-off-by: Ayush Mukkanwar <ayushmukkanwar@gmail.com>
Link: https://patch.msgid.link/20260511150931.93382-2-ayushmukkanwar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-mem.c | 31 ++++++++++++++++-----------
 drivers/staging/octeon/ethernet-mem.h |  5 ++++-
 drivers/staging/octeon/ethernet.c     |  6 +++---
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-mem.c b/drivers/staging/octeon/ethernet-mem.c
index 532594957ebcf..af79b2bdac278 100644
--- a/drivers/staging/octeon/ethernet-mem.c
+++ b/drivers/staging/octeon/ethernet-mem.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2003-2010 Cavium Networks
  */
 
+#include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/slab.h>
@@ -40,11 +41,13 @@ static int cvm_oct_fill_hw_skbuff(int pool, int size, int elements)
 
 /**
  * cvm_oct_free_hw_skbuff- free hardware pool skbuffs
+ * @pdev:     Platform device for logging
  * @pool:     Pool to allocate an skbuff for
  * @size:     Size of the buffer needed for the pool
  * @elements: Number of buffers to allocate
  */
-static void cvm_oct_free_hw_skbuff(int pool, int size, int elements)
+static void cvm_oct_free_hw_skbuff(struct platform_device *pdev,
+				   int pool, int size, int elements)
 {
 	char *memory;
 
@@ -59,11 +62,11 @@ static void cvm_oct_free_hw_skbuff(int pool, int size, int elements)
 	} while (memory);
 
 	if (elements < 0)
-		pr_warn("Freeing of pool %u had too many skbuffs (%d)\n",
-			pool, elements);
+		dev_warn(&pdev->dev, "Freeing of pool %u had too many skbuffs (%d)\n",
+			 pool, elements);
 	else if (elements > 0)
-		pr_warn("Freeing of pool %u is missing %d skbuffs\n",
-			pool, elements);
+		dev_warn(&pdev->dev, "Freeing of pool %u is missing %d skbuffs\n",
+			 pool, elements);
 }
 
 /**
@@ -107,11 +110,13 @@ static int cvm_oct_fill_hw_memory(int pool, int size, int elements)
 
 /**
  * cvm_oct_free_hw_memory - Free memory allocated by cvm_oct_fill_hw_memory
+ * @pdev:     Platform device for logging
  * @pool:     FPA pool to free
  * @size:     Size of each buffer in the pool
  * @elements: Number of buffers that should be in the pool
  */
-static void cvm_oct_free_hw_memory(int pool, int size, int elements)
+static void cvm_oct_free_hw_memory(struct platform_device *pdev,
+				   int pool, int size, int elements)
 {
 	char *memory;
 	char *fpa;
@@ -127,11 +132,11 @@ static void cvm_oct_free_hw_memory(int pool, int size, int elements)
 	} while (fpa);
 
 	if (elements < 0)
-		pr_warn("Freeing of pool %u had too many buffers (%d)\n",
-			pool, elements);
+		dev_warn(&pdev->dev, "Freeing of pool %u had too many buffers (%d)\n",
+			 pool, elements);
 	else if (elements > 0)
-		pr_warn("Warning: Freeing of pool %u is missing %d buffers\n",
-			pool, elements);
+		dev_warn(&pdev->dev, "Freeing of pool %u is missing %d buffers\n",
+			 pool, elements);
 }
 
 int cvm_oct_mem_fill_fpa(int pool, int size, int elements)
@@ -145,10 +150,10 @@ int cvm_oct_mem_fill_fpa(int pool, int size, int elements)
 	return freed;
 }
 
-void cvm_oct_mem_empty_fpa(int pool, int size, int elements)
+void cvm_oct_mem_empty_fpa(struct platform_device *pdev, int pool, int size, int elements)
 {
 	if (pool == CVMX_FPA_PACKET_POOL)
-		cvm_oct_free_hw_skbuff(pool, size, elements);
+		cvm_oct_free_hw_skbuff(pdev, pool, size, elements);
 	else
-		cvm_oct_free_hw_memory(pool, size, elements);
+		cvm_oct_free_hw_memory(pdev, pool, size, elements);
 }
diff --git a/drivers/staging/octeon/ethernet-mem.h b/drivers/staging/octeon/ethernet-mem.h
index 692dcdb7154da..ff10ba4525ee8 100644
--- a/drivers/staging/octeon/ethernet-mem.h
+++ b/drivers/staging/octeon/ethernet-mem.h
@@ -6,4 +6,7 @@
  */
 
 int cvm_oct_mem_fill_fpa(int pool, int size, int elements);
-void cvm_oct_mem_empty_fpa(int pool, int size, int elements);
+struct platform_device;
+
+void cvm_oct_mem_empty_fpa(struct platform_device *pdev, int pool, int size,
+			   int elements);
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 9eee28f2940cf..9e2099a782bd8 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -958,12 +958,12 @@ static void cvm_oct_remove(struct platform_device *pdev)
 	cvmx_ipd_free_ptr();
 
 	/* Free the HW pools */
-	cvm_oct_mem_empty_fpa(CVMX_FPA_PACKET_POOL, CVMX_FPA_PACKET_POOL_SIZE,
+	cvm_oct_mem_empty_fpa(pdev, CVMX_FPA_PACKET_POOL, CVMX_FPA_PACKET_POOL_SIZE,
 			      num_packet_buffers);
-	cvm_oct_mem_empty_fpa(CVMX_FPA_WQE_POOL, CVMX_FPA_WQE_POOL_SIZE,
+	cvm_oct_mem_empty_fpa(pdev, CVMX_FPA_WQE_POOL, CVMX_FPA_WQE_POOL_SIZE,
 			      num_packet_buffers);
 	if (CVMX_FPA_OUTPUT_BUFFER_POOL != CVMX_FPA_PACKET_POOL)
-		cvm_oct_mem_empty_fpa(CVMX_FPA_OUTPUT_BUFFER_POOL,
+		cvm_oct_mem_empty_fpa(pdev, CVMX_FPA_OUTPUT_BUFFER_POOL,
 				      CVMX_FPA_OUTPUT_BUFFER_POOL_SIZE, 128);
 }
 
-- 
2.53.0



