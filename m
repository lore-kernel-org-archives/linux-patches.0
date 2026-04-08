Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4483D525E;
	Wed,  8 Apr 2026 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674961; cv=none; b=EotVgabT0aoAEM3ZTl+ap0suU+2LIHj8DGpsX2mk6iv+xRDfSZ7jFguMkntNulqRb5P0AXHdEcmgNZlfySHygL1w9LyYweiI+LqYyWnqC4w2YTy1Xs4kSLu3TWme4H2OqcHgJjrM6iGOw7MPN9VY6Wv6pt1e/0vpuGtudNSED6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674961; c=relaxed/simple;
	bh=657KaEB+fmAfNnP+VOLWwtIpbC7vePgFcXINNh+ix3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuSEb8gH+eU2AztuhoS2sRUbQn+rF6CISP14yFh8v+VEbFuYMG2ZIzXh0Rv7UI5pvOhr6OzIrekJyfQ1GdsRYG7e+6haP+CxFNFEmy2HqOXxh+P+XFKW9Hc4HpD/29XZWLm17PfBtmftM45HEAHAGmRZR7TgFkt5dz2ozi6rgsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tH3ldV0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tH3ldV0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED9C19421;
	Wed,  8 Apr 2026 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674961;
	bh=657KaEB+fmAfNnP+VOLWwtIpbC7vePgFcXINNh+ix3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH3ldV0IAFdJDMLXzGOgf8VaKxBdsxg/Mob05NiK4n2jrNck2AnDRDAo3K/Xc6BkR
	 1VbA3jUYiEylGPkJ1Qa9R9NLs6XYqs395KP7d4pN9cQ/AV2rsd+lbvk6aFP4liW0i/
	 AUhnLywI+pfViIQLjetFsZjemlJ4XXuaYaTjjuaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 300/311] usb: gadget: f_rndis: Protect RNDIS options with mutex
Date: Wed,  8 Apr 2026 20:05:00 +0200
Message-ID: <20260408175950.572575875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


