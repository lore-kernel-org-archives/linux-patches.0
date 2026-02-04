Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4752BE03C;
	Wed,  4 Feb 2026 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218095; cv=none; b=huowH9VwsBn5SnOfSU0gr7aEAU9LbAaJ+ubGbuQegYt9A4Iv3HEKN0gBGKIQm54RyHQNV6tOVHG2up3DPeuRgsuPx0bF9f1+Uf0B2VXHx9Awz233kNXqeySOrBqJjBiii+s2XU/KjW6EymqAa2MMd93yUHI9g4kCIfI2jQTmcRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218095; c=relaxed/simple;
	bh=SpdkXzDYlluzvK3CPYDmncll7P16Y/5XXqF1JVMgel0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHa6J2CkSo6kKsWDVqSv3Cd5R5mW1ZBMnha3bZTrrVElo5zZM7a0Fq5N/NGqnYxmItGeSkvZZS6mWO5teJ1/j0YqCcpf0W92isCc3gUTP/kBmLzZ4RJKlbMTrwuBApqsBHbbOkwsCXJiinErfnjCP4BTEg24dmc/0QzyZ/uhQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqPwuaGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqPwuaGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC84C4CEF7;
	Wed,  4 Feb 2026 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218095;
	bh=SpdkXzDYlluzvK3CPYDmncll7P16Y/5XXqF1JVMgel0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqPwuaGtTrWz/63fFaDK3EBgs7bCHjWsBrn1Uk1zUffURGSpVnb94E3Uoef3en3D0
	 Sj+jWiO9nZ8ve7b2uXcu56gh+imbdd0B6xdt9edJRJaTuxWLDMDt7DuKqw4WcSIig7
	 I4kuyb28baKfX142VZ3WHGQnhYDo+4UCXxuGquT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 211/280] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Wed,  4 Feb 2026 15:39:45 +0100
Message-ID: <20260204143917.195152044@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -4464,7 +4464,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
 fail_flt:
-	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
 
 fail_flt_buffer:


