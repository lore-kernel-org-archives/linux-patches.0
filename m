Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A8F1D5AD4;
	Mon, 13 Apr 2026 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098375; cv=none; b=K77zvh+c5/l6hoLTG5pv0J1sAUdmWsXNn68hUWXb5Sb1ayHtNEG8BXWu0PDZ2Zlt1JvsMcy8w1y8tt2ZPK1jlk1DMPdqK6fg+waq6Fx1Ir9VYfnq/TJX745SK8QxZk9ynN3tO3FPB3MSOl1hlvvnBG/1pftLBoYQwm3lwUxkdGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098375; c=relaxed/simple;
	bh=5QUNUN2dGUR7+memMa2jET3f/Cd1DFDvBtEimAQa5gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taAsIfxE8wRP0JsUCvF/smejrKh9cFHy9I0cK5GfYnbRdr6nCAkwp0J/BR+7ewjVVfcwyPpVI6/dAzkXYbkUwVDcNJuIcMXYl5SgoTYdXsDGShV0T7D0ZcIqhbAvqH3q3oRNMMJDoTU9bNtTqNNNIjZnHAVW/2XyKV2lrtDdcJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irT41X1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irT41X1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD526C2BCAF;
	Mon, 13 Apr 2026 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098375;
	bh=5QUNUN2dGUR7+memMa2jET3f/Cd1DFDvBtEimAQa5gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irT41X1kFnKsU2HTAKBkgyM3mWeapseay/9Yhqzp9lyuLSQN4LMC10n43aVYq/uaX
	 Ipfu1v/vy9QkVySCf3nY/BSm1WjcZ2W7EWYA2wG3L0P/Mt43GMsyYIm3LBwD5SY11C
	 +XCD37iri9NXYI9Cq9al2ZCeJNmlN8Zl/3gbrd+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 5.15 500/570] usb: gadget: f_rndis: Protect RNDIS options with mutex
Date: Mon, 13 Apr 2026 18:00:31 +0200
Message-ID: <20260413155849.184853201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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


