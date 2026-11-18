Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031453;
	b=MYxc3FFE+To5usCXr+Gh8TiRhaos319D4V0fDeaiSqwqAnC2QocZ9I8+LrJKLNTSWjY5
	 f3zFP3iVI48WAuWB6n83rkFJmg7IsP+Sqp1QO8GD+xC32bxIN3KA4x3JfsDdqHOvnf+wO
	 Rh+0SqMOLGlK8PIpqxeomp1nOmvNirpYGG4jIxblV3Q0nJtByYjUYDDT08EC2OYfdoa+0
	 1REW1AngFQnmtgDsyg2LjaNO76+WT48HtxVgZ5HrJ0QMKlGl4+fj3juAy555r0FwM/Kmu
	 H8SvnZ9dMUSGL6NzB0gTODh48JJgCYiex2pgEsMnHStCgiOc5uChq6eFybiW1e1/zgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jhD6fRjDESjv7jytxHioWw5Qf7NUD4W7xFBAnSlo1fQ=;
	b=JGf3L2DlWGbrBV3KLS3MsY3Wtxss2Yr7I5OGTTgkMlo/ozBlsNn9Q5cCNz+67wxuDOBU
	 0BFV4PFWXLjcdB/PWFEack3hmkFdHEZ9ti7zRHvHExeGlSif0vNVAQOgbhXk8tZPrfE9o
	 yIKwV09vnR2Fbka69JyaNp1B17cviq+XqIjw7KAnz4LDb3L5mBdhRM2qBGJ75L07fMBDn
	 6LuAESGPVYFJ2R9nQJd9d6ND/zuWfg1XCdmCg6oSTYaSiDZEv/fKFo4ZjZPlGnbGpmuXP
	 iVqeBhHwMgzpHm1NEmws29Rhc6XwAEnUaZvfaut1PGmOxeyw9IjvnsG5fS6ofgJXpvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eub6iEe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309D2606A325;
	Wed, 18 Nov 2026 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eub6iEe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B591F000C4;
	Wed, 18 Nov 2026 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031453;
	bh=jhD6fRjDESjv7jytxHioWw5Qf7NUD4W7xFBAnSlo1fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eub6iEe+wYiQ49SW4JcrV2FNIt/ZSC7wO1Ne/rqKoNoSwwW4m+eEd+Ra0D06ng3Zg
	 cTnAinzAUtsY9D07ePjau/jtsf8N0QbRnvqpYpcjX0Ez8iHnl+9GnRQjlppPCtq8Gr
	 Um7LBXA0+5BkA0uvm+SVvhbb7bXdyZ/gUv+vzwc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1011/1756] xen/pcifront: Fix PCI device reference leak in AER handling
Date: Wed, 18 Nov 2026 15:52:18 +0100
Message-ID: <20261118150050.390272892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 5d12c51bd98cdb5a32cbfb606963b05740ec42f2 ]

pci_get_domain_bus_and_slot() increments the reference count of the
returned PCI device. pcifront_common_process() drops that reference only
when the device or its driver is missing. All paths for a bound device
either return directly after invoking an error recovery callback or fall
through without calling pci_dev_put(). Consequently, each AER request for
a bound device leaks a reference and can keep the device allocated after
removal.

Declare the looked-up device with __free(pci_dev_put), so every return
path releases the reference after callback dispatch. This keeps the
device alive while its callback runs and balances the lookup without
restructuring the callback returns.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 956a9202cd12 ("xen-pcifront: Xen PCI frontend driver.")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/20260813153138.3953222-1-ruoyuw560@gmail.com/
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260820135603.3901798-1-ruoyuw560@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/xen-pcifront.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 451476ce10ae9..c15f33dc9ce55 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -579,16 +579,15 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	int bus = pdev->sh_info->aer_op.bus;
 	int devfn = pdev->sh_info->aer_op.devfn;
 	int domain = pdev->sh_info->aer_op.domain;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev __free(pci_dev_put) =
+		pci_get_domain_bus_and_slot(domain, bus, devfn);
 
 	dev_dbg(&pdev->xdev->dev,
 		"pcifront AER process: cmd %x (bus:%x, devfn%x)",
 		cmd, bus, devfn);
 
-	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
 	if (!pcidev || !pcidev->dev.driver) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
-		pci_dev_put(pcidev);
 		return PCI_ERS_RESULT_NONE;
 	}
 	pdrv = to_pci_driver(pcidev->dev.driver);
-- 
2.53.0



