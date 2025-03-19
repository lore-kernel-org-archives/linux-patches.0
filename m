Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177B61B2194;
	Wed, 19 Mar 2025 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394901; cv=none; b=Nqp2gklseOrA9fs8tZSaOje/zDTqXIx1EoWOvVoXLBzhRGNeemsEcO9HYFF3g8PBaQCRCStNbrheZ93xa+OFnFrqUsQJxzzSFBcMOOzsVr1yRt1Ytiq5MimDeg4cHr5eIRXUmUr5Fq6OMDa+LU6+BXCGMcrCcQirH/X7YZB/My8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394901; c=relaxed/simple;
	bh=YF7ZGlluTxDajrBGFaP9ee7ZxHWv9FSXbTNi6O0aWH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdIjz/bXA2+v7uH8hIIiI6ANBRzXRwOPj1LLc6x0GSxYcwFLMTezE2w+fhy9Gbm2y33KnAYjA83KD3xSvATlqY3174u6xaS8kYQFPYCj3dj2DRof0yURHHwRdQ2AN1KlayFOg/whbyYvlIyYoozRveQipbdXncZRLrwvfkWbpxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHEBGzcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHEBGzcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1050C4CEE4;
	Wed, 19 Mar 2025 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394901;
	bh=YF7ZGlluTxDajrBGFaP9ee7ZxHWv9FSXbTNi6O0aWH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHEBGzcvuHzZFnBFa642poMYkk9s6EQ5AfVPFWBL0a/PKcokYx5VH0/tkAdWjXuC7
	 O2vMieAHVt4/L1nsWW07TbqkiXWG6juiyvZhFFyGRYmo1Gj/jO8IsJOuuod1pyJf95
	 sPk9+ZC3uK6tmtwKKB/3U9ws6clCNlnb/gWBtLuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 069/241] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Wed, 19 Mar 2025 07:28:59 -0700
Message-ID: <20250319143029.433000130@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8958547ac111a..fed07b1460702 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2867,7 +2867,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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



