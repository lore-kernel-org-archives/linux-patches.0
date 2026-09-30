Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D89A52F278;
	Wed, 30 Sep 2026 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793581; cv=none; b=h7vjbedgXqdADg8JmGNq78S6Gk0CR3AUjGKX1CqF4uQXDf046+82MTVUwZvT/pav73SqLEaQxFpmJ4a6/R6yg1PqZYs5aW6ERq0HhhcvP+fV4D7lFqTec3/wwzX8YnfYzmDYQA1/onp3BXz9exQ2NXsImCoJQHT/6jGUnJo6qV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793581; c=relaxed/simple;
	bh=im2A3h3UZqgbjgD9JT5dcT+4l7jdfBmrZIfdxHaH7Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhRCOVSN8i6cGPVjwQLkSnVG/L5jhJhVlxUq7zh2s9bTaQX2vjiQJEWNOBi8uCyIAaPaHWBfQnxrUe3UpXoOxjw7ETFLzkCA48DvnHj1Hu4saGBqUML+aC5zyU0al8xW/IPRbeyeLSqnAU/HW7XaWYqEgSmo1XlvkyHmFOsbV0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2alDY16b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2alDY16b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE061F00898;
	Wed, 30 Sep 2026 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793580;
	bh=pIshVXvVTA5/iUAUm49SbqP7S0a9IHFsjKjwKZizDm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2alDY16bLkRraN/Jo8WjRz0aFtVb1+XUpqzWcHTtCBli4Y8Ub9LvnYunJYEO93gI2
	 CSF6Cf7b6jrYojXUU/VbyFhhutJjTV34MX/MXelfK3Ppm4PyrFJJ+6HcH3XKycEw4J
	 8O6PycboBezx1vfTHDqwtP1G320/E+uJKw1AZkqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 304/395] s390/cmf: Fix virtual vs physical address confusion
Date: Wed, 30 Sep 2026 17:29:26 +0200
Message-ID: <20260930152347.250373542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


