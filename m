Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E52F2116E9;
	Wed,  7 May 2025 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644119; cv=none; b=BrVcAXx08+nRuE1YUIz9gwaIai1WRMkJJslHxGsQZOn0DVeny8iypMlQsJaRjRyO+zFDj+oE8KhOKoPTHKC0Fe/8AEGfJuoMlb+y/Rkt/oIYAefPCvFceGw5TY4a4LMZ4jWTsqaluc0gGHL34fpCsPpnjTvP3pJivhnAimFxiE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644119; c=relaxed/simple;
	bh=0aOdiSW8wGyBkmyDauM2mNCJ/20stk9RmFclJgrADh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yuih3ZSzgQ7UeeYIDCKAdpuq0qxi4sI58ky7nRk/Mgy9X4S/arpBN5ltifdlT2zo4OzTChH3/REXNkHOiyPPxk1WJPsFkkiM7R+rbE0BK9nnZRr2FtXixFLplA4fruAA/8vtJLD4qxgJ8sbeLoUdJlJ8PhWrjun8nvlCa5Uuxl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfrzXqnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfrzXqnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D28AC4CEE9;
	Wed,  7 May 2025 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644119;
	bh=0aOdiSW8wGyBkmyDauM2mNCJ/20stk9RmFclJgrADh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfrzXqnnHo6EnRJGxsFN7WDaKcb9Fi9VYNdPzW+wWgwlX0ed1QZDV9jEwwVXAaN0Y
	 g1PX6e2a7dgFlCAkv6qDDMJ6EmehTOGKCvicEcMR/tQFPVg1usnpaptrO47NPFmEy9
	 3EC05MSs0LByaPaktSoVI9Zzx1xpGvcoEyP0ntsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 126/183] bnxt_en: Fix out-of-bound memcpy() during ethtool -w
Date: Wed,  7 May 2025 20:39:31 +0200
Message-ID: <20250507183829.920991619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Shruti Parab <shruti.parab@broadcom.com>

[ Upstream commit 6b87bd94f34370bbf1dfa59352bed8efab5bf419 ]

When retrieving the FW coredump using ethtool, it can sometimes cause
memory corruption:

BUG: KFENCE: memory corruption in __bnxt_get_coredump+0x3ef/0x670 [bnxt_en]
Corrupted memory at 0x000000008f0f30e8 [ ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ] (in kfence-#45):
__bnxt_get_coredump+0x3ef/0x670 [bnxt_en]
ethtool_get_dump_data+0xdc/0x1a0
__dev_ethtool+0xa1e/0x1af0
dev_ethtool+0xa8/0x170
dev_ioctl+0x1b5/0x580
sock_do_ioctl+0xab/0xf0
sock_ioctl+0x1ce/0x2e0
__x64_sys_ioctl+0x87/0xc0
do_syscall_64+0x5c/0xf0
entry_SYSCALL_64_after_hwframe+0x78/0x80

...

This happens when copying the coredump segment list in
bnxt_hwrm_dbg_dma_data() with the HWRM_DBG_COREDUMP_LIST FW command.
The info->dest_buf buffer is allocated based on the number of coredump
segments returned by the FW.  The segment list is then DMA'ed by
the FW and the length of the DMA is returned by FW.  The driver then
copies this DMA'ed segment list to info->dest_buf.

In some cases, this DMA length may exceed the info->dest_buf length
and cause the above BUG condition.  Fix it by capping the copy
length to not exceed the length of info->dest_buf.  The extra
DMA data contains no useful information.

This code path is shared for the HWRM_DBG_COREDUMP_LIST and the
HWRM_DBG_COREDUMP_RETRIEVE FW commands.  The buffering is different
for these 2 FW commands.  To simplify the logic, we need to move
the line to adjust the buffer length for HWRM_DBG_COREDUMP_RETRIEVE
up, so that the new check to cap the copy length will work for both
commands.

Fixes: c74751f4c392 ("bnxt_en: Return error if FW returns more data than dump length")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_coredump.c    | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index 0c0d833d19342..a73398c4a3e98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -110,10 +110,19 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
 			}
 		}
 
+		if (cmn_req->req_type ==
+				cpu_to_le16(HWRM_DBG_COREDUMP_RETRIEVE))
+			info->dest_buf_size += len;
+
 		if (info->dest_buf) {
 			if ((info->seg_start + off + len) <=
 			    BNXT_COREDUMP_BUF_LEN(info->buf_len)) {
-				memcpy(info->dest_buf + off, dma_buf, len);
+				u16 copylen = min_t(u16, len,
+						    info->dest_buf_size - off);
+
+				memcpy(info->dest_buf + off, dma_buf, copylen);
+				if (copylen < len)
+					break;
 			} else {
 				rc = -ENOBUFS;
 				if (cmn_req->req_type ==
@@ -125,10 +134,6 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
 			}
 		}
 
-		if (cmn_req->req_type ==
-				cpu_to_le16(HWRM_DBG_COREDUMP_RETRIEVE))
-			info->dest_buf_size += len;
-
 		if (!(cmn_resp->flags & HWRM_DBG_CMN_FLAGS_MORE))
 			break;
 
-- 
2.39.5



