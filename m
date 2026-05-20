Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA9D370D7C;
	Wed, 20 May 2026 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294952; cv=none; b=t5SFvzE56IabnCFKk1Jw/uXwt7hYaQQRdUIgI+O8Aua/pbDRyrRYW9qKGR6G+zEp9yM+W8YjjOdWI9+1aOjKn5ewdkbA29LraHO23oMBa+THO1Mg0PXnoNj18lmdEgMDETDfIyPIJVO9UohLpstQ8hn6TUSj0fy3OFcmTzQ1i/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294952; c=relaxed/simple;
	bh=szEPEwhGdBrLJBMoYuHZ6ZpJbA/dc9k+xu8JrZVQU1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm3qIWWHspilmTudP5kMwqr+dmGhPTiPZINgWsEfwLNCOIgBrqxUXWK/BlPhFAUDSYz9trrIdvOqFc/KipgT5tiqJ9M83icW473x1Dczg7pqlqLCqaO+Qtj0NTVU306aX83MJNNCncDd9dNbuTmg+kQ2oc2K9L3TNMwSR6WWcOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKQFENAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKQFENAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D7E1F00893;
	Wed, 20 May 2026 16:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294950;
	bh=6Yw0dOndZZ0X+cgl/UR53Yw2Qi+ZvStFwZxIO76Uc+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKQFENAw9aJs51pfHvWJGbGJce6mVr7/0jiB2P/AvZ8VLjX6yzhFz3i/y3cTx1nlg
	 kEJn60p/jl7vM56jCUWNlTJV9bC9VlRw93jYeot54L1yKGdJgaXrityZWXwZ1xQJGj
	 aYc6UcIqyG6TF+8HzqhsTEqZcfSL7jSmhDI3BtOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0234/1146] PCI: endpoint: pci-epf-test: Dont free doorbell IRQ unless requested
Date: Wed, 20 May 2026 18:08:04 +0200
Message-ID: <20260520162153.544063054@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit e81fa70179aac6ac3a6636565d5d35968dca3900 ]

pci_epf_test_doorbell_cleanup() unconditionally calls free_irq() for the
doorbell virq, which can trigger "Trying to free already-free IRQ"
warnings when the IRQ was never requested or when request_threaded_irq()
failed.

Move free_irq() out of pci_epf_test_doorbell_cleanup() and invoke it
only after a successful request, so that free_irq() is not called for
an unrequested IRQ.

Fixes: eff0c286aa91 ("PCI: endpoint: pci-epf-test: Add doorbell test support")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260217063856.3759713-3-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 33548935765e3..0e7cbcbebf0b4 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -715,7 +715,6 @@ static void pci_epf_test_doorbell_cleanup(struct pci_epf_test *epf_test)
 	struct pci_epf_test_reg *reg = epf_test->reg[epf_test->test_reg_bar];
 	struct pci_epf *epf = epf_test->epf;
 
-	free_irq(epf->db_msg[0].virq, epf_test);
 	reg->doorbell_bar = cpu_to_le32(NO_BAR);
 
 	pci_epf_free_doorbell(epf);
@@ -759,7 +758,7 @@ static void pci_epf_test_enable_doorbell(struct pci_epf_test *epf_test,
 					 &epf_test->db_bar.phys_addr, &offset);
 
 	if (ret)
-		goto err_doorbell_cleanup;
+		goto err_free_irq;
 
 	reg->doorbell_offset = cpu_to_le32(offset);
 
@@ -769,12 +768,14 @@ static void pci_epf_test_enable_doorbell(struct pci_epf_test *epf_test,
 
 	ret = pci_epc_set_bar(epc, epf->func_no, epf->vfunc_no, &epf_test->db_bar);
 	if (ret)
-		goto err_doorbell_cleanup;
+		goto err_free_irq;
 
 	status |= STATUS_DOORBELL_ENABLE_SUCCESS;
 	reg->status = cpu_to_le32(status);
 	return;
 
+err_free_irq:
+	free_irq(epf->db_msg[0].virq, epf_test);
 err_doorbell_cleanup:
 	pci_epf_test_doorbell_cleanup(epf_test);
 set_status_err:
@@ -794,6 +795,7 @@ static void pci_epf_test_disable_doorbell(struct pci_epf_test *epf_test,
 	if (bar < BAR_0)
 		goto set_status_err;
 
+	free_irq(epf->db_msg[0].virq, epf_test);
 	pci_epf_test_doorbell_cleanup(epf_test);
 
 	/*
-- 
2.53.0



