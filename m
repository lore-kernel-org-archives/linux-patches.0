Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB9B259CAA;
	Tue, 25 Mar 2025 12:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905554; cv=none; b=qHKN69LCPKWaqPNfUtiWeszglpYeiywYY1i7/8uQXrTs94A1WfBT411rAgpgYfYN9Aoav9WRYCUNt3M1LzLwGFNNQFPv3gzXdrCd2pEb74k7YgzQ74bD8g8ItrK5N7hffqeOvzHr92bT7FiXvlr35FVv2MmPOE1wbrtFcPI7K4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905554; c=relaxed/simple;
	bh=vWk1HTeHevkj2AFtVKUFcVYuZvVGMtWSxpe9Gd1Un7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkQRgO2DDbppnpaZqX7/vrjgbpFPMvJk/huRCVTuO8VnlW8nB8Yzebv5YenzA4e3K07Ng/njLpBOJxFEwohNCfB+qdWC3HB8A+3026F1SELKdnW1DdQe1u3tlzT+CE5/HislXeXGdtXM2f5Ktp1ln8pcjNO5kfy+XqNxwUIA/WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEakwQAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEakwQAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02465C4CEED;
	Tue, 25 Mar 2025 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905554;
	bh=vWk1HTeHevkj2AFtVKUFcVYuZvVGMtWSxpe9Gd1Un7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEakwQApvUUqZs3LA3J836BTJfEWsg8+S3ho+0cbQ70Qt30SSGFEG0Ic/9WboZHR8
	 5uDQqsFA6JhFo2SJGJXMq9U0hfdawXuEEWo8YKR84EwYqjZ49JZGdyLJTP1X2thFAB
	 pDYvhR0T6ZXz1S+HoO6diHk5/iEoTqoxX68sm69Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/198] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Tue, 25 Mar 2025 08:19:58 -0400
Message-ID: <20250325122157.588258257@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e7f4d138e06c..0bb80d135f560 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2866,7 +2866,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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



