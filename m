Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F9937E5D1;
	Sat, 12 Sep 2026 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220540; cv=none; b=sGGTQe4knwm5J1JcD2L5+U9SaL5xZs+AdRJ9Xu0wC/uDiJScgFy+bz/MMmHMknJU6CytxcIVtZzjYgY+Hocm2j+ESDvnsTBLsOrT5mplcNzXV3rcKQ7BxDqLVjIxNu2NZuPRft2V1WOyxlTXvFcoqICseTuSSNn4E+BkzYQmcbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220540; c=relaxed/simple;
	bh=etVlb8tSwKeczbowE4y3FPmAwm08jtQWASxJhfUw1RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljg37fAB3cipQSZzRrfP7YAIPaWSMSwS23gzmZausJl2lqVRpq0GkrhFzC6jKrm00KFN1ivT6tAD9Nw0KAQMes6B1mkTgYF+tse/0wLQX8zrYuOnQzK/oJVHA2fYht2pe9k9sp4y7TQArbf/pf0Fs918J9/M06OyFmznnOWjmos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSalPGv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSalPGv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00571F000FF;
	Sat, 12 Sep 2026 13:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220538;
	bh=uP46/ONE98g2gngEWbdOAd/prUW9H/O5H/4w7rR9qQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSalPGv5ykFy8lApt+2QF1HSbuiTFMwNQDCBlEi2hFuuwmBvlLeGNpvOe82a0QKRX
	 GJQI/f2pphDdlv1ZSIlzt5sx0GH/GGg2yUPI2otqNhPc/PzmX8YjtC+cEefm0dxgL0
	 q+pJKH3ZNkRHrZzIv/seDoJmjnpAX25rBj6qB9qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0197/1424] nvme-pci: disable controller on admin queue IRQ setup failure
Date: Sat, 12 Sep 2026 08:43:49 +0200
Message-ID: <20260912065611.701124491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 08660a5c8d497f43191635d97efd31cd35051f15 upstream.

nvme_pci_configure_admin_queue() enables the controller and then requests
the admin queue interrupt. If queue_request_irq() fails it returns without
disabling the controller, and no caller compensates: nvme_pci_enable() only
frees the IRQ vectors and calls pci_disable_device(), after which
nvme_dev_disable() treats the controller as dead and skips nvme_disable_ctrl().
The controller is left enabled (CC.EN set) on this error path.

Disable it in the failure path, while the PCI device is still enabled so the
CC.EN clear handshake completes.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: b60503ba432b ("NVMe: New driver")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1843,6 +1843,7 @@ static int nvme_pci_configure_admin_queu
 	result = queue_request_irq(nvmeq);
 	if (result) {
 		dev->online_queues--;
+		nvme_disable_ctrl(&dev->ctrl, false);
 		return result;
 	}
 


