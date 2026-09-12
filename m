Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9D442882B;
	Sat, 12 Sep 2026 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228020; cv=none; b=ICTnSW1s/bzCTEmVbPQY+YB+HWIY17PUHhW+m45PPGcFOlCwp72dOx9w9EmHSprI2N6ATopjdRWIWQqDUXos6Srt+FyqPRrdbkvXc0/dJg+/f8xelvGa2njhUCUzejTpqDblObzP6Lsk0IWtIYQQZ/XaLO3mvAQKAzIR1HbqRfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228020; c=relaxed/simple;
	bh=nX6B/cmdGStyh5FfKPmFZD2DJ0wOP2eH+ehvEUaaoMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDpOlRbwiCEfvuIM3WCNBXXEUKeFo9XnOqjiXHsN6PlfY3dyH4evlVlSeM+H/5s5hrQMkI/wK8i0edFLjcUM6sZDSpeWujqQe38N0XgDmcIQvs6Uu7+eMbntWbpZ9HPjNfUJSPuq9y6XLWF6qW3PTr9Z2UlE+oX0YZ6FvwAkDns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX7Bha//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX7Bha//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AA61F00893;
	Sat, 12 Sep 2026 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228018;
	bh=0chIeODXY08stFTBxJvOP2UpF28EXTBw1N1Q388fm1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dX7Bha//i6Lk1rWFwrW3n5SrQWgqJWAJkkOBJl+SDohHTSDjM7Hl1j9rtXgacHj57
	 lQ6pPfbgnrGYgl3hEyybKzRRazZ1cAlv3aOGkTSGkSdQjAryj90J64VMegyx8prQWb
	 T0OodF5yjt8S+KXTQMx0UxsVyeDFUHkn1xz2dGyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0283/1191] scsi: pm8001: Use rollback index when freeing MSI-X vectors
Date: Sat, 12 Sep 2026 08:50:11 +0200
Message-ID: <20260912065554.582792925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1004,8 +1004,8 @@ static u32 pm8001_request_msix(struct pm
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


