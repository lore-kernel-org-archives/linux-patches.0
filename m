Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDC17B3E5;
	Wed, 21 Feb 2024 13:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521573; cv=none; b=PitYd0wUnwposGHxGYTgzjoQLz/JoBOvjnHdEQ4YeeF7BZTaM6/9fPKTzpWmGhsukcaveI189xrwfFaIsTub9bq6YouGxvmiXwRbmmKBHqIS5WEyzQGO99GjMTv2rU8EGOy8HS50xd/UUfABP77o5nYOLC/yGLbuvkAT8q7P9Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521573; c=relaxed/simple;
	bh=zI2uQRdr+yOMvXaLcE3cQYT/0C7cGRMli1AKcZPuM1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYDGsjEn7eVJT9rEmq6T+MalKGV/El9GjT4UkrVzm2m9cnRjJkpdK/oogKP72tk6WzDTC58M0YYj+eoHPIaxejdkCFYeDmXCm+P+tekSu0Q5tNx0TV+ZxHRRBvPZLsb+VFj9xJIehBy1Wf/Tz58vBwU76T5BJLjYilEjo28PF6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djIhrgMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djIhrgMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF646C433F1;
	Wed, 21 Feb 2024 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521573;
	bh=zI2uQRdr+yOMvXaLcE3cQYT/0C7cGRMli1AKcZPuM1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djIhrgMAJUiyZ8x6m02GuwOUVS2eBHc3XUiBpgdb72kahAL0z3I4IfLUyAadylSzw
	 ZpHqncCoYvBViKcw0VaOEVF9DneUmaSye/uith8rbMAqg1d+OxetdrAXJpsSRzWFKw
	 qzoZZTD/mGVekQ2YR0uKM4pDWfIhcLgRUPGC2GPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/202] atm: idt77252: fix a memleak in open_card_ubr0
Date: Wed, 21 Feb 2024 14:07:29 +0100
Message-ID: <20240221125936.488198157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit f3616173bf9be9bf39d131b120d6eea4e6324cb5 ]

When alloc_scq fails, card->vcs[0] (i.e. vc) should be freed. Otherwise,
in the following call chain:

idt77252_init_one
  |-> idt77252_dev_open
        |-> open_card_ubr0
              |-> alloc_scq [failed]
  |-> deinit_card
        |-> vfree(card->vcs);

card->vcs is freed and card->vcs[0] is leaked.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 3380322df98e..36629633ae52 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2936,6 +2936,8 @@ open_card_ubr0(struct idt77252_dev *card)
 	vc->scq = alloc_scq(card, vc->class);
 	if (!vc->scq) {
 		printk("%s: can't get SCQ.\n", card->name);
+		kfree(card->vcs[0]);
+		card->vcs[0] = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.43.0



