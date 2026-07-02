Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE637353A68;
	Thu,  2 Jul 2026 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009529; cv=none; b=ZAfBq9TmOl5CXkNrSQCbD4C34N2xfacqbTtFQbSZkT+HD1h65I0zfdTlY6Vv9Ao24tUOe90hW3fbQRCheQ4cO5wnTyqKd2IZwiFdI4brieRsDihCn2WMLHrHRthyi8Q9AYUTdLK4K7vka9TyF0gVSQVi+nVvKpIUYHlCD1uif6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009529; c=relaxed/simple;
	bh=gmmMNhBr8L8MoY6sop4APG6j4qcgtkJMaAGC043VvJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9bHMX4b4rMbRJJYGZvIvq5GeBVd9q6554PkLLxKLuPuK1YZoE6MIr0wOy4VsdDkHnx5vw5WAyheUPcBcuqif+xUn3Ryo69sJkm+iN4BhUNNsdTXERZmQh2aX0d1/DY4slwHE1orzZ/DAweseMdQkYnP4RxvDLgnMISil9VrFdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXS7fdPy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXS7fdPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B2C1F000E9;
	Thu,  2 Jul 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009523;
	bh=Oo6yQZW3bDa1EHvXy2TJbAT0y4zwv7oOouUJavYUbGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXS7fdPyHU4LQFje4PJuPED4UvJRmm22lf2f7w5w6OCDQSK1qQXL61puHfRDW7J5m
	 lWU5BXOJEj14Eu6rD7cuBrXfdinmk1QnuJ/zJdozahLLxzlt98Nq1GeQAGwIZ0WAyk
	 YWiKT9ZM8qaos5RLivuGcF7Tay7380+y0UVxnUaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>,
	Peter Chen <peter.chen@kernel.org>,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Subject: [PATCH 5.10 83/96] usb: cdns3: gadget: fix NULL pointer dereference in ep_queue
Date: Thu,  2 Jul 2026 18:20:15 +0200
Message-ID: <20260702155110.723759989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2587,6 +2587,9 @@ static int __cdns3_gadget_ep_queue(struc
 	struct cdns3_request *priv_req;
 	int ret = 0;
 
+	if (!ep->desc)
+		return -ESHUTDOWN;
+
 	request->actual = 0;
 	request->status = -EINPROGRESS;
 	priv_req = to_cdns3_request(request);


