Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1182E366831;
	Tue, 12 May 2026 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609533; cv=none; b=YKdfZBOD2DvzZ+xIRUwW7zAs8xTiQDDHuUmhrzIsD8kir3Z3Lrq23abZJYhMM/a+qOxfoXVB8PIDbbOeuVUiMTPFvkEV0rnHdm74rvSn2QW83T778UB9S6poanq/mq20mMNq6gmuA9xwnM0NYZFKY+81rGtnZ0zSzSSnBb35+B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609533; c=relaxed/simple;
	bh=NZH3C4qoJh86SpVsUEEq/83wWHOgTyHQjvwnw1KGBgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MysBbQJQQil6SZ7DsgRl7NQuI7L6G3jZDE77SX8LsZ2FJUeS+Zid/tpJ7CAy3M0FsvUa4bRaUjcZ3Y6es7m998HGQqXaeedcWaXtSRR+JpheWoQRs6/ZiLzyLEqXqyMaPdovQ0NCkG7m6o+w2pdMRvlRotLCXKVpnZp7NLaRkuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWpwfBJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWpwfBJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D317C2BCC7;
	Tue, 12 May 2026 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609533;
	bh=NZH3C4qoJh86SpVsUEEq/83wWHOgTyHQjvwnw1KGBgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWpwfBJ0359Cc80N9POJRgGE1d6VYw/Ps++/pK61Q0j4fJEGFUJ9YY1ZHHwUfWj1L
	 M3Ec21f+fTtk46tyaWhWG8qB1c5Sl4blxO1CFWjL9KQLr/L3RNHbZZUYD03x9xsWMO
	 WdcW1A4RhbL6+1ycLD0+8YZICBMYiJXcn9KHw8XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Aizen <kai.aizen.dev@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 231/307] RDMA/ionic: bound node_desc sysfs read with %.64s
Date: Tue, 12 May 2026 19:40:26 +0200
Message-ID: <20260512173944.994826403@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Zen <kai.aizen.dev@gmail.com>

commit 654a27f25530d052eeedf086e6c3e2d585c203bd upstream.

node_desc[64] in struct ib_device is not guaranteed to be NUL-
terminated. The core IB sysfs handler uses "%.64s" for exactly this
reason (drivers/infiniband/core/sysfs.c:1307), since node_desc_store()
performs a raw memcpy of up to IB_DEVICE_NODE_DESC_MAX bytes with no NUL
termination:

  memcpy(desc.node_desc, buf, min_t(int, count, IB_DEVICE_NODE_DESC_MAX));

If exactly 64 bytes are written via the node_desc sysfs file, the array
contains no NUL byte. The ionic hca_type_show() handler uses unbounded
"%s" and will read past the end of node_desc into adjacent fields of
struct ib_device until it encounters a NUL.

ionic supports IB_DEVICE_MODIFY_NODE_DESC, so this is triggerable by
userspace.

Match the core handler and bound the format specifier.

Cc: stable@vger.kernel.org
Fixes: 2075bbe8ef03 ("RDMA/ionic: Register device ops for miscellaneous functionality")
Link: https://patch.msgid.link/r/CALynFi7NAbhDCt1tdaDbf6TnLvAqbaHa6-Wqf6OkzREbA_PAfg@mail.gmail.com
Signed-off-by: Kai Aizen <kai.aizen.dev@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ionic/ionic_ibdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -185,7 +185,7 @@ static ssize_t hca_type_show(struct devi
 	struct ionic_ibdev *dev =
 		rdma_device_to_drv_device(device, struct ionic_ibdev, ibdev);
 
-	return sysfs_emit(buf, "%s\n", dev->ibdev.node_desc);
+	return sysfs_emit(buf, "%s.64\n", dev->ibdev.node_desc);
 }
 static DEVICE_ATTR_RO(hca_type);
 


