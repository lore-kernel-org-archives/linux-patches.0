Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD0E35AC03;
	Fri,  4 Sep 2026 05:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501287; cv=none; b=qs2y+x0Jv5sedy+b8vZU9wAdyrbohJoRL8+C5Di8jefe7jk4jrQFQFNJbJQvzLhLpb2fMDj/VVZKKb4/BGNxiCnV6qZzSen8kMgNrH3lO5mP414D2lDyj/C7XwuZ4r564hhUefJbaHCSYL6kQnaDNwHbaNHtr2Efmdqrc3Tfmt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501287; c=relaxed/simple;
	bh=FIf9MfojiJm0A03GN4x9G7/TskpZzqcfrYp0np9ZG18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMbBpr5fhUKS6+DwyLahRbp9f/JiLH+sIsI00MDHZdxtn+Q+XIXH7t9fN6jdGpdIk3TQNB61ebpM8ePwbImPliL6yW1x57gPajaTjUxC7m0ca3vRkV/25ZJygV0j0HPVXrW0JxRD57HdA5TeFsVzSYtSXYH8TmGNcbRNTNlOsZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxMk3DVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxMk3DVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A3E1F00A3D;
	Fri,  4 Sep 2026 05:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501285;
	bh=/UeqP3lWN1tqk9T5PNhwkejKapdQAyD4DpEL1OTbV3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxMk3DVht1FiTbST3k4IwbCGkhvF5HOzuF6bE+LQvBSxPE1Rb9rMpDis8FyHY9TXI
	 F6ZM66qN7gaznwJxQn0c8irwegIDIW9NDtxJW536xECZMiQrCW0qtiQ43c8qPzQD/l
	 BoU7tTYheC57g8lOvf9hWONYy+nJi7A1R1mZY43Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 357/552] nvme-pci: disable controller on admin queue IRQ setup failure
Date: Fri,  4 Sep 2026 06:58:34 +0200
Message-ID: <20260904045758.332836237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2161,6 +2161,7 @@ static int nvme_pci_configure_admin_queu
 	result = queue_request_irq(nvmeq);
 	if (result) {
 		dev->online_queues--;
+		nvme_disable_ctrl(&dev->ctrl, false);
 		return result;
 	}
 


