Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5D5272E7C;
	Tue, 11 Nov 2025 01:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823970; cv=none; b=jo6gKmgRikC5kh6JvY7GmWO+As6A6+lY6Cux9GNmmbF4wbtanRAhMJgwNJ7yrDQ6gZpngWpDNDIdjlU1wf4tQqyPLl+9Iro5hOXDPFJa7m6bk4+gIpkpo2lI4vw3ryixtcPOpCRUIlGKKll3lt92lUuE0CNPZNuiCPQckZ0oV+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823970; c=relaxed/simple;
	bh=qVwhDvv5ywmnujOE9z5S6ZrvgUHw6Jf/bnV65Wg8zV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoFsA5B85Tvs58PJOGHPvrZTaLPraCeBQ0eM0f/Icl/v4uMP6sWqB5ufmN1LIa5nEPfm/Ox6JsMbcks3peT+mB8ebYUZJna8mYQME+J7WplMurErf4grzlAyR8DVVSHOs0+Oac3cBNIqwQUKqwJuQ24LH3t107ZbdO4mGpOOEBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu0tO2Sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu0tO2Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A947C113D0;
	Tue, 11 Nov 2025 01:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823970;
	bh=qVwhDvv5ywmnujOE9z5S6ZrvgUHw6Jf/bnV65Wg8zV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vu0tO2ShfRFTHcygFPBXrdWj+CD6VLIGRgUW2Lj4cQckzW0tzfTF18drZGHLFCMpQ
	 uW0Rq6r6YwfKPJa6ugb8Ik37WW8BgrD6aFom3fHg+GzydMQfFBBWs+X0nLKBV7L2dx
	 DBxJPNy5FQEXoQAOTySdyVT9NrAoEwvYTmTUkvO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 370/849] misc: pci_endpoint_test: Skip IRQ tests if irq is out of range
Date: Tue, 11 Nov 2025 09:39:00 +0900
Message-ID: <20251111004545.370890761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit cc8e391067164f45f89b6132a5aaa18c33a0e32b ]

The pci_endpoint_test tests the 32-bit MSI range. However, the device might
not have all vectors configured. For example, if msi_interrupts is 8 in the
ep function space or if the MSI Multiple Message Capable value is
configured as 4 (maximum 16 vectors).

In this case, do not attempt to run the test to avoid timeouts and directly
return the error value.

Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250804170916.3212221-2-christian.bruel@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index f935175d8bf55..506a2847e5d22 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -436,7 +436,11 @@ static int pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
 {
 	struct pci_dev *pdev = test->pdev;
 	u32 val;
-	int ret;
+	int irq;
+
+	irq = pci_irq_vector(pdev, msi_num - 1);
+	if (irq < 0)
+		return irq;
 
 	pci_endpoint_test_writel(test, PCI_ENDPOINT_TEST_IRQ_TYPE,
 				 msix ? PCITEST_IRQ_TYPE_MSIX :
@@ -450,11 +454,7 @@ static int pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
 	if (!val)
 		return -ETIMEDOUT;
 
-	ret = pci_irq_vector(pdev, msi_num - 1);
-	if (ret < 0)
-		return ret;
-
-	if (ret != test->last_irq)
+	if (irq != test->last_irq)
 		return -EIO;
 
 	return 0;
-- 
2.51.0



