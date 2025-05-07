Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E836129A0;
	Wed,  7 May 2025 19:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644663; cv=none; b=vCi4tR8hFrAtgMyow/ks0S7FmRpbHGdwOEoibqPNLS2FwEe2noN7cG81+JebQ16OlNtZQhQ5H5Kk0mruB5PpUxwz3r3wf6kcJHfRaM2DdGkX/Czix/f7tu6OvRUEhgv6nHL2l29xLFXYnkIoDEGPfVuRngq4Nl+m+5TTec4m1vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644663; c=relaxed/simple;
	bh=BNJ8b+ky+yw/ZUMfFL8wJzn3yZr1vSXY3g58FjvSZ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRRHwHCEQ7E3Frh0/7/0bGMrCOR0e2P0djdEgJ4Aj6ucdcgumng+jd1JZVPm1reSzdebjTBJuvpIQWcAYtr7WZ4VSM9M7EHqjA26XnO9QA4A7UStqkfNO7Lzy/Ys62T2TtOfteiRb6DWuHCI68I0sOHcfo6R3cv4IN6TvqjWACw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyC9Dkb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyC9Dkb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607CAC4CEE2;
	Wed,  7 May 2025 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644662;
	bh=BNJ8b+ky+yw/ZUMfFL8wJzn3yZr1vSXY3g58FjvSZ1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyC9Dkb8troCba0B5ktUnZisrgzIADVKHf8GvjmwDxdOoTnzxycFyIyeVr+G3n+CG
	 nOAnAvf9WJ2Uz4rgGIdBHBIovidKQRFvjObjW6zgJgdpA/axk8eXfa0s/u+98s5ixA
	 FVfMfWuc6aE/hSTy0jKmqsQNsrX9k39EkIxRgF2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/164] bnxt_en: Fix coredump logic to free allocated buffer
Date: Wed,  7 May 2025 20:40:00 +0200
Message-ID: <20250507183825.628588947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e2b938ed1f7e..651d3b1d153e0 100644
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



