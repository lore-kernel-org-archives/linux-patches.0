Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A575280CFB;
	Mon, 13 Apr 2026 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098409; cv=none; b=kJP+yTDhmbnOLlXJL/5kaBOMcziS1mZi2AnD+/zeZvJU/+DOQRvw8/30MvIki0v6OUGqXX/XcoseiMOYdeTaJ/6YVCkEqw9Fczln5dUkeaivavDOeSnSIoL02IYA2Nh3gN4JGqbADYREnlFNRHX/gg2WIGxZcc0h/v545+K+5tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098409; c=relaxed/simple;
	bh=ZMyOFxb/H02oC0QYjNDn/DRiUaTZrKKqHWUhvvcL7o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oga9Y3A35jJADSvNNy0W23FitnTcBJBpfTKlFtkJkgqQBQXdpzZX/ZTyugDTzR3MxvH5gfxzSaO/FPbLtPaE9knCZaODGpoUbOObUG5nBMhgdMpp0C5EB1gbVpCYZEYsQPxdqCExH2CLcIBmLdLMhliz0R9R+W4SynjMbVJmqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KraxRbgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KraxRbgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45A2C2BCAF;
	Mon, 13 Apr 2026 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098409;
	bh=ZMyOFxb/H02oC0QYjNDn/DRiUaTZrKKqHWUhvvcL7o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KraxRbgZGt891iAengMgB2S8ggYx2dhNiLpR5rM+tXPzwO8/+aKfHNTYvWBdffSu2
	 Gfewg+XrANlnlL61/p0+CVqZfb+KEvWdZacqyHpGv5CPUU/k4t8pqWyvItWxUGC1oo
	 VpmU1TSqbDqcJAgKYizZY2Lxbkh6HvuQvK5TjXJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 471/570] usb: cdns3: gadget: fix NULL pointer dereference in ep_queue
Date: Mon, 13 Apr 2026 18:00:02 +0200
Message-ID: <20260413155848.108353420@linuxfoundation.org>
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

From: Yongchao Wu <yongchao.wu@autochips.com>

commit 7f6f127b9bc34bed35f56faf7ecb1561d6b39000 upstream.

When the gadget endpoint is disabled or not yet configured, the ep->desc
pointer can be NULL. This leads to a NULL pointer dereference when
__cdns3_gadget_ep_queue() is called, causing a kernel crash.

Add a check to return -ESHUTDOWN if ep->desc is NULL, which is the
standard return code for unconfigured endpoints.

This prevents potential crashes when ep_queue is called on endpoints
that are not ready.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Yongchao Wu <yongchao.wu@autochips.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260331000407.613298-1-yongchao.wu@autochips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2586,6 +2586,9 @@ static int __cdns3_gadget_ep_queue(struc
 	struct cdns3_request *priv_req;
 	int ret = 0;
 
+	if (!ep->desc)
+		return -ESHUTDOWN;
+
 	request->actual = 0;
 	request->status = -EINPROGRESS;
 	priv_req = to_cdns3_request(request);


