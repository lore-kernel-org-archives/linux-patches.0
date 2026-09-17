Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6179C3A7F4B;
	Thu, 17 Sep 2026 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661180; cv=none; b=oiGv2CGo4ClpRdeLCjLMGVzuVHMj0bW6kfSInUncfbdTd99PFbMjqsTgvsj5Vo9XXvM9D9x//o7oVb0cvAQckk+HRZPg4X4bvlLoIUwhWvWrzKhJs0bmeUbZ3CX3y0SbLXu2wDV8YG0twmS0NdamK6QR+l3p022I82J0Y7mZHuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661180; c=relaxed/simple;
	bh=igD12QvkHrxWqFmgw7gcxgnrV8Vksch2E+c3bRSqSy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlpmxkZ5Ofak9rOOs7UFQ3TBbQuku140CnpQYbaWVQkPWu3IbyLguoEL/Sh0aCGonzR3HdM2jKEr/hJCRqaO1WVfLqAxBqjQzPJJNmv8LhBLF9Fs2xaP0M38OMnOX01ECu4JV27yvGy68P+GXaZepqlByZrXuT0Xp/PV6oMuk0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pwj9Qv0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pwj9Qv0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F31F000FF;
	Thu, 17 Sep 2026 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661179;
	bh=JjO+k8/FllnRyBuIqMoU+L17L0y0PRWYI55lqEE9Irw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pwj9Qv0vC2mCu9FZiazyApZ14kAGA7tqByMsY4xquw4ZGNqxCOyomHOS3GgmLbWzL
	 w4NT3affvWmLRkJiavUsZWCVJFtNi9jNOeqmb/kmB1sgyfgcZdr/oSk8c8pl6RUPrR
	 PwgkG/PJAbNav+djdC78T0feQI3KIVDxE4lPbwG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Achirica <jachirica@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0108/1250] bus: mhi: host: pci_generic: Round up nr_irqs to power of two
Date: Thu, 17 Sep 2026 15:58:23 +0100
Message-ID: <20260917151554.929665824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Javier Achirica <jachirica@gmail.com>

[ Upstream commit 86f6dc05ea051fa03ebc03174bc00f734593465d ]

When an MHI device uses standard MSI, the PCI core requires the allocated
number of vectors to be a strict power of two. But devices will only ask
for the irqs they need, so they might not be properly aligned.

Make sure a power-of-2 number of vectors is requested.

Signed-off-by: Javier Achirica <jachirica@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/CACixm21q7b_diEx5COZxVZm9EhZ0hnakM_WBjEWcCsznfWeniw@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 646f3bcdc636a..a5b47728f9aba 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1139,7 +1139,8 @@ static int mhi_pci_get_irqs(struct mhi_controller *mhi_cntrl,
 	 */
 	mhi_cntrl->nr_irqs = 1 + mhi_cntrl_config->num_events;
 
-	nr_vectors = pci_alloc_irq_vectors(pdev, 1, mhi_cntrl->nr_irqs, PCI_IRQ_MSIX | PCI_IRQ_MSI);
+	nr_vectors = pci_alloc_irq_vectors(pdev, 1, roundup_pow_of_two(mhi_cntrl->nr_irqs),
+					   PCI_IRQ_MSIX | PCI_IRQ_MSI);
 	if (nr_vectors < 0) {
 		dev_err(&pdev->dev, "Error allocating MSI vectors %d\n",
 			nr_vectors);
-- 
2.53.0



