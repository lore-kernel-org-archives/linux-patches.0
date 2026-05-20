Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36AD3EDACC;
	Wed, 20 May 2026 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298992; cv=none; b=oL75pBNLDTB/EXdwqNYd0ae7j31I4beSOgqvDSk9d3unpnUE0klQAoHA3hq/g1tD6UpzgpxkXluOHuGtSpqkgW2vBxM1VDz2gHpsW7I5YhtkXH8DS/fsC36thTvVan151oC4IHkaj75lj0XE67z2SYwoHRXovvV5WGq2Hjf5kqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298992; c=relaxed/simple;
	bh=h4WyGgBazxHcUGs9QLC9KkG9n70xGtytQQWaR714Su8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjidRkdxlrFUnuFlq8MejAPPMZnJlocxFdcPJQj4hrPI+chPbU1eUutFp+Ik1i/pVmil8LhBYtGTdLSz6JofYiOncRpZRtSU0pxH4/h7P4bgZQHkFrYhCcJBNgRQe8peA0R0q8PCD3O/rZ11iKpZ0KdBZEeZRQWQd9yLp4vg0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gcab69bh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gcab69bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFED1F000E9;
	Wed, 20 May 2026 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298990;
	bh=/NdUEoC2MY9oiS1BUYCbYxQ4iIn+TdEtuN0gqcjW7do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gcab69bhdCLDay0m2SiMgPpKq5jUQOrL7ZaMsDgu+MdXz1F48abKzFPrrtUu/HBPo
	 JtR0gUSZTaTAz1kcG1AD8BroWsIvTprwcu673eoVmsfevqPXqfskdSWctSTQ3Lc/MD
	 5h4hjsPwNIzF//rocFEQuKxIXDNf97Y1+4ex5JHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuwei Wu <shuwei.wu@mailbox.org>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 580/957] clk: spacemit: ccu_mix: fix inverted condition in ccu_mix_trigger_fc()
Date: Wed, 20 May 2026 18:17:43 +0200
Message-ID: <20260520162147.109025023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuwei Wu <shuwei.wu@mailbox.org>

[ Upstream commit 54e97360b44bed6b4399dd3be3d65f392df940fa ]

Fix inverted condition that skips frequency change trigger,
causing kernel panics during cpufreq scaling.

Fixes: 1b72c59db0ad ("clk: spacemit: Add clock support for SpacemiT K1 SoC")
Signed-off-by: Shuwei Wu <shuwei.wu@mailbox.org>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://lore.kernel.org/r/20260305-k1-clk-fix-v1-1-abca85d6e266@mailbox.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu_mix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spacemit/ccu_mix.c b/drivers/clk/spacemit/ccu_mix.c
index 67f8b12b4f5b7..9a3fc9ea1ce56 100644
--- a/drivers/clk/spacemit/ccu_mix.c
+++ b/drivers/clk/spacemit/ccu_mix.c
@@ -69,7 +69,7 @@ static int ccu_mix_trigger_fc(struct clk_hw *hw)
 	struct ccu_common *common = hw_to_ccu_common(hw);
 	unsigned int val;
 
-	if (common->reg_fc)
+	if (!common->reg_fc)
 		return 0;
 
 	ccu_update(common, fc, common->mask_fc, common->mask_fc);
-- 
2.53.0



