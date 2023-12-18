Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A97129EF9;
	Mon, 18 Dec 2023 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXLqmA8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF907C433C7;
	Mon, 18 Dec 2023 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908525;
	bh=WY4nEdYZnNRCbbE1zF8SuozvySNat8+FMoHY7qNSa+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXLqmA8NctVJ6w+8L/SF9YNtIjM42yZmW38bid9t0bMJN07g2Fby48XnrlwUbZGZV
	 OHLct7BSjMf43WkeRRjbhp7yx1NlWFX15F+nUSEkVTlgIHtWLoblNLg9Vt5Cngsn0l
	 zhoZ3ALkwnxvwT6vBk/xLQlRKllz/bikTexl/Mck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/62] qed: Fix a potential use-after-free in qed_cxt_tables_alloc
Date: Mon, 18 Dec 2023 14:51:38 +0100
Message-ID: <20231218135046.862604516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

[ Upstream commit b65d52ac9c085c0c52dee012a210d4e2f352611b ]

qed_ilt_shadow_alloc() will call qed_ilt_shadow_free() to
free p_hwfn->p_cxt_mngr->ilt_shadow on error. However,
qed_cxt_tables_alloc() accesses the freed pointer on failure
of qed_ilt_shadow_alloc() through calling qed_cxt_mngr_free(),
which may lead to use-after-free. Fix this issue by setting
p_mngr->ilt_shadow to NULL in qed_ilt_shadow_free().

Fixes: fe56b9e6a8d9 ("qed: Add module with basic common support")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20231210045255.21383-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 0a22f8ce9a2c3..1c3737921b6cf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -933,6 +933,7 @@ static void qed_ilt_shadow_free(struct qed_hwfn *p_hwfn)
 		p_dma->virt_addr = NULL;
 	}
 	kfree(p_mngr->ilt_shadow);
+	p_mngr->ilt_shadow = NULL;
 }
 
 static int qed_ilt_blk_alloc(struct qed_hwfn *p_hwfn,
-- 
2.43.0



