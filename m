Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E9D19E96D;
	Wed,  4 Feb 2026 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219117; cv=none; b=tBo7CSW98PsLkhGtwGZpnoD+13vRdhyYFnUHuLWsHH4gCI7AiPSzdL3Gqox1HCP1XQVp/RBum+bR21bIeHl7ZZjJA9VrrXOTFqCij8LEWCRc6tXolR+d16x8jb0bKwPajWMcIe/zhXMt7Aj7X180jf1A7lfrhUhJO3ojzIvf30c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219117; c=relaxed/simple;
	bh=1EqjtZSD35DxHjWdZKi9b8CeYZ0MafL4wrwiGdz2MAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+a2WsxJ2BX231dU872ySW4MmEx4BZj7T+wFZ+9MLSZZ80BZ34PKKrKUCUkOmhZaTcjZVHWj+L0HBkIGZeLetoHOk5VMpFBhQLdQpPbFjzH9zR/3I6P0h++kJfPQmvEQ2OxWdLG/rXOJrhUV2yHyuKPzNvT8hEb8C5xhAVachEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdE9Dg+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdE9Dg+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79ADC4CEF7;
	Wed,  4 Feb 2026 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219117;
	bh=1EqjtZSD35DxHjWdZKi9b8CeYZ0MafL4wrwiGdz2MAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdE9Dg+hzWqeuCCIddYLbH/INB3gq15O0Vw7Wlo+64q5zpPwW0uUru+yz7nsK8plS
	 mnwqZFNpdbgTSxPoMSHLXx3xb4WE+rT3sUOa0cVhipJ6SD6i6vyfhiBaaERi2/tDKS
	 /k0vtDP55XYt6PSo72jq2opkMegFpprq5jvs20Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 073/122] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Wed,  4 Feb 2026 15:40:55 +0100
Message-ID: <20260204143854.478792729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 56bd3c0f749f45793d1eae1d0ddde4255c749bf6 upstream.

Earlier in the function, the ha->flt buffer is allocated with size
sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE but freed in the error
path with size SFP_DEV_SIZE.

Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260112134326.55466-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4488,7 +4488,7 @@ fail_lsrjt:
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
 fail_flt:
-	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
 
 fail_flt_buffer:


