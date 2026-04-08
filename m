Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2623ACF11;
	Wed,  8 Apr 2026 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672393; cv=none; b=Rk0FpzAGV64AfUSd+zP1srZcv6Fq83YxcnaB7b+9Jhsi2bdG5kGxz/G5rgjh1kjqmnv/QQs7jTIQsMsAiMFTRF85Me2gejYQlE0RUxpQuER1MTUH5NwnDPUpOUgv7q/mXy4wzjvi+z4dDgydG05cqVDNnjUJeGk/xIOfRGV+QgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672393; c=relaxed/simple;
	bh=JyaQPQBEZtihuo2ZLR6HJD+hKa5nVKZrEj6K8U+IhKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T42EDWCioLa43mTJGFJeMyQgzgVu/d1USVlz49DERL7eHfzSSI+NA514b+Vk8tTIHGX/nVcDxtWpy+UGwcdgqssc0XIE0Ld4yZXACEyF2nHaeIfUCuPFd3bdKJ8DkXlHh+j2isXnWQoW9e6xU5qzbSjbLTE7NVKtcUnG4tIMviA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjkkmcvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjkkmcvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA198C19421;
	Wed,  8 Apr 2026 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672393;
	bh=JyaQPQBEZtihuo2ZLR6HJD+hKa5nVKZrEj6K8U+IhKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjkkmcvFsObQBPmZBkgWBfNJ3fR9wMdRzVlbTA3pMmYFF6QsLnmsIGOqzwn9SVKYV
	 eIXGVbsLIVe0viKK/Xfhc9tq7C8meqsTuhwWTb/kh26d0N8tz00TYBIdTZ/89gWt5Q
	 2BXNx3smC+zhcIshAd/2mqkb84q493wvgh3uHUL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.1 270/312] usb: gadget: f_rndis: Protect RNDIS options with mutex
Date: Wed,  8 Apr 2026 20:03:07 +0200
Message-ID: <20260408175943.832590256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit 8d8c68b1fc06ece60cf43e1306ff0f4ac121547e upstream.

The class/subclass/protocol options are suspectible to race conditions
as they can be accessed concurrently through configfs.

Use existing mutex to protect these options. This issue was identified
during code inspection.

Fixes: 73517cf49bd4 ("usb: gadget: add RNDIS configfs options for class/subclass/protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-2-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_rndis.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -11,6 +11,7 @@
 
 /* #define VERBOSE_DEBUG */
 
+#include <linux/cleanup.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -691,9 +692,11 @@ rndis_bind(struct usb_configuration *c,
 			return -ENOMEM;
 	}
 
-	rndis_iad_descriptor.bFunctionClass = rndis_opts->class;
-	rndis_iad_descriptor.bFunctionSubClass = rndis_opts->subclass;
-	rndis_iad_descriptor.bFunctionProtocol = rndis_opts->protocol;
+	scoped_guard(mutex, &rndis_opts->lock) {
+		rndis_iad_descriptor.bFunctionClass = rndis_opts->class;
+		rndis_iad_descriptor.bFunctionSubClass = rndis_opts->subclass;
+		rndis_iad_descriptor.bFunctionProtocol = rndis_opts->protocol;
+	}
 
 	/*
 	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()


