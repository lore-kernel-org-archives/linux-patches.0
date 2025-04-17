Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A561256C7B;
	Thu, 17 Apr 2025 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916165; cv=none; b=Lku5ZuwJg3Dzz5Vg4XEYersx2nq3qMLYS6MuaTxonoxE6hrDZXzASurSVJv2liM2XIsaaCzUd2UHU9GgZLZmqBjS5oJmaWX0h30rY5zS/UpPO41j/xhVBePFQfD3ctVljiD8jrIvPbJsQN/mJbl3aJ4wxl8hs8abGhgvZddhQVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916165; c=relaxed/simple;
	bh=M722A4uNiVKl6jx6v50zrpzB4sZCP3ug1LGXxDaIX0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugnq9vFIjtbYxci8mshYgbkT96WBkPxWClRkuXHpK0NxbrccoPsLf5XzxEFeqMNY0YADk05pI+K5/Ahy+AjZAMETtE6NBfBmdA9yFHkvxbXZjXD8ogk0Ycj3LlMtWuawvVxkqV+2B90m72P45doU0Z3r7fT3ORQ7dDx4akgWLaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjV6EpYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjV6EpYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13785C4CEE7;
	Thu, 17 Apr 2025 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916165;
	bh=M722A4uNiVKl6jx6v50zrpzB4sZCP3ug1LGXxDaIX0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjV6EpYD3naLE4VVNfi7qD0c4OWlqV53d87GKwR/W7IVPHflra2rLVAX6jRMgCsZN
	 8kuDAuvFYmZh3nqRUzs48XeXOKrPTr6KqA+V2CNYJn5fCw1a9yFFfcvQUklEQbX9SB
	 XzfMpw/AxHfPXJuyxiPQCQz1aB8FyJmf38dlVU7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 365/393] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Thu, 17 Apr 2025 19:52:54 +0200
Message-ID: <20250417175122.285257787@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1f2768b6a3ee77a295106e3a5d68458064923ede upstream.

If device_register(&child->dev) fails, call put_device() to explicitly
release child->dev, per the comment at device_register().

Found by code review.

Link: https://lore.kernel.org/r/20250202062357.872971-1-make24@iscas.ac.cn
Fixes: 4f535093cf8f ("PCI: Put pci_dev in device tree as early as possible")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1171,7 +1171,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 


