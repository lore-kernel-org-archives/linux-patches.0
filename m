Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4A228B7EB;
	Wed,  7 May 2025 18:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643440; cv=none; b=RNORRq96J/u3i75yCvmXL5CATR7VenHUlDPiq3s1ADbZJF31Td/OTxH4loHOXfpATmRWxLeBJylxx6Y7nHzRiuniRasK7EAaW87KHPq6sIjxbQGdUbBKtx0pIF5bAXTCl0/C90FNhyucmZE/MhcgGNV6i7xIGn/jPUTELvMbFQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643440; c=relaxed/simple;
	bh=J/O9n9DI4kG/8namTe6ctaZRm1YlffnEByPs95EwKWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAi0u7h6xIrWvg3wOovpvy4IIK0wKyZY7zVQByiqYV7yzYZgqXw+DIKZ4Kpa5ysALu5DCGh7H+SoJG73Y7N8m9cQvqtctB6t0Mvi4nnHXGSp2p4wbFX3Giya3QHBhIMt8dJgz01dpx2GG1cnTrajnGpF2CPKAu2EiS/kG3Gm/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nks444tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nks444tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8F3C4CEE2;
	Wed,  7 May 2025 18:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643439;
	bh=J/O9n9DI4kG/8namTe6ctaZRm1YlffnEByPs95EwKWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nks444tZrtXtDn+dFgvaYidGuMWIZE+s8D0P5dJVI3H0On15dx8KQ8vqQehlq5jQ2
	 OD1cTz71tkR2MwC+EFTRTs5l88CxMTMfPqPbdMV9m1LjTeysWlu4/MR1sKZT7OyaY0
	 ZjuZn51pUxFolTIN+HedncPbV6D09u5p4qKQQex0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/55] bnxt_en: Fix coredump logic to free allocated buffer
Date: Wed,  7 May 2025 20:39:32 +0200
Message-ID: <20250507183800.293707749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

From: Shruti Parab <shruti.parab@broadcom.com>

[ Upstream commit ea9376cf68230e05492f22ca45d329f16e262c7b ]

When handling HWRM_DBG_COREDUMP_LIST FW command in
bnxt_hwrm_dbg_dma_data(), the allocated buffer info->dest_buf is
not freed in the error path.  In the normal path, info->dest_buf
is assigned to coredump->data and it will eventually be freed after
the coredump is collected.

Free info->dest_buf immediately inside bnxt_hwrm_dbg_dma_data() in
the error path.

Fixes: c74751f4c392 ("bnxt_en: Return error if FW returns more data than dump length")
Reported-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index 156f76bcea7eb..e0e7bfaf860b7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -72,6 +72,11 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
 				memcpy(info->dest_buf + off, dma_buf, len);
 			} else {
 				rc = -ENOBUFS;
+				if (cmn_req->req_type ==
+				    cpu_to_le16(HWRM_DBG_COREDUMP_LIST)) {
+					kfree(info->dest_buf);
+					info->dest_buf = NULL;
+				}
 				break;
 			}
 		}
-- 
2.39.5



