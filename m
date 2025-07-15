Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629252E54DD;
	Tue, 15 Jul 2025 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587095; cv=none; b=DtB3zrPtqmIHFP5Ao4OEOfR2H1xZIxFDvysXFkuaYqEuCq1QTSwZIw/RckXMY8dzx3FcNuzs49lxb5UXvr4MnrG9Go9NH30/cwVUouDEG/G7C3ZYZse5qW6ncetqUnOyuLcDXGes9N7uYDKMjHe4ewMtOPCiBENU45ea7o/p06c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587095; c=relaxed/simple;
	bh=V2djcu/xVcbASucHEpItgQy2DZnHKdbJUuuC0fnpClw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBD72hmrKUvPSkeMGPPkaNX5rLHGiSJgWFJH6cz4JQboL6KcJ0Y3fpSVtPeyizpC/Wh9AKwPhlGMBgcB9i4RvQcKTl68mxTyGKstUbU0nKipFoyipR0q0lTrcxLmTVRDiX4YeLPJ9LyfFh8UPxi3Sqq9VAgZAZzcEpPZCz4LJ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuLoTIku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuLoTIku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C238C4CEF1;
	Tue, 15 Jul 2025 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587094;
	bh=V2djcu/xVcbASucHEpItgQy2DZnHKdbJUuuC0fnpClw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuLoTIkuVHzuzED1UvoBxn/cPGT8IlM4LFdjlHCklmDFKi1id+JK8wInc40ycTsvT
	 snLdX3t0iPF6uUxUHTFS6/iZxcDyZsOjYOnnkfzCYztcz0ZlaBjxh/3RH79VLDQNHZ
	 xmKwcXB4YA7p1+A1cQgfxeVUI0JzcvVwZK/uDy40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 165/192] bnxt_en: Flush FW trace before copying to the coredump
Date: Tue, 15 Jul 2025 15:14:20 +0200
Message-ID: <20250715130821.536974441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shruti Parab <shruti.parab@broadcom.com>

[ Upstream commit 100c08c89d173b7fdf953e7d9f9ca8f69f80d1c5 ]

bnxt_fill_drv_seg_record() calls bnxt_dbg_hwrm_log_buffer_flush()
to flush the FW trace buffer.  This needs to be done before we
call bnxt_copy_ctx_mem() to copy the trace data.

Without this fix, the coredump may not contain all the FW
traces.

Fixes: 3c2179e66355 ("bnxt_en: Add FW trace coredump segments to the coredump")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250710213938.1959625-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_coredump.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index a000d3f630bd3..187695af6611f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -368,23 +368,27 @@ static u32 bnxt_get_ctx_coredump(struct bnxt *bp, void *buf, u32 offset,
 		if (!ctxm->mem_valid || !seg_id)
 			continue;
 
-		if (trace)
+		if (trace) {
 			extra_hlen = BNXT_SEG_RCD_LEN;
+			if (buf) {
+				u16 trace_type = bnxt_bstore_to_trace[type];
+
+				bnxt_fill_drv_seg_record(bp, &record, ctxm,
+							 trace_type);
+			}
+		}
+
 		if (buf)
 			data = buf + BNXT_SEG_HDR_LEN + extra_hlen;
+
 		seg_len = bnxt_copy_ctx_mem(bp, ctxm, data, 0) + extra_hlen;
 		if (buf) {
 			bnxt_fill_coredump_seg_hdr(bp, &seg_hdr, NULL, seg_len,
 						   0, 0, 0, comp_id, seg_id);
 			memcpy(buf, &seg_hdr, BNXT_SEG_HDR_LEN);
 			buf += BNXT_SEG_HDR_LEN;
-			if (trace) {
-				u16 trace_type = bnxt_bstore_to_trace[type];
-
-				bnxt_fill_drv_seg_record(bp, &record, ctxm,
-							 trace_type);
+			if (trace)
 				memcpy(buf, &record, BNXT_SEG_RCD_LEN);
-			}
 			buf += seg_len;
 		}
 		len += BNXT_SEG_HDR_LEN + seg_len;
-- 
2.39.5



