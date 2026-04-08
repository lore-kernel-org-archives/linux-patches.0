Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CEE3D411F;
	Wed,  8 Apr 2026 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672793; cv=none; b=cSdsE25yoU2PhwAA+RwnzCed6SyJ5ZKZoaojmH2iCUmiJ9/fzXDPWZyTRuIxdEpxpztfsfEqDsDHaQmSS05uZhxVd3DFMNXpe+obQWaUwGumraTVe1jG50qdo0/d8HOC61PRdA1d2q9SEt58BzoZ4ZtFdXbgdjyqVhRojusAyHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672793; c=relaxed/simple;
	bh=dYNEHLZ+BOwDOjCQ+nyE5wRFnVBxmY29YysCVJYSkok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai/j/W/YRkBYvs27lvGb9LoSjzHzwy2ZDbMcTL/8IMsRiU/1UWHgavTwxzQyDWvFt1VaWfa7U7Xug6hVep0WuN6LX2ad7mJ5CV11n17tLU+EsHNoyu//p6roVWPqwfR6S2wcciOfRPbGwVn800CWS8wYJnxEDKNjMJcxL0dbHbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMrK3TyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMrK3TyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378BDC19421;
	Wed,  8 Apr 2026 18:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672793;
	bh=dYNEHLZ+BOwDOjCQ+nyE5wRFnVBxmY29YysCVJYSkok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMrK3TyPbM1TEq9qmSCVdj9jtgqM5vslKfIBUvtrJvWKTd7k97ufavPiH8arF7T4O
	 UU7BbH+S9Ax/b7nlSQGENfNAF5TkPnew1Qf4Yb2pr/WZjVFGyIgFz3TFahIhAs67Bo
	 kjIZlPlcxEkLMMsYNfWxKOsnamK8b5VpKgrm5izk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.6 145/160] usb: gadget: f_rndis: Protect RNDIS options with mutex
Date: Wed,  8 Apr 2026 20:03:52 +0200
Message-ID: <20260408175918.606535333@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


