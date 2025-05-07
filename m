Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593862144C1;
	Wed,  7 May 2025 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645066; cv=none; b=k4C5ipf96UsVzyKWXDEWaS4m0NsYhrREvV74LMFjaFnjp5NY14nhe7A+JqelhbRBS6tpsxpW4b+uZdfsT6mQV6ECkIZpiE5lQonu4oKwV/b8LKUXVChi9UpIlmEhTG0DwzibqouYS1l/lijaxT1ivuWUH2eTa3L5ZPvdKnN2q54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645066; c=relaxed/simple;
	bh=juCrpGP+HEq642McXKT/XSsLlohYL4NTnIocdvNitTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKZS4blsJ7X+fgMZji6t/vYI+vAjCtzLTEvJgbe/bcYHk+1Ve86agz0F6gZHbSYbXF5p3ubfNVyzCb+X/3kIN1Dh4ve9mjmVAPEPsJ6JAti/mSrBTVGtpfTij2Yg6p6XHqEwtoaL8Fr3dMRxQAf8BS661EoXeYqdzQD/7osse2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjtKmIgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjtKmIgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E299FC4CEE2;
	Wed,  7 May 2025 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645066;
	bh=juCrpGP+HEq642McXKT/XSsLlohYL4NTnIocdvNitTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjtKmIgMLgN6yNwi/KNoHsSnhTWxbz15ZcnMcegpEas+TAv0rI4V1TVoKy/+xDIVF
	 NAYdvodJvdJsZq3TgBFdaiun58WAbqltycC29mfVrmtD8zutTtEOl4mjwHSamWCtr1
	 4kuGAMTxCIj3uDEkd3KtdaDgmZhlXwbNZOavolkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/129] bnxt_en: Fix coredump logic to free allocated buffer
Date: Wed,  7 May 2025 20:40:17 +0200
Message-ID: <20250507183816.792598767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c067898820360..b57d2a25ae276 100644
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



