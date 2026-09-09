Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBB157ED90;
	Wed,  9 Sep 2026 14:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963341; cv=none; b=NCRpefioOybK+F45n9z85HNz3Rz3n3vzHyKDhg1t5IZwMpw2kCBUUoqJIlTIfM2iL24TcvG2/qHDPbVJo8CYphs+w65CUlC7ujRQ957PbO51WeC5s6HwhbLM0CFssSy/uQmRAQc6EACjlpK6uxUZrb8+0YHbcAJC+EQZlsG4axI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963341; c=relaxed/simple;
	bh=0vY+3LERk2zLnYW4IbJuFJYyhn1xk4t3YRJ1Rxcnjac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drtM07e1qFBM557YXJSkAAB6iBWYT7f82OoGZmRqcU+GFWW6KVGjE9xg3aauLSIQgCCQXJPCZpD1C804XbKlC7vlWWq/akh9BBaxHd5zW8nt0YQSkHkmk6fo7JJlx/B1V/pZXg9ifYwDpTjYlLfxgjx9QQbQ1bjGERSbjuxrXiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEzbAIUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEzbAIUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2961F00A3A;
	Wed,  9 Sep 2026 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963339;
	bh=3+S6yI1hVeCB6pF7uQYrPzywEe9rdFZyUFeQRXcVODM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEzbAIUTfvhAui1vgomQ+LM3Z5B0hQOjyX7RMsiMNqpO6xQ2c3Vz+uzd10rwIwWt6
	 Vba6JMnczpOHxegOw+D+ekPu2s5s1VP63736mCQBK1Z4s7ZlYNXjCwmz2kZQ3fUprn
	 PDGCty1g9Q/4kLTdBhX/EIz/HTTyL0nN4inb9iqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 046/583] scsi: pm8001: Use rollback index when freeing MSI-X vectors
Date: Wed,  9 Sep 2026 15:35:31 +0200
Message-ID: <20260909134239.528787848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


