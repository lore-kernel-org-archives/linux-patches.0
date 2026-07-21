Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469C735C6B1;
	Tue, 21 Jul 2026 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668445; cv=none; b=mYVFd5H1CsfG1VekBlUsB2dnVaRKfe7zssQDrDe7vAxnFLUWwikjNnTvJSw9HWbv+8l3Eod+QWKElpjZ36BY5/vkhnkWoOYZegN/zkeeuXMYvlYS+icVukD4u7CWPdhPl9KBCEU0tGfzcMYU7F1iPEsDgn7TbFwQE/qFJQB7Izk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668445; c=relaxed/simple;
	bh=7b2Ps6Cti1SgPs39WYJWEUUsXcEJfpnY4yWX1dSMwkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILf2Ut7zr8xL2tLvSEMYzXrfZXbm/hY3+nPEonqNu3hc5k2BdabMY8rtKQ8Wy1qriXC6QiBOT6VIXJFKjE7A+eVtp8AXwUyqajpDxHrZWni+eQTeACkkKLxOu+vfxNtrC+Ut4ikSolKnqAuUdKeFvSMOQw+qecgdxRb/PgDAaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYN70Jc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYN70Jc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5D11F000E9;
	Tue, 21 Jul 2026 21:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668444;
	bh=8lwJO3OIYm9UGpC6/JDtz1JoD+arrMgDZDmvZg3p6sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYN70Jc49hxoGjqavr3+1Kn/N/jBOqPAJXVy1+QybmY5KDpNgdOb50+mo8qwpKAzy
	 QM7ePR36Hc8iNQ7OVF8EO9XJRA64LqIagRcGq2ZDswwsvCerEqstJlieXPTKhgIDPY
	 7MEEtXFoIllecJNkrWsVCVrr7drdY0Rusg4BQKx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.1 0177/1067] usb: sl811-hcd: disable controller wakeup on remove
Date: Tue, 21 Jul 2026 17:12:58 +0200
Message-ID: <20260721152428.550668905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 4e8ba83ac4d311992e6a4c21de5dd705010df06e upstream.

sl811h_probe() enables the HCD controller device as a wakeup source after
usb_add_hcd() succeeds, but sl811h_remove() removes the HCD and releases
the driver resources without disabling that wakeup source.

Disable controller wakeup after usb_remove_hcd() and before usb_put_hcd()
so the wakeup source object is detached while the controller device pointer
is still available.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 3c9740a117d4 ("usb: hcd: move controller wakeup setting initialization to individual driver")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260701121625.96815-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/sl811-hcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1590,6 +1590,7 @@ sl811h_remove(struct platform_device *de
 
 	remove_debug_file(sl811);
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	/* some platforms may use IORESOURCE_IO */
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);


