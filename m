Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717361ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56F4C433C8;
	Tue, 25 Jul 2023 11:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285615;
	bh=ISR9S4vZPdq5WFeiApKOfjYXsUikkXLXinTGakbVcbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENZaZUlXF8Dq+oPfeCITYDhmpY1f8U0O0WwI6TCZ6bb6Qe6PqWJi98PqNxhp63C9S
	 leD8izYJwNR1Det7BtGOwTiVRnmVtNKwkJ4J7j6dP7Wg/CX/QRX/X+cgUbJUQRCtEK
	 OW0/9f+C4BqfGtks7VE95YK/8OhLCabhdYfLwNj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 5.4 251/313] misc: pci_endpoint_test: Re-init completion for every test
Date: Tue, 25 Jul 2023 12:46:44 +0200
Message-ID: <20230725104531.923829986@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
@@ -590,6 +590,10 @@ static long pci_endpoint_test_ioctl(stru
 	struct pci_dev *pdev = test->pdev;
 
 	mutex_lock(&test->mutex);
+
+	reinit_completion(&test->irq_raised);
+	test->last_irq = -ENODATA;
+
 	switch (cmd) {
 	case PCITEST_BAR:
 		bar = arg;


