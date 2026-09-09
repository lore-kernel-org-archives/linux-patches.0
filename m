Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0BB492E33;
	Wed,  9 Sep 2026 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961804; cv=none; b=aV29rHRPDH1qzp1faaYwM9vW6pSk+rX3XcPU8ASKeWO3y67IPuKqYp9F1mrZl1Mvj438u6Nk1fLDd6d6WqSjx6KO/+Og4gPP0UPVU+WySCtsvHJGytb/G0AottFWKKX/cJsltsQNzBhJCa203C3gLiUPdMWHaHakYHCcu2QRU4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961804; c=relaxed/simple;
	bh=tnBOjoA1OhgKzbZs4+NDRZZoaC0A1CnwM/UN4cotvPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPmyc/SxQmF1liu1esISKBYbZ++6W9vUbKnCoYVubnm7Gu2ZOZj0ouEiMQ24zccizhOAgijicHPuk/KUk4Le/eUltdoVdhK3E67meqyGoHjTdabcAHO1mq3PrFZulmvLL1spqzf3SbOiL4fWwWs60QOUOfcq6iNgCIpkr3o+K1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tj2QR/2c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tj2QR/2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E49F1F00A3A;
	Wed,  9 Sep 2026 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961802;
	bh=0J7VHP9vuAdWeZLSlgha8r1LxwxJDq0EGEzlErmxRTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tj2QR/2cHxk12I4IS024xrFzdKc7YkYmVIjqGSm3OZZ6edLrBg6a7IUZ8544LAqPu
	 79fGuz4jj+xmFQKovMusL1eDy9LKyC8z1ehBk8BrL9goDbw2lfcBmvgAZ7zsNdIiNW
	 QMDMqpl5rxpWq/K9uqdKMkLe+4ik39WcR8IU6OBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 071/556] scsi: pm8001: Use rollback index when freeing MSI-X vectors
Date: Wed,  9 Sep 2026 15:35:51 +0200
Message-ID: <20260909134232.960297971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 3f92a64545165bdbb36dee8fa35626b295463313 upstream.

pm8001_request_msix() unwinds previously registered handlers with
free_irq() when request_irq() fails. The rollback loop uses the failing
index i for every iteration instead of the already registered vector
index j.

That passes the wrong IRQ/dev_id pair to free_irq() and leaves the
earlier handlers installed. Use j for both pci_irq_vector() and the
matching irq_vector entry in the rollback loop.

Fixes: a76037ff3479 ("scsi: pm8001: switch to pci_irq_alloc_vectors")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Link: https://patch.msgid.link/20260824113618.2239100-1-runyu.xiao@seu.edu.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pm8001/pm8001_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1029,8 +1029,8 @@ static u32 pm8001_request_msix(struct pm
 			&(pm8001_ha->irq_vector[i]));
 		if (rc) {
 			for (j = 0; j < i; j++) {
-				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
-					&(pm8001_ha->irq_vector[i]));
+				free_irq(pci_irq_vector(pm8001_ha->pdev, j),
+					 &pm8001_ha->irq_vector[j]);
 			}
 			pci_free_irq_vectors(pm8001_ha->pdev);
 			break;


