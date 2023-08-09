Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330541773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CFAC433C8;
	Wed,  9 Aug 2023 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580013;
	bh=al7vI0ZCCRCVSzfygOLQwNRKguggLxPLCTCJC9KrEvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zgw2//MsfIR11DplMNnzsoA2Nnj6LQ4phFY6AQnB89lyD1wVZkypiliJOUsmUK+57
	 Igzq9VU0npLTg+5VdX1Fel6GciooffhnkO2sR/Z6TtQ+faTPxAnp4j0VxdBgTm+wB1
	 h9vh3LjOgH0Q56CFX3ebGyfFeZJ48OVxqhtSNofA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 4.19 169/323] misc: pci_endpoint_test: Re-init completion for every test
Date: Wed,  9 Aug 2023 12:40:07 +0200
Message-ID: <20230809103705.882481726@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

commit fb620ae73b70c2f57b9d3e911fc24c024ba2324f upstream.

The irq_raised completion used to detect the end of a test case is
initialized when the test device is probed, but never reinitialized again
before a test case. As a result, the irq_raised completion synchronization
is effective only for the first ioctl test case executed. Any subsequent
call to wait_for_completion() by another ioctl() call will immediately
return, potentially too early, leading to false positive failures.

Fix this by reinitializing the irq_raised completion before starting a new
ioctl() test command.

Link: https://lore.kernel.org/r/20230415023542.77601-16-dlemoal@kernel.org
Fixes: 2c156ac71c6b ("misc: Add host side PCI driver for PCI test function device")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -601,6 +601,10 @@ static long pci_endpoint_test_ioctl(stru
 	struct pci_dev *pdev = test->pdev;
 
 	mutex_lock(&test->mutex);
+
+	reinit_completion(&test->irq_raised);
+	test->last_irq = -ENODATA;
+
 	switch (cmd) {
 	case PCITEST_BAR:
 		bar = arg;


