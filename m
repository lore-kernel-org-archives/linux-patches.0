Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93DF26B76A;
	Tue, 11 Nov 2025 01:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825396; cv=none; b=GQGACEQ2kVw008cJ0xk61jmbk9U7mVAZ55waOovvdWQtcmOtiWYKo2q484YatQ26vxGOnXJlJmCw5nz3J7wk9MErSqB31YD4+K3pwBk64iKvYah1/V9IaNNgaj9DpCEpV1hUrJAZEYlVkW1XH+w6MjoxkKpwolvq9YaFBdQWKKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825396; c=relaxed/simple;
	bh=G5hpLihjVZ+Wnvt3SZltg4pVfunq6jPzKZNNHxVMYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMStdMxT39Q3tVOs8cqdVBNnvRcaPd13rGlkWTtVojVCLW4UcmGTAQwctrQOLnsZJP7HszUoiK4XUsHxSQb1p0tFSM4nCqES/2CI7+kDKHc8o/QushSRNBId51TCP4epm1UAGoBSJ+EhfI+lT8BJ3R7N2BSNRdFudj/2WihG/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebybx6Dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebybx6Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D863C116B1;
	Tue, 11 Nov 2025 01:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825395;
	bh=G5hpLihjVZ+Wnvt3SZltg4pVfunq6jPzKZNNHxVMYhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebybx6Dq2DP/nMCIPT0B/s08LyI6A71FgCrzw8Rxo8fa8rNY4Y9TOJ9saCCT4XNVN
	 zV58+mC47blCJ4zMMpzKmHo7HWLay1CfMMV98vm87mUutEdlcDy9884hQGK9VnljiV
	 iABBslzrnWihij13TBuVVek+ilwdt4jULb+TMVKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shruti Parab <shruti.parab@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 784/849] bnxt_en: Always provide max entry and entry size in coredump segments
Date: Tue, 11 Nov 2025 09:45:54 +0900
Message-ID: <20251111004555.387760147@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 28d9a84ef0ce56cc623da2a1ebf7583c00d52b31 ]

While populating firmware host logging segments for the coredump, it is
possible for the FW command that flushes the segment to fail.  When that
happens, the existing code will not update the max entry and entry size
in the segment header and this causes software that decodes the coredump
to skip the segment.

The segment most likely has already collected some DMA data, so always
update these 2 segment fields in the header to allow the decoder to
decode any data in the segment.

Fixes: 3c2179e66355 ("bnxt_en: Add FW trace coredump segments to the coredump")
Reviewed-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-5-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index a0a37216efb3b..b16534c1c3f11 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -332,13 +332,14 @@ static void bnxt_fill_drv_seg_record(struct bnxt *bp,
 	u32 offset = 0;
 	int rc = 0;
 
+	record->max_entries = cpu_to_le32(ctxm->max_entries);
+	record->entry_size = cpu_to_le32(ctxm->entry_size);
+
 	rc = bnxt_dbg_hwrm_log_buffer_flush(bp, type, 0, &offset);
 	if (rc)
 		return;
 
 	bnxt_bs_trace_check_wrap(bs_trace, offset);
-	record->max_entries = cpu_to_le32(ctxm->max_entries);
-	record->entry_size = cpu_to_le32(ctxm->entry_size);
 	record->offset = cpu_to_le32(bs_trace->last_offset);
 	record->wrapped = bs_trace->wrapped;
 }
-- 
2.51.0



