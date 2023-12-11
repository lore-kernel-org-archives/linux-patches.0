Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482FA524BC;
	Mon, 11 Dec 2023 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLUdF2bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A2DC433C8;
	Mon, 11 Dec 2023 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319976;
	bh=1sz6tEuegC8Zr+D/0rjDSHb5ViNUlPMmlL3vFmDFsYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLUdF2bpNrZ+6c9OsQggplOU3wW0JE1BKLnB8T7a3C+cdmB2xHXF4mR0kcSIUNBzO
	 Jz0O0NyL92zcKgcnE/L6u+q3RH1IvkVpTvXEc0vg39C0rZJkzewY9ewTI+UzwsowXl
	 UE5yiNC0HLQywTL+U5Rh0l77uhHQsSKFa/VR9nFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/97] net: bnxt: fix a potential use-after-free in bnxt_init_tc
Date: Mon, 11 Dec 2023 19:21:31 +0100
Message-ID: <20231211182020.984884342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d007caaaf052f82ca2340d4c7b32d04a3f5dbf3f ]

When flow_indr_dev_register() fails, bnxt_init_tc will free
bp->tc_info through kfree(). However, the caller function
bnxt_init_one() will ignore this failure and call
bnxt_shutdown_tc() on failure of bnxt_dl_register(), where
a use-after-free happens. Fix this issue by setting
bp->tc_info to NULL after kfree().

Fixes: 627c89d00fb9 ("bnxt_en: flow_offload: offload tunnel decap rules via indirect callbacks")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://lore.kernel.org/r/20231204024004.8245-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 3e9b1f59e381d..775d0b7521ca0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -2061,6 +2061,7 @@ int bnxt_init_tc(struct bnxt *bp)
 	rhashtable_destroy(&tc_info->flow_table);
 free_tc_info:
 	kfree(tc_info);
+	bp->tc_info = NULL;
 	return rc;
 }
 
-- 
2.42.0



