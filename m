Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB9843B3FA;
	Tue, 21 Jul 2026 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670928; cv=none; b=K9Biu2EzHplWbMZp6E6fWUngZwtKGDAeRuCeXcj/O3sWJGwMiuaDLJsgnBpYiWm0HIhUVmJEEKe5du7UjMGmu/tWWFEf8tAzusL0w7tjVbyrCxXVmNcbXdC2cK5KL9f3Y+UP3ujeDV2dODRiMtQUGQPPC7TWEoATiwcf6qz8cVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670928; c=relaxed/simple;
	bh=KgBlsAH8xNSPZfG8B02SFuGtzrw3/XEfek9XDk1l4Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2ILr/BBfxrtrsbOrj42nC8NMBmnig8b9Z1jRuxAAFjLmlnabKnZgFYfpCQX+FEwOjuu+6DD/0g2gxQsYZzZpsNAmbP3WIlFkbQEHG02eFCU+O9W5n8+1p79+E1OC9AIQKCsLHa7ykngOmaECpF5hxHnp4a28aRnjmpRM0MtoIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSo7Sxgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSo7Sxgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408041F00A3A;
	Tue, 21 Jul 2026 21:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670926;
	bh=uKtxhRWXOm1ef+mdEN4BwI85Em5AkWj2vrp++m2sP5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSo7SxgjStM7PKJVx5w6V8MYd4jSp6bHy4uV7CHO7fAQyOUmU55krXEsOkgMamGer
	 mbWkwIk/CvcX1RM68wBrDN6WaPhLF/87vo7MFbcc+mWibMIiT2SJpbHahXpU6uVNLG
	 04xCghFDuzutB3nGDepSPwhB8B4uwJi2EsvGl0pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko-bot@kernel.org>,
	Maxwell Doose <m32285159@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 053/843] iio: chemical: scd30: Cleanup initializations and fix sign-extension bug
Date: Tue, 21 Jul 2026 17:14:48 +0200
Message-ID: <20260721152407.178132526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxwell Doose <m32285159@gmail.com>

commit 60d877910a43c305b5165131b258a17b1d772d57 upstream.

Include linux/bitfield.h for FIELD_GET().

Create new macros for bit manipulation in combination with manual bit
manipulation being replaced with FIELD_GET().

The current variable declaration and initializations are barely readable
and use comma separations across multiple lines. Refactor the
initializations so that mantissa and exp have separate declarations and
sign gets initialized later.

In addition (and due to the nature of the cleanup), fix a sign-extension
bug where, float32 would get bitwise anded with ~BIT(31)
(which is 0xFFFFFFFF7FFFFFFF) which corrupted the exponent.

Fixes: 64b3d8b1b0f5c ("iio: chemical: scd30: add core driver")
Reported-by: sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260524020309.18618-1-m32285159%40gmail.com
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -4,6 +4,8 @@
  *
  * Copyright (c) 2020 Tomasz Duszynski <tomasz.duszynski@octakon.com>
  */
+
+#include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/completion.h>
@@ -43,6 +45,11 @@
 #define SCD30_TEMP_OFFSET_MAX 655360
 #define SCD30_EXTRA_TIMEOUT_PER_S 250
 
+/* Floating point arithmetic macros */
+#define SCD30_FLOAT_MANTISSA_MSK GENMASK(22, 0)
+#define SCD30_FLOAT_EXP_MSK GENMASK(30, 23)
+#define SCD30_FLOAT_SIGN_MSK BIT(31)
+
 enum {
 	SCD30_CONC,
 	SCD30_TEMP,
@@ -89,10 +96,14 @@ static int scd30_reset(struct scd30_stat
 /* simplified float to fixed point conversion with a scaling factor of 0.01 */
 static int scd30_float_to_fp(int float32)
 {
-	int fraction, shift,
-	    mantissa = float32 & GENMASK(22, 0),
-	    sign = (float32 & BIT(31)) ? -1 : 1,
-	    exp = (float32 & ~BIT(31)) >> 23;
+	int fraction, shift, sign;
+	int mantissa = FIELD_GET(SCD30_FLOAT_MANTISSA_MSK, float32);
+	int exp = FIELD_GET(SCD30_FLOAT_EXP_MSK, float32);
+
+	if (float32 & SCD30_FLOAT_SIGN_MSK)
+		sign = -1;
+	else
+		sign = 1;
 
 	/* special case 0 */
 	if (!exp && !mantissa)


