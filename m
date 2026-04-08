Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52933B19A3;
	Wed,  8 Apr 2026 18:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673567; cv=none; b=IBdlCoaEW+Zqq3EO512PjU43IzhnUimlf9hd643tbaij7F0iBPnttNJqxIJycrJrnzKXuUfMuN83p+zciRO8roqSumOYjaG693K2ztm52Po3zhrCeBQiZOXx2Uxg+6LZDm+yo6yXUNFGzz3Jykjwq/rlgnasV23Bcc1M7SpNpKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673567; c=relaxed/simple;
	bh=1qDB07Rpk87GRL7pUnxa9NZitR5CAhMM3Evbzf8l3W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYF2mmFUnWGynzp2C85BC1evjhQfPYmNtAvrSk7Wv39IHotttU8piGRQZhpUBi60/eN6XHtoDOc/W3QXSTzMUy9KEAmPEpEpQNgYMIx3i3aoZq9VWqOl9oUwJy1IpmhX4uP8srj7gu64pt9xPjjVsiICCryYzxGz1oJpoAqZpW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAZW9ogU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAZW9ogU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4A0C19425;
	Wed,  8 Apr 2026 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673567;
	bh=1qDB07Rpk87GRL7pUnxa9NZitR5CAhMM3Evbzf8l3W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAZW9ogUNdiGnNU5iH2G8IBYEMDfYOdi0WUoAVdb42VFxwZ8W7mKl9FORQs6WaVo4
	 5kKpHR2IdRhTU+AaoXxgGy3ecLqn86zis824M7yq4fZHpS4fD+WCZuT4WkakQJEyI8
	 QQphfAEHK/+BWCiEsErh2MprXmSrQS0WwnHex3pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.18 256/277] usb: gadget: f_rndis: Protect RNDIS options with mutex
Date: Wed,  8 Apr 2026 20:04:01 +0200
Message-ID: <20260408175943.416291850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -678,9 +679,11 @@ rndis_bind(struct usb_configuration *c,
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


