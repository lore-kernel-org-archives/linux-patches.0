Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3102F12D9;
	Fri, 17 Oct 2025 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715660; cv=none; b=V92lTV3PrRpKp8Y91VaGtemV/zkHXM+pCErOojvJrSWDx8MNG14fY4a45Lwgao/vecfwfeq7WCHtwA3GItCnlcXdpDBVP8DuKJbQVlVaG0cqoIs09OeXBclSXAqy/NqGwUoIlrlnPU3VS/tKc7utPEvTY2xv5ulI2wtt+ce3U0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715660; c=relaxed/simple;
	bh=4L2ydP5Kal7gpc3kgKaMD36vglgRqtjmxXsiRkpFv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnoQ4JnM27l0iBp95I5120USnkXUPSftmnaQzktjSVD1bDDREDNj3fHUmaB6Y7lJhLTmGXmuY9FpBHRFePwYUkM+4V86KOXNGzzT4ownayJK3h6zrr4Y9q1DvrQD0BBlNXe0GjjV5z5gusZVeUwBuIGhQixBfe9WecoAqo/JpMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFKgqWrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFKgqWrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3631EC4CEE7;
	Fri, 17 Oct 2025 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715660;
	bh=4L2ydP5Kal7gpc3kgKaMD36vglgRqtjmxXsiRkpFv4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFKgqWrZthOuR2x+eYKkgK+6uBajoojPslSMNSK7ysAZeFWQWGQIqaY1VCr/rkCCs
	 8HySrmCAZwhEBVLjY0u/gU264X8U+2UhznvRxGplNvYm1jqJNoUl9XMD4oKPw/xvZf
	 8RZCoosOILQC8zkh+QJYNBN38KZgsGhNnA6V3sXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.17 293/371] PCI/pwrctrl: Fix device leak at device stop
Date: Fri, 17 Oct 2025 16:54:28 +0200
Message-ID: <20251017145212.674113730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit dc32e9346b26ba33e84ec3034a1e53a9733700f9 upstream.

Make sure to drop the reference to the pwrctrl device taken by
of_find_device_by_node() when stopping a PCI device.

Fixes: 681725afb6b9 ("PCI/pwrctl: Remove pwrctl device without iterating over all children of pwrctl parent")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org	# v6.13
Link: https://patch.msgid.link/20250721153609.8611-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/remove.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 445afdfa6498..16f21edbc29d 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -31,6 +31,8 @@ static void pci_pwrctrl_unregister(struct device *dev)
 		return;
 
 	of_device_unregister(pdev);
+	put_device(&pdev->dev);
+
 	of_node_clear_flag(np, OF_POPULATED);
 }
 
-- 
2.51.0



