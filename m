Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190B6FB1;
	Tue,  5 Dec 2023 03:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ro1DiGmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E78C433C9;
	Tue,  5 Dec 2023 03:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747333;
	bh=8FIbPu8nE9/3RfqNvzuHVbn0UnagqtwlqKBrIaD/91c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ro1DiGmqshCX8tOgxU5AKuxdX7HsgSkkOZV280OuZDYBVjRCf5njMdYdytLJJ+6UP
	 MwUPMu81q4dAQSd/+xsYPnmWgAZGUh4VRSZmx+QTbTUwVtLrQFGKqhpp8n8l0FiWRV
	 AUTPrN3j/U72FNf6K1T9iJ/jkU7xLjhxcnEELMJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 5.10 002/135] PCI: keystone: Drop __init from ks_pcie_add_pcie_{ep,port}()
Date: Tue,  5 Dec 2023 12:15:23 +0900
Message-ID: <20231205031530.693370434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This commit has no upstream equivalent.

After commit db5ebaeb8fda ("PCI: keystone: Don't discard .probe()
callback") in 5.10.202, there are two modpost warnings when building with
clang:

  WARNING: modpost: vmlinux.o(.text+0x5aa6dc): Section mismatch in reference from the function ks_pcie_probe() to the function .init.text:ks_pcie_add_pcie_port()
  The function ks_pcie_probe() references
  the function __init ks_pcie_add_pcie_port().
  This is often because ks_pcie_probe lacks a __init
  annotation or the annotation of ks_pcie_add_pcie_port is wrong.

  WARNING: modpost: vmlinux.o(.text+0x5aa6f4): Section mismatch in reference from the function ks_pcie_probe() to the function .init.text:ks_pcie_add_pcie_ep()
  The function ks_pcie_probe() references
  the function __init ks_pcie_add_pcie_ep().
  This is often because ks_pcie_probe lacks a __init
  annotation or the annotation of ks_pcie_add_pcie_ep is wrong.

ks_pcie_add_pcie_ep() was removed in upstream commit a0fd361db8e5 ("PCI:
dwc: Move "dbi", "dbi2", and "addr_space" resource setup into common
code") and ks_pcie_add_pcie_port() was removed in upstream
commit 60f5b73fa0f2 ("PCI: dwc: Remove unnecessary wrappers around
dw_pcie_host_init()"), both of which happened before upstream
commit 7994db905c0f ("PCI: keystone: Don't discard .probe() callback").

As neither of these removal changes are really suitable for stable, just
remove __init from these functions in stable, as it is no longer a
correct annotation after dropping __init from ks_pcie_probe().

Fixes: 012dba0ab814 ("PCI: keystone: Don't discard .probe() callback")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -865,8 +865,8 @@ static irqreturn_t ks_pcie_err_irq_handl
 	return ks_pcie_handle_error_irq(ks_pcie);
 }
 
-static int __init ks_pcie_add_pcie_port(struct keystone_pcie *ks_pcie,
-					struct platform_device *pdev)
+static int ks_pcie_add_pcie_port(struct keystone_pcie *ks_pcie,
+				 struct platform_device *pdev)
 {
 	struct dw_pcie *pci = ks_pcie->pci;
 	struct pcie_port *pp = &pci->pp;
@@ -978,8 +978,8 @@ static const struct dw_pcie_ep_ops ks_pc
 	.get_features = &ks_pcie_am654_get_features,
 };
 
-static int __init ks_pcie_add_pcie_ep(struct keystone_pcie *ks_pcie,
-				      struct platform_device *pdev)
+static int ks_pcie_add_pcie_ep(struct keystone_pcie *ks_pcie,
+			       struct platform_device *pdev)
 {
 	int ret;
 	struct dw_pcie_ep *ep;


