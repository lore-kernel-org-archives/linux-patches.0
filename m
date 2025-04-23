Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A672820DE;
	Wed, 23 Apr 2025 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421605; cv=none; b=UbeoCMYKdUuRUxKz8RIZLy4HTLnROVLrBDucC1qJC7PPGS4pUDs7nAyYFLqgKDcGRFh4IAiH2Qbxc8JWMM3AcuOgH17viwU2qQAKyBOnqDHbwjAjkhQ2rLVCDpXg/hGkypS6eRg9ARZJJcZLPucPU80dhUYaWdKC2EITUhQGdNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421605; c=relaxed/simple;
	bh=4ICkZboolAGl3mV7W0WkcctPosBhQ5ekUkAUl+SNRwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKQHW2P1kQWCsGilyF4cRQ9FN+g0kreINsV8/kqfxMN5OdlQawer3mrT4FvVTpxTSz7ej6rgx14fCP0zxBDtLR36n8+UdikErgcsI4JpI5mA8Fy00jA+KSVvUtAq9YGgDwqMJIT4+hWeh9Tl4zhRbSFGEJCfayoOOGgYQqeE8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0tr3Si1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0tr3Si1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0D5C4CEE2;
	Wed, 23 Apr 2025 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421605;
	bh=4ICkZboolAGl3mV7W0WkcctPosBhQ5ekUkAUl+SNRwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0tr3Si1XtwOx3rrsPFCM6oP64UzVoE/hjGg6NH9wHzVhgy0KsPWuNmagrebNL97o
	 doA5k0RjiubJqXQIrGBqQmxwU1n1lZarcMlAjGa6qkkS+jYymr2+LOTDrsSxTxgqzF
	 7hYmjpu9IHsPpCmqYX9ddwQfOB5UaWjV/WDfaq8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 157/291] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Wed, 23 Apr 2025 16:42:26 +0200
Message-ID: <20250423142630.806511184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1141,7 +1141,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 


