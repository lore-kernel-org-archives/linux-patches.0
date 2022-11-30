Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8172879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E45C433C1;
	Wed, 30 Nov 2022 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833884;
	bh=4F6l+GTfifoW8ZfiZu68QNiySBmgTAO7o1adpcIkHug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUKFCB8haZb/rxk9ge3kZlaRjzhimChcx0ro99TpmVG0spc8UG2CZ64MKCtbk6sPh
	 8PrRiijER1dlPH9Y9BlhXBMnBSH31GHuRr73dusjRPukcW6WNqZTBeWiy5SX+5Zj64
	 1GHe/be+brp1tgKWk1npahn/Qncbd30tvniIFMUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 022/289] platform/x86/intel/pmt: Sapphire Rapids PMT errata fix
Date: Wed, 30 Nov 2022 19:20:07 +0100
Message-Id: <20221130180544.636178894@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit bcdfa1f77ea7f67368d20384932a9d1e3047ddd2 ]

On Sapphire Rapids, due to a hardware issue affecting the PUNIT telemetry
region, reads that are not done in QWORD quantities and alignment may
return incorrect data. Use a custom 64-bit copy for this region.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20221105034228.1376677-1-david.e.box@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c | 31 +++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index 53d7fd2943b4..46598dcb634a 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
@@ -19,6 +20,7 @@
 #define PMT_XA_START		0
 #define PMT_XA_MAX		INT_MAX
 #define PMT_XA_LIMIT		XA_LIMIT(PMT_XA_START, PMT_XA_MAX)
+#define GUID_SPR_PUNIT		0x9956f43f
 
 bool intel_pmt_is_early_client_hw(struct device *dev)
 {
@@ -33,6 +35,29 @@ bool intel_pmt_is_early_client_hw(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(intel_pmt_is_early_client_hw);
 
+static inline int
+pmt_memcpy64_fromio(void *to, const u64 __iomem *from, size_t count)
+{
+	int i, remain;
+	u64 *buf = to;
+
+	if (!IS_ALIGNED((unsigned long)from, 8))
+		return -EFAULT;
+
+	for (i = 0; i < count/8; i++)
+		buf[i] = readq(&from[i]);
+
+	/* Copy any remaining bytes */
+	remain = count % 8;
+	if (remain) {
+		u64 tmp = readq(&from[i]);
+
+		memcpy(&buf[i], &tmp, remain);
+	}
+
+	return count;
+}
+
 /*
  * sysfs
  */
@@ -54,7 +79,11 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
 	if (count > entry->size - off)
 		count = entry->size - off;
 
-	memcpy_fromio(buf, entry->base + off, count);
+	if (entry->guid == GUID_SPR_PUNIT)
+		/* PUNIT on SPR only supports aligned 64-bit read */
+		count = pmt_memcpy64_fromio(buf, entry->base + off, count);
+	else
+		memcpy_fromio(buf, entry->base + off, count);
 
 	return count;
 }
-- 
2.35.1



