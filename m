Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D34D1D14B;
	Mon, 18 Dec 2023 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtQjlXed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C44C433C7;
	Mon, 18 Dec 2023 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908071;
	bh=9Wjclo0jD3ZZFpcKHif7SIDziNyja8oqgsZU6J9xK5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtQjlXedI+Co9ZnPSJTpaH67qThVNHvXe4Q52V88Qj1gMYefwDIhO/lwvlceYpRUp
	 HYliiKLjPQztSF6VUjEOtzdYsfquh2dPfpyhzRFb8cIH1rm8PWI4WluKktfj2mJKvz
	 GTcMtaVsr9qgo17RQYO6KJSXajmWIeaS1W44CZ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/166] qed: Fix a potential use-after-free in qed_cxt_tables_alloc
Date: Mon, 18 Dec 2023 14:50:08 +0100
Message-ID: <20231218135106.882294172@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65e20693c549e..33f4f58ee51c6 100644
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



