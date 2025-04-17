Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF292566DA;
	Thu, 17 Apr 2025 18:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914957; cv=none; b=n/DXjoqbgvu+pJs6JkGCuBCkTHNLjZzjz6eV/zhVeZOnzDRz81OdinROCBe+Rx6DUHeIY/5ELEkwR9r0kPyfpEwr9Lexdc3YQMX0fNCufUYk5HN5PrqzxWqpL1M1IOFgMdGMJCSBpWLxlPYKwv/3m0a6Yzl5asf7ytsfgeDckZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914957; c=relaxed/simple;
	bh=tDxdwMH8UPD3hlr8HRcqlTthAQCmUWLFJKhTTIwb76E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AsuupyCQ6uKmODBRQDb39cEu+8ruuXOGhDEHWfYvCqbLhHAC5qHliX+V9s15+yy7RehGt1BiiiNt84iWWTDN9n810TZSxlzlK6yQkJqf22ZZbqulpyNIP2PyFdcH45FGn8fO0bYJnArRDQkKR4KSLUSXspM8KdWexeD9Efjwrf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL+/5PaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL+/5PaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163D9C4CEE4;
	Thu, 17 Apr 2025 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914957;
	bh=tDxdwMH8UPD3hlr8HRcqlTthAQCmUWLFJKhTTIwb76E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL+/5PaOkFWadVNrXC6dh0HmbZ3P80CM7J+KXQ2z3e+LkBQm7IDPqRuId0phtWKk7
	 Y06bw6cBEll77dvMWHtyERfoy7WP1Lq2nx20GZABf8hbfx6psmI0Zoxb5aax44jG1X
	 uBvSPRGbV/TM184SFYBvTKSGmVLhUTCOoHaGJXf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.13 387/414] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Thu, 17 Apr 2025 19:52:25 +0200
Message-ID: <20250417175127.049039661@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,7 +1173,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 


