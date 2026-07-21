Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E62DECDF;
	Tue, 21 Jul 2026 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659848; cv=none; b=oJPdYHm8bHbMiTu+GlAS/u7TRkE0GxjuiIYKggKzZMG9GBSiQTQEp7ym43ax59YKI2cfgtuesuEcLCcB8pOiiOMwO5O4xNLOte+J+ky8mpbWSlsVXEWzwA41R9t3580jyEoJ3zUHbi5x4bI83EcwTV3I9zYlvCnEBakD47XK4bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659848; c=relaxed/simple;
	bh=mmiPr5TuLiByP1cJYCztrnaOnDN40GqAW0uB3Ft43ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOspDzTmH1lsnrVMaeyIZH6EaRzW8UnROwweSYbCDp3fkMV45K/+TT2umqL0d7hAhEP5RnoFqcgLf3yLOy8tHyjsyOM6Ib8r1TKcaqOIx2MO1PjwnkQ7xixpVPpOV0V++jvsq5cbrngWjvhB5J6L4CfOArytyKeHXe4JNXqZmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5e6XNSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5e6XNSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED501F000E9;
	Tue, 21 Jul 2026 18:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659847;
	bh=T3D6xhKyV4e2Lz63uH9qx71WmUniyfCeyMc+XDegtJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5e6XNSu/hT2BzFrHL/Srx10xT7xA3cGsijd4qXnYrZscC6nbxZRA2NAXCtSftc3X
	 RH/eRBdb1bxsJfZSIiXHGo3vZN5euvcvnBEAsgezSjlUfF6RJoZem0de/sJIV1WJE9
	 OBOf4Vd9YNfRG43XSXFeJfyqVU8NvQ7C2f4SCr/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0756/2077] net: airoha: Fix error handling in airoha_ppe_flush_sram_entries()
Date: Tue, 21 Jul 2026 17:07:09 +0200
Message-ID: <20260721152610.622088921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit d7d81b00301398fcd38cf5b5869f0fdb674472ef ]

In airoha_ppe_flush_sram_entries(), the outer "err" variable was never
updated when the inner loop variable shadowed it, causing the function
to always return 0 even when airoha_ppe_foe_commit_sram_entry() fails.

Drop the outer "err" variable and return directly on error, propagating
the error code from airoha_ppe_foe_commit_sram_entry() correctly.

Fixes: 620d7b91aadb ("net: airoha: ppe: Flush PPE SRAM table during PPE setup")
Link: https://lore.kernel.org/netdev/6a2b40e4.4dd82583.3a5c46.e52f@mx.google.com/
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2bd37a.4034e349.1b41bb.1caf@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 5c9dff6bccd1e3..a124f15345a916 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1330,7 +1330,7 @@ static int airoha_ppe_flush_sram_entries(struct airoha_ppe *ppe)
 {
 	u32 sram_num_entries = airoha_ppe_get_total_sram_num_entries(ppe);
 	struct airoha_foe_entry *hwe = ppe->foe;
-	int i, err = 0;
+	int i;
 
 	for (i = 0; i < sram_num_entries; i++) {
 		int err;
@@ -1338,10 +1338,10 @@ static int airoha_ppe_flush_sram_entries(struct airoha_ppe *ppe)
 		memset(&hwe[i], 0, sizeof(*hwe));
 		err = airoha_ppe_foe_commit_sram_entry(ppe, i);
 		if (err)
-			break;
+			return err;
 	}
 
-	return err;
+	return 0;
 }
 
 static struct airoha_npu *airoha_ppe_npu_get(struct airoha_eth *eth)
-- 
2.53.0



