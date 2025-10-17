Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC342F692A;
	Fri, 17 Oct 2025 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715256; cv=none; b=X8G/aasp2EVnvtZNTOSlMTTn3kqjtIgX466lkIcSlKQlKmmuuW75ODSZIH1FMu8ofi9hP5XOl7sSieOLbvZfld9X9dTyYNQaHRMpDNJwt+yRTDHvdRRQ04hjiM8mV41iJ2uMOXIFTZRAdBPYN80JaAFhXABlCnWhU7Iouwp8HS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715256; c=relaxed/simple;
	bh=uHLcs62fLxB5/h23SXDxLlIOTlviamLST5/nEnZyJf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+vcfr5Oz3NU7wvY/WQZRz6isrO/ncmRj7WHsKiyt7SusS1JiSxCr1twQx/LhMcPbYeMjiGEB1bV7Ehi9oqintxEx0+GAQ7cmiFQFyV8I9RgieU3/xcM4jK8P/lZ8bMCs4qJ8ib4mehT+qPPE+u1umNEkEr9sNkpKVPB0D/5fEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bmv4TwTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bmv4TwTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7957AC4CEE7;
	Fri, 17 Oct 2025 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715255;
	bh=uHLcs62fLxB5/h23SXDxLlIOTlviamLST5/nEnZyJf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bmv4TwTFp1pYhj6vLog8xjOLM1PH7ZFXlelPHN44wcqdKIJl9T0i6/Wum1TInSxG+
	 ZSZsxmXCdhJVPXHdThnaSyDDt2u71peiamZSEqY6gLonTeBQ0WFY50soQzUUJicTzz
	 MPh7O+LavbRkTb/62J64dXdsLOt6sPiyp7hY1N3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Jan Palus <jpalus@fastmail.com>,
	Johan Hovold <johan@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.17 152/371] firmware: arm_scmi: quirk: Prevent writes to string constants
Date: Fri, 17 Oct 2025 16:52:07 +0200
Message-ID: <20251017145207.433145473@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 572ce546390d1b7c99b16c38cae1b680c716216c upstream.

The quirk version range is typically a string constant and must not be
modified (e.g. as it may be stored in read-only memory). Attempting
to do so can trigger faults such as:

  |  Unable to handle kernel write to read-only memory at virtual
  |  address ffffc036d998a947

Update the range parsing so that it operates on a copy of the version
range string, and mark all the quirk strings as const to reduce the
risk of introducing similar future issues.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220437
Fixes: 487c407d57d6 ("firmware: arm_scmi: Add common framework to handle firmware quirks")
Cc: stable@vger.kernel.org	# 6.16
Cc: Cristian Marussi <cristian.marussi@arm.com>
Reported-by: Jan Palus <jpalus@fastmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Message-Id: <20250829132152.28218-1-johan@kernel.org>
[sudeep.holla: minor commit message rewording; switch to cleanup helpers]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/quirks.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/firmware/arm_scmi/quirks.c
+++ b/drivers/firmware/arm_scmi/quirks.c
@@ -71,6 +71,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/hashtable.h>
@@ -89,9 +90,9 @@
 struct scmi_quirk {
 	bool enabled;
 	const char *name;
-	char *vendor;
-	char *sub_vendor_id;
-	char *impl_ver_range;
+	const char *vendor;
+	const char *sub_vendor_id;
+	const char *impl_ver_range;
 	u32 start_range;
 	u32 end_range;
 	struct static_key_false *key;
@@ -217,7 +218,7 @@ static unsigned int scmi_quirk_signature
 
 static int scmi_quirk_range_parse(struct scmi_quirk *quirk)
 {
-	const char *last, *first = quirk->impl_ver_range;
+	const char *last, *first __free(kfree) = NULL;
 	size_t len;
 	char *sep;
 	int ret;
@@ -228,8 +229,12 @@ static int scmi_quirk_range_parse(struct
 	if (!len)
 		return 0;
 
+	first = kmemdup(quirk->impl_ver_range, len + 1, GFP_KERNEL);
+	if (!first)
+		return -ENOMEM;
+
 	last = first + len - 1;
-	sep = strchr(quirk->impl_ver_range, '-');
+	sep = strchr(first, '-');
 	if (sep)
 		*sep = '\0';
 


