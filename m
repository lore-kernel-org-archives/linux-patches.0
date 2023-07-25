Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907211ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F01C433C7;
	Tue, 25 Jul 2023 11:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284679;
	bh=69Fw7zNIveZQ2DaMyzx3qIf5EekSumCJVGkXBR1tQiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyCVJC6CH2IQ228Pt3at8VL9OOkmUwz4CttOtbOk7DaaeDSzJSsQeFfc5bpCpGCWz
	 VE7EEQG4x5o0DCcVLjZ4WqC4+6FlG1h3YrzJ9w6ndCruS6LifPtz0V7WBvfw+JUOIv
	 oRYvAxxaipOS4Vkz67aaEeHiiY9eB+eZJS21P49c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 5.10 404/509] misc: pci_endpoint_test: Free IRQs before removing the device
Date: Tue, 25 Jul 2023 12:45:43 +0200
Message-ID: <20230725104612.225733893@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

commit f61b7634a3249d12b9daa36ffbdb9965b6f24c6c upstream.

In pci_endpoint_test_remove(), freeing the IRQs after removing the device
creates a small race window for IRQs to be received with the test device
memory already released, causing the IRQ handler to access invalid memory,
resulting in an oops.

Free the device IRQs before removing the device to avoid this issue.

Link: https://lore.kernel.org/r/20230415023542.77601-15-dlemoal@kernel.org
Fixes: e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -935,6 +935,9 @@ static void pci_endpoint_test_remove(str
 	if (id < 0)
 		return;
 
+	pci_endpoint_test_release_irq(test);
+	pci_endpoint_test_free_irq_vectors(test);
+
 	misc_deregister(&test->miscdev);
 	kfree(misc_device->name);
 	kfree(test->name);
@@ -944,9 +947,6 @@ static void pci_endpoint_test_remove(str
 			pci_iounmap(pdev, test->bar[bar]);
 	}
 
-	pci_endpoint_test_release_irq(test);
-	pci_endpoint_test_free_irq_vectors(test);
-
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }


