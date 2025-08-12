Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D232FDC25;
	Tue, 12 Aug 2025 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021495; cv=none; b=nFscd1BegbfPsVF64RjRVbrbRCtMHOq0KtRWGg1vWjrlwh6HO3hMxvpdKRK+AenhyHpBUrRyHbybOEZHd//CkLNo39/fbJRuEE3Gg586lIzLguUxwucofnGB9+Ij4FMUPU+RPP6IQkKHQ5i+F/GVLm2KJmHF69Uq9zj6dh57msE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021495; c=relaxed/simple;
	bh=Nkesf/BeQDOW3Sk+UB4rTkXYD3J4+BeskFZ8UUqdJP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf/C3P+vUTd+uWqXYBvM9KH94U6+2TN6tayGhj3Qkw4+2BBPRRnISehqffUAqLJQJ98tCH9zBI3J/Ca7Hviz0bLyZH0XYqVw8dOQZuE9tRnG8cC28QmW+K5dtgeKK+GqWPV8mESCX4bt1x3lfPKEmp6tSGNcpyanow4CkAT9i2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LL/ITSLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LL/ITSLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F149C4CEF0;
	Tue, 12 Aug 2025 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021494;
	bh=Nkesf/BeQDOW3Sk+UB4rTkXYD3J4+BeskFZ8UUqdJP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LL/ITSLqS0QqqBobaLLxLVivfebd5ijV6oxx8Tc5lkq97jLverzCKtPmtoyLJgxIq
	 LRLguGNCI71PguDPkOr9mhif7XkWNJTU8IisJOcqtS0M+N+eEUk14pgc0UpacyPs1r
	 GCqRQOz9Jue0ApOJm6C6vzILyOf7zN03o1Bv6zRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/262] scsi: isci: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:47 +0200
Message-ID: <20250812172959.014477784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 063bec4444d54e5f35d11949c5c90eaa1ff84c11 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: ddcc7e347a89 ("isci: fix dma_unmap_sg usage")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250627142451.241713-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 7162a5029b37..3841db665fe4 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2907,7 +2907,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 					 task->total_xfer_len, task->data_dir);
 		else  /* unmap the sgl dma addresses */
 			dma_unmap_sg(&ihost->pdev->dev, task->scatter,
-				     request->num_sg_entries, task->data_dir);
+				     task->num_scatter, task->data_dir);
 		break;
 	case SAS_PROTOCOL_SMP: {
 		struct scatterlist *sg = &task->smp_task.smp_req;
-- 
2.39.5



