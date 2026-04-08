Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EC52494F0;
	Wed,  8 Apr 2026 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672701; cv=none; b=R0XjQ+qrK3L2pblugz11USi82L+gUT4HID3QXUff5B1c3LB/JI6c8pIXNHkCv8EL2sIIeCNxpCeDfvnuTcCweiEMKsQt2a8eqTXlEM7tJOJGmFIHxxgAMIQ+RQdifaJnlkj80kP+OZwsJqEnp7/GEg1CDKmB6tNGDd/DjLERli0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672701; c=relaxed/simple;
	bh=pHlBawm3uyoyS1FhOR3I8F5vOBuTdsatS6xI6Wmb3Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEXCd1QZhtxum/S1DPlWKLLwzxiYA42x4ICnDk8y2EJ4vY5TgmtYCC9EO78bH+Pber3Ya953iifcWWiGZk64oIoWe50yn79oABKQ1+8OMObVG2sg2YhrA3qSruLjyws0mfIO7DLOBAAAJ//8lSu1tjcawI2IEIPQi8u3U5e79aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASHeZ13S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASHeZ13S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E40C2BC9E;
	Wed,  8 Apr 2026 18:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672701;
	bh=pHlBawm3uyoyS1FhOR3I8F5vOBuTdsatS6xI6Wmb3Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASHeZ13SW8yv6nYou/m0G4lBVzAPc7RAeu02RFX7tSe1Pj4JvGbXiK3kMUviuhwtq
	 qm6oKcLl782nHnevX7Y6ZW9Wry7LMbCeHrHqziW0j8JDJ5v92EsRJEKYC5JQrsi0I/
	 tN/66TiMsEkaIGqN2hbyA306sh8Rnijpwzdnp57A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 109/160] usb: cdns3: gadget: fix NULL pointer dereference in ep_queue
Date: Wed,  8 Apr 2026 20:03:16 +0200
Message-ID: <20260408175917.251454433@linuxfoundation.org>
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
@@ -2588,6 +2588,9 @@ static int __cdns3_gadget_ep_queue(struc
 	struct cdns3_request *priv_req;
 	int ret = 0;
 
+	if (!ep->desc)
+		return -ESHUTDOWN;
+
 	request->actual = 0;
 	request->status = -EINPROGRESS;
 	priv_req = to_cdns3_request(request);


