Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CF2256C67;
	Thu, 17 Apr 2025 18:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915014; cv=none; b=JuwQOm5sdXtfoiVpunF0MrhEg0v+0Od4ZVd/Wbce1ajE0mFewr3ZmXgFayxijpBWRAID2uKXnbxJ7C2lA6gPlL16NV6n3gis0Xozoiu26GtgMUzG/lzPhgAcsiC28Q9mDVIrX7zLAWmdUXREWHc08Lr42O80S9rSXBhTD207QFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915014; c=relaxed/simple;
	bh=daTNpgVYZOZ9JwrliLfRIVPj0HdLytLq2vwSUNfNisQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xk734IRNNJxfl99aeALujPoWF3oOO9BNxnUJtPle8NwhWGdPVMuW1szgotf3RWGDYGbtQFvRQ7eBINQ84+2wNj7xmIwz9w9iH0KKq0GY2gt806EnAhg0QPi4KuiBAvZkN0K10yVf+iB7J+QcEy34FgSMwGfNW2t012Ji3hLkTys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGkz9nUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGkz9nUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F28C4CEE4;
	Thu, 17 Apr 2025 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915013;
	bh=daTNpgVYZOZ9JwrliLfRIVPj0HdLytLq2vwSUNfNisQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGkz9nUfZL0CkIQ3hGxjfEugLNc0I/PxmfmQyX/kp5xd9girkzpHLbLXEX68ZQsvj
	 juKipbthgiQ3mKMes2ibwtajLaXhwW/4G/eEc5e8k/TRCKG/Ed3f8ifAqZ4/rs9tPf
	 QIDvRq7I8sUFPLcVWqUOTkKgO1B0atLmTx6aYIDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.13 376/414] misc: pci_endpoint_test: Fix displaying irq_type after request_irq error
Date: Thu, 17 Apr 2025 19:52:14 +0200
Message-ID: <20250417175126.583332811@linuxfoundation.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 919d14603dab6a9cf03ebbeb2cfa556df48737c8 upstream.

There are two variables that indicate the interrupt type to be used
in the next test execution, global "irq_type" and "test->irq_type".

The former is referenced from pci_endpoint_test_get_irq() to preserve
the current type for ioctl(PCITEST_GET_IRQTYPE).

In the pci_endpoint_test_request_irq(), since this global variable
is referenced when an error occurs, the unintended error message is
displayed.

For example, after running "pcitest -i 2", the following message
shows "MSI 3" even if the current IRQ type becomes "MSI-X":

  pci-endpoint-test 0000:01:00.0: Failed to request IRQ 30 for MSI 3
  SET IRQ TYPE TO MSI-X:          NOT OKAY

Fix this issue by using "test->irq_type" instead of global "irq_type".

Cc: stable@vger.kernel.org
Fixes: b2ba9225e031 ("misc: pci_endpoint_test: Avoid using module parameter to determine irqtype")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20250225110252.28866-4-hayashi.kunihiko@socionext.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -234,7 +234,7 @@ static bool pci_endpoint_test_request_ir
 	return true;
 
 fail:
-	switch (irq_type) {
+	switch (test->irq_type) {
 	case IRQ_TYPE_INTX:
 		dev_err(dev, "Failed to request IRQ %d for Legacy\n",
 			pci_irq_vector(pdev, i));


