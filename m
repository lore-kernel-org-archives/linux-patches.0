Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1A264FA0;
	Tue,  8 Apr 2025 11:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110549; cv=none; b=V2hVi+0lfj/fESrjiyJlgfY7Nlb9W1AM8V033y2xRDndaiYcPGIWvULsiROoSLFm5X9C6GCmo0DyubWiivF3Eq6i/Qi2kwywXQ7KSOhxSNmABcA8y+vZ5pZKjT9ubiwY6FQbASHQsSmIsI10Od4kTXSLbhWRSrkcVHJixjwnqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110549; c=relaxed/simple;
	bh=Xl+HE41PBjLOPROjyYGgaustBo/0+nbOSRQFbZsuRC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZBergttxKJUUy8FKluz1e1J9W/lhn4MlEC1SqYzrjd01E3mRxz3u4GKjMInO5qFyQZ9mE+G4A4/zMAxtZImrsLYOpxJZidD5JqV5G7cCFIYGKHYjS1IaTqnnuFuJllblonxlWHIhpLK5YKqjhFv5ZZ7Ka41CCGEQkARJmWiRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqcsrNIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqcsrNIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D30C4CEE5;
	Tue,  8 Apr 2025 11:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110549;
	bh=Xl+HE41PBjLOPROjyYGgaustBo/0+nbOSRQFbZsuRC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqcsrNIjk9xr+KiK7YXO7a8TTFMTe/6FNVMbd7XvDH2hRNUgeQ6+rjCiroYPuY9fN
	 W4Wkm8RsRb+ctpj7gT1aPQJRErlqqRAMhq0Pog43boKvk5k+4fw9uXA7IxOjfUPdMY
	 yeMHvyr4uAUyYNHimwP7OQSjSNiQJ3ZTtqRgJi2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 105/731] scsi: mpt3sas: Fix a locking bug in an error path
Date: Tue,  8 Apr 2025 12:40:02 +0200
Message-ID: <20250408104916.717006178@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 38afcf0660f5c408ba6c2f0ba3a9729e0102fe2e ]

Call mutex_unlock(&ioc->hostdiag_unlock_mutex) once from error paths
instead of twice.

This patch fixes the following Clang -Wthread-safety errors:

drivers/scsi/mpt3sas/mpt3sas_base.c:8085:2: error: mutex 'ioc->hostdiag_unlock_mutex' is not held on every path through here [-Werror,-Wthread-safety-analysis]
 8085 |         pci_cfg_access_unlock(ioc->pdev);
      |         ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8019:2: note: mutex acquired here
 8019 |         mutex_lock(&ioc->hostdiag_unlock_mutex);
      |         ^
./include/linux/mutex.h:171:26: note: expanded from macro 'mutex_lock'
  171 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
      |                          ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8085:2: error: mutex 'ioc->hostdiag_unlock_mutex' is not held on every path through here [-Werror,-Wthread-safety-analysis]
 8085 |         pci_cfg_access_unlock(ioc->pdev);
      |         ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8019:2: note: mutex acquired here
 8019 |         mutex_lock(&ioc->hostdiag_unlock_mutex);
      |         ^
./include/linux/mutex.h:171:26: note: expanded from macro 'mutex_lock'
  171 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
      |                          ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8087:2: error: releasing mutex 'ioc->hostdiag_unlock_mutex' that was not held [-Werror,-Wthread-safety-analysis]
 8087 |         mutex_unlock(&ioc->hostdiag_unlock_mutex);
      |         ^

Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Fixes: c0767560b012 ("scsi: mpt3sas: Reload SBR without rebooting HBA")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250210203936.2946494-3-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index dc43cfa83088b..212e3b86bb817 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8018,7 +8018,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 
 	mutex_lock(&ioc->hostdiag_unlock_mutex);
 	if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic))
-		goto out;
+		goto unlock;
 
 	hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
 	drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
@@ -8038,7 +8038,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 			ioc_info(ioc,
 			    "Invalid host diagnostic register value\n");
 			_base_dump_reg_set(ioc);
-			goto out;
+			goto unlock;
 		}
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;
@@ -8074,17 +8074,19 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
 			__func__, ioc_state);
 		_base_dump_reg_set(ioc);
-		goto out;
+		goto fail;
 	}
 
 	pci_cfg_access_unlock(ioc->pdev);
 	ioc_info(ioc, "diag reset: SUCCESS\n");
 	return 0;
 
- out:
+unlock:
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
+
+fail:
 	pci_cfg_access_unlock(ioc->pdev);
 	ioc_err(ioc, "diag reset: FAILED\n");
-	mutex_unlock(&ioc->hostdiag_unlock_mutex);
 	return -EFAULT;
 }
 
-- 
2.39.5



