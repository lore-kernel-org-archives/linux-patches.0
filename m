Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F57501285;
	Wed, 30 Sep 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789591; cv=none; b=l2pb0vh3lrkthiytZPBuXL1LvGcZCFFo+KMn/JFcFuOZ19Dct+tHRbNH5S3hnXISAajRPib9aTOKSuWuo/5s0VowHKhQwoxYIYVRteKt9Mx0qxKNUcxrLS4PuLaJgYJsC1G048kpYGr+ErT+4grFcH7YSi9MU+2aLxH67hqi3ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789591; c=relaxed/simple;
	bh=65vyu11+pn3miFZiVUW6cOUXcAxNlZa+wTEa4bDJjnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlgM0iPSGiWvA7vJtRslPMhKa4oGdZnItbtg+wVsGGkD9qcSE9hl3YSs2oGaFFzHDySm+8m1WoRTFuFaFnkl03AOXKPHXv3Ezx0L6Km36RbaEHJ7MAbzP2yrTXn252ozT/Cp7ddHr22njC6GKQ6hjQcJ+VuoIJo/xVwcB0EACWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi38X4Du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi38X4Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44DB1F000FF;
	Wed, 30 Sep 2026 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789590;
	bh=kn6n0oA5eaBWKD29N9eAITRCalLha2sYSR20QyqU89c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oi38X4DuV4PsEic3BSUIiz2M1DxudCS+3FsdWqtprITjF9lbpK4LpJch5DdhFXiLQ
	 4EXkJGJvxuPI8JNMmHM++TqH1gOI1oQfsRqtBn34twzfTUoc6x//6n2vChbwJQ3MM+
	 vkL4i6eJofbhVztkoeSL9ZItwvxsLKHUmTczRZSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 530/877] s390/cmf: Fix virtual vs physical address confusion
Date: Wed, 30 Sep 2026 17:24:01 +0200
Message-ID: <20260930152426.082607465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit f4d04425e66af2ecee9d1a49ae0484436f3c2fd1 upstream.

The measurement block address is an absolute address. Define the
associated schib_config and schib fields as dma64_t to enable automatic
detection of incorrect assignments. Also add the missing virt_to_dma64()
translation.

Without this fix, a wrong address will be used by firmware when storing
extended format channel measurement data on kernels built with
CONFIG_RANDOMIZE_IDENTITY_BASE=y.

Fixes: 14edd0d73bfe ("s390/cmf: fix virtual vs physical address confusion")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/cio.h |    5 +++--
 drivers/s390/cio/cmf.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -7,6 +7,7 @@
 #include <linux/mod_devicetable.h>
 #include <asm/chpid.h>
 #include <asm/cio.h>
+#include <asm/dma-types.h>
 #include <asm/fcx.h>
 #include <asm/schid.h>
 #include <asm/tpi.h>
@@ -49,7 +50,7 @@ struct pmcw {
 
 /* Target SCHIB configuration. */
 struct schib_config {
-	u64 mba;
+	dma64_t mba;
 	u32 intparm;
 	u16 mbi;
 	u32 isc:3;
@@ -66,7 +67,7 @@ struct schib_config {
 struct schib {
 	struct pmcw pmcw;	 /* path management control word */
 	union scsw scsw;	 /* subchannel status word */
-	__u64 mba;               /* measurement block address */
+	dma64_t mba;		 /* measurement block address */
 	__u8 mda[4];		 /* model dependent area */
 } __attribute__ ((packed,aligned(4)));
 
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -184,7 +184,7 @@ static int set_schib(struct ccw_device *
 	sch->config.mbfc = mbfc;
 	/* address can be either a block address or a block index */
 	if (mbfc)
-		sch->config.mba = address;
+		sch->config.mba = address ? virt_to_dma64((void *)address) : 0;
 	else
 		sch->config.mbi = address;
 


