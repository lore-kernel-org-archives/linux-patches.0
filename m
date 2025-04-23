Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB73F289346;
	Wed, 23 Apr 2025 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421815; cv=none; b=BDKxH/tneLlOLXhGsRhvNEhzqGr/6Qoy5kn2yVUF7aYObwswUSMn5cv+WBJC9fL+hLGoJcMVPHTfvmQYT2KysLmAzr+7UxCBQGsB6cbn8BejlQcDDBwHD8rwmKohbsoHdm858k5UQsGoCviZ/fw3AghQVXCOO/hCooEAR3Y1qCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421815; c=relaxed/simple;
	bh=AuRUvJiP+ctAWUVwwVea6LAlrXm6kQiNKpC7vswMG64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aG2FPY3ix61b17/1LZQYmQm+O7uI1ns1tJX4OlfEOwcE2T8zKtA1Rrf4Nw7M1HWFAegZTCS1JPuv3DVyWdQ9lKb2IPe1ahRTCt9J1aafZxnhle5pN6XmDIEe7ygv+36HxUnisbobHE4ki97c+0nGmlUFFEd/HKl+XFuGmwHHEBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De6sj7sX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De6sj7sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAABC4CEE3;
	Wed, 23 Apr 2025 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421815;
	bh=AuRUvJiP+ctAWUVwwVea6LAlrXm6kQiNKpC7vswMG64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De6sj7sX05MDrHzxEkRsyikhi4Hfg7P8KMi8YpfCcO/BVr09m1PJ9R1AnMhbtmLEy
	 bpObD94maiWLuI1E75Kulu4fNDlbPL+9o8KohF2auqQkdrRmgyR3JirRpxAc5brvqy
	 lpqyxDbq1wHv3+P6hMc/+3nGNnkTkd3anoFxS/nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 227/393] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Wed, 23 Apr 2025 16:42:03 +0200
Message-ID: <20250423142652.766726275@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1145,7 +1145,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 


