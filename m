Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA7651357A;
	Wed, 30 Sep 2026 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787857; cv=none; b=HwR/InusPyCErGZjSSQYJnMDhFzZq3SRkUdNvTQkRv+kUcXCcDn43Cysz+tJJ164K6zlOFpiDk5pxi9czpq6mFI6boGPWqQWZDYziDYd3jMZ9D3prTbMxP3pFU0zZDYvjrPb3XtROHEowyPHCWkRMnvPZcqlDn+YWZIOvPtCNtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787857; c=relaxed/simple;
	bh=CnawZSQ4k9ahhXaGAYwVsz6M6334tS3a7UHWpOVDf3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPGK1h00W3O7akUPxdM2DKTrPrM8FEUf50t/qeeeI8dKsjIm6+5IK7+6b+RH+pkNOpoLC3jKH+4Nkx/iktZozQ0RxaOzEyuBP8jacAuKZianeWMVTq+3KpkKe3vUX+6RXqArkuT/kTwr/ZiuNC1eswI2Bj0mHXZM/4xIE1PRtU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1OMIm2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1OMIm2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AB31F00899;
	Wed, 30 Sep 2026 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787856;
	bh=zrrBGUvfVaFxYOifGgZlk9DfZdNJHiaHMWC0hd0NwDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1OMIm2CFb2nSO76IGZYVJTKt+qaGRdTe+JIl9VQQmJDJhQXMdL0rmv/BalgfrsAV
	 Dn6kdfYZknHQ/0TmajdmH+7ZtKEw+L3eQSUcd2udTLka/VhhHu7SixbOvNN/FW+uBk
	 JkZdivnwAqOg07h3/fZPEAZcMipUuuO35bl3/uYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 377/457] s390/cmf: Fix virtual vs physical address confusion
Date: Wed, 30 Sep 2026 17:28:02 +0200
Message-ID: <20260930152354.140163542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,7 +183,7 @@ static int set_schib(struct ccw_device *
 	sch->config.mbfc = mbfc;
 	/* address can be either a block address or a block index */
 	if (mbfc)
-		sch->config.mba = address;
+		sch->config.mba = address ? virt_to_dma64((void *)address) : 0;
 	else
 		sch->config.mbi = address;
 


