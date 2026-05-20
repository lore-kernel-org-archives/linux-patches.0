Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4143C6A5C;
	Wed, 20 May 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297855; cv=none; b=CbHMZmUA4OCnOOjN7O6e6PIzzCN5JTjQjFhy4lydTWETMMIQdmJzj7Wn5UrbSS5kDxLHwEEMrUwR8Gf49rFtDab3u6++O7A1xqW6nrk73+C+nUqgWXQcrCV4kCcMITR2/dOvjomPqLxPBxnVnQrdO5duK5MxVgaEOcDVOPdKr/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297855; c=relaxed/simple;
	bh=yONtwd2sXc32gcL0hYIu7xRGcFIjUQBHc85m21oMvvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc8e0/voeuaG42hn0oTHcYr8zYW5rCaE4p3nl5rsyi/xwGYKXIBFoGPw3gKC+TxAa0Lb+wjywLNGca5cHIwr2daB3bMfM1HJW23vfnj6JogDcz4KrDhTb0gDJQDROulMoQ5KzlLYdLIvI8R2OKwDMm0qFV8lb27AzY6yszmBsMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXcJu3Xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXcJu3Xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C351C1F000E9;
	Wed, 20 May 2026 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297854;
	bh=3Eysv3huewARJZwhy5WyFdJ5TTIydHXAcHdhuSz/gHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXcJu3Xad7TEacmFkFjnrhSXoyYVyQlAdQnF9okQe2K5NS/S0SARVlSgk/DaZNQYX
	 +0HJM7lbH0FINsLz1/y6E5oUd6GyD58VTcD14P4s/1EmIAjY70pqjmyZwgi1KFkWzq
	 K18DFQ+QKggDxmbm9hpBmRVah0ITKalMaRcarfss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/957] PCI: endpoint: pci-epf-test: Dont free doorbell IRQ unless requested
Date: Wed, 20 May 2026 18:11:13 +0200
Message-ID: <20260520162138.671699646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index b05e8db575c35..9bc6d283eae25 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -704,7 +704,6 @@ static void pci_epf_test_doorbell_cleanup(struct pci_epf_test *epf_test)
 	struct pci_epf_test_reg *reg = epf_test->reg[epf_test->test_reg_bar];
 	struct pci_epf *epf = epf_test->epf;
 
-	free_irq(epf->db_msg[0].virq, epf_test);
 	reg->doorbell_bar = cpu_to_le32(NO_BAR);
 
 	pci_epf_free_doorbell(epf);
@@ -748,7 +747,7 @@ static void pci_epf_test_enable_doorbell(struct pci_epf_test *epf_test,
 					 &epf_test->db_bar.phys_addr, &offset);
 
 	if (ret)
-		goto err_doorbell_cleanup;
+		goto err_free_irq;
 
 	reg->doorbell_offset = cpu_to_le32(offset);
 
@@ -758,12 +757,14 @@ static void pci_epf_test_enable_doorbell(struct pci_epf_test *epf_test,
 
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
@@ -783,6 +784,7 @@ static void pci_epf_test_disable_doorbell(struct pci_epf_test *epf_test,
 	if (bar < BAR_0)
 		goto set_status_err;
 
+	free_irq(epf->db_msg[0].virq, epf_test);
 	pci_epf_test_doorbell_cleanup(epf_test);
 
 	/*
-- 
2.53.0



