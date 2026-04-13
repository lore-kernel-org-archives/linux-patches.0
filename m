Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66900330B3A;
	Mon, 13 Apr 2026 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099620; cv=none; b=Sb6W0ymGH6bQ4zTdtmLFG3Ec46vzEzQ8vuiaddvNFokriBh1zjYSL5mnKccIK/GmTRsZwCEodgEHolxf74K7YX6H7GrJSb7jpuAM0AMptUrKC3i5wfJQV2Lo2DZqZHCcznp6HNRFJRDxYUZCmxozWMVsXZGrzPu2UYExAp/PDmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099620; c=relaxed/simple;
	bh=GlST++QGQASoBg0z9pQe/NPG2JiZ7AAZ7keINVPGlYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuC99CmzwW+gEdabgj6ogtQFixiG129W4KqwM38CrfDePVansjmgnApS/qU52dwwQrmJ5MAMHVgR0FJPgA8eBIWMuJTjs7tCCWNGnYjrX4oV9DRFJ/MS/HAKn1IVKRpOmsl6Cb+mqod0ddVBmGOMVsFEGlhvfA5WG1gceEyJ+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdJytzQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdJytzQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4B6C2BCAF;
	Mon, 13 Apr 2026 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099620;
	bh=GlST++QGQASoBg0z9pQe/NPG2JiZ7AAZ7keINVPGlYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdJytzQzcm2gGSnrpX6O+DxVJOBp2b/e9CJJ4mOc8AjG0t8mTgrdHEVcSGBvrHJIm
	 Kf0HqWQiqSmq+Hbak6HIZ/BYmjzcc1ckYZslnO5vyODn1LnYeahZaxtYAvTC3Zv9sB
	 Ktq6PlT+LJvG1yd0snOJg6W/SwLLT+QDtQt05qLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 5.10 410/491] usb: gadget: f_rndis: Protect RNDIS options with mutex
Date: Mon, 13 Apr 2026 18:00:55 +0200
Message-ID: <20260413155834.380566944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/gadget/function/f_rndis.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -11,6 +11,7 @@
 
 /* #define VERBOSE_DEBUG */
 
+#include <linux/cleanup.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -690,9 +691,11 @@ rndis_bind(struct usb_configuration *c,
 		f->os_desc_table[0].os_desc = &rndis_opts->rndis_os_desc;
 	}
 
+	mutex_lock(&rndis_opts->lock);
 	rndis_iad_descriptor.bFunctionClass = rndis_opts->class;
 	rndis_iad_descriptor.bFunctionSubClass = rndis_opts->subclass;
 	rndis_iad_descriptor.bFunctionProtocol = rndis_opts->protocol;
+	mutex_unlock(&rndis_opts->lock);
 
 	/*
 	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()


