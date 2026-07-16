Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13AD27732;
	Thu, 16 Jul 2026 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211756; cv=none; b=ISkxLmzdUm9xtbxmr/CYXKPuKs9KTfZ8wzmyDU7aA15OCbhDKqTjs4cOADvimjzvhhdK5osaIa+bfykqNb81wJP5w/ixU+BkC/JH3NQfzRNfD/enzuapv1ykyoO+XkWv5C8hSuEE9bDossTb5yk8/5Hp2jnrfScF4cooxw6zueQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211756; c=relaxed/simple;
	bh=mM3OUE1boWwoqRzxvsh8N0vm8iCYkxJ64JK8aq7XYh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uepgZkcI1rNXUZxYOy0nFRdgBZcmzuMz0hOrIbQ2yCs3GTjVhdQXrpFxBGzaAKvsC73fBeiEpcPgNA1NYv6sKA3U6cew+ncCf9cFJjdI5EI4WtYGcENuaxZ8j+KQ69uqT+UxLOCmXhKW/TJKpMRAeHdvUBIAKk7r/VNgKrcOf5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6e+dlK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6e+dlK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4217C1F000E9;
	Thu, 16 Jul 2026 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211755;
	bh=qfq2jbIjA7pbGi0OFggLsrzKgsGDZWeKGCpAtbjL8iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6e+dlK3RN+1+JFnofPk7l1vi3zqlCfvnOczvgj7/dQUnj6dPlXccKnvn6ZQY6CRq
	 II26+/m3po87t25wA/+e7eB+vher85kFBGxm2gut7U8OnrW2kIMXCk41VWHCc6XT/+
	 eCgOa3UN1vZR1p/jy1X20wOH0rf2oRDTLjBJsW8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko-bot@kernel.org>,
	Maxwell Doose <m32285159@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 051/349] iio: chemical: scd30: Cleanup initializations and fix sign-extension bug
Date: Thu, 16 Jul 2026 15:29:45 +0200
Message-ID: <20260716133034.465832706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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


