Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CF4216E30;
	Tue,  8 Apr 2025 11:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112331; cv=none; b=t8Kg8lWiskFX1d3DFFipzD68sNafqSaMnYlLFMXZYperiAX8JoK2Ig1+/TUsY/x+Ptzsimfmi7+qzGtlIqSZbgVUjZzVJOrrEDzcT7URx2zDEHcUCOxVkQ8MTba6FCosRe9L41PAVlnZ8cdvL6TTAH26C00Xgy7YqslZJgRksno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112331; c=relaxed/simple;
	bh=n20sTTApe3mgtcGOR2npBvBlwGsDd4xV9OCiaMq15mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKznlOchSV99hzYLGof++oDGUjfKqeY7QZjl0F6DVC+ReGbzmhR81RCVn2Ci1kdsmByfGdh2lV0bZbNq/CntsmjhIKJ81vOKEQb3xsJSGzBdTrFRcCuVvjNallD58Ef4AVUK6+R6vcsySbz5qIK83RGp+p439VhPLpuQnFYdSzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPkJdpko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPkJdpko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22507C4CEE5;
	Tue,  8 Apr 2025 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112331;
	bh=n20sTTApe3mgtcGOR2npBvBlwGsDd4xV9OCiaMq15mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPkJdpko/dtN49rSaOKp+7hsmV83Wm99YAFrkj2Df2Cxmrt5IG2x+VgCvBt7em3oH
	 8kHjmAyDEGbq6m+yljZ/3C0GLVf78ltjoS/ix15epxPSWhde7CLq6Dob3PLxAKrQ+s
	 02MOyyp2r8Lzk8/cXsk8FkuGrDDVcF8MPywtx5Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/279] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Tue,  8 Apr 2025 12:46:52 +0200
Message-ID: <20250408104827.166662843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0b4e063bfe1e..eb8e9c54837e0 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2875,7 +2875,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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



