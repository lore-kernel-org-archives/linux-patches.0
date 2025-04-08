Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C4D268FD2;
	Tue,  8 Apr 2025 10:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109712; cv=none; b=FxADDO6ABQOA6r9Z51r8r9fXycugbl1USCJf7smpJ1gbKKs3TdWyPMJlWcIB4mzOoKHV1swagBDJS7EvcuzuSr7yOm0x/vsWXovtN9gww4/pZtYQzgtpNZirT71M1tTOPUrFVciBUAlQJSMb9I9RkWZsujMJn3H0TST4v7/10Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109712; c=relaxed/simple;
	bh=ZYo95NIb/nisbTx8bHf/FDReCm8B3LqfrprpqxADyso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcFK9wWLQ0mU+feyj7Ln7vls9LwhjXWLcHTi6NCI5hrDAqB/uqVfUUmIR7gJWD6UKTzsbydug+ziSsEPAVHUT/roEQ/Ufq1WrT9OTjUJ1z4Bat6B3cXX3N2oJQ8TJL+tnXHKiUJrh4WVdw6k7PRxGfOjqZ5t9XqfotSq4nQWXlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW7DBuEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW7DBuEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30678C4CEE5;
	Tue,  8 Apr 2025 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109712;
	bh=ZYo95NIb/nisbTx8bHf/FDReCm8B3LqfrprpqxADyso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW7DBuEITuTxaaOrR91fkKFSROWeRZUDEQFh59WkKG4Y7mT1BjWXQqWvNh1Lmed3m
	 gMZJjm2BPOTGETXzQCnkny0ZiGR7g3dVNRi0ZTsphOO5hGvo/IqGm1EvUI/M1njT5f
	 YqQtdJicZ4M7nYopgdJNGuv6IewsCzX1nuG+TC5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/227] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Tue,  8 Apr 2025 12:46:43 +0200
Message-ID: <20250408104821.150913266@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 5233e3235dec3065ccc632729675575dbe3c6b8a ]

A null dereference or oops exception will eventually occur when qla1280.c
driver is compiled with DEBUG_QLA1280 enabled and ql_debug_level > 2.  I
think its clear from the code that the intention here is sg_dma_len(s) not
length of sg_next(s) when printing the debug info.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20250125095033.26188-1-linmag7@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 545936cb3980d..8c08a0102e098 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2876,7 +2876,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 				cpu_to_le32(upper_32_bits(dma_handle)),
 				cpu_to_le32(lower_32_bits(dma_handle)),
-				cpu_to_le32(sg_dma_len(sg_next(s))));
+				cpu_to_le32(sg_dma_len(s)));
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-- 
2.39.5



