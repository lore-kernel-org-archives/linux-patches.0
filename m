Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBFC5FDDF;
	Tue, 13 Feb 2024 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845364; cv=none; b=mbFjcFWp5ZlLBBSLqPiFnLoxAWjuK7On1TS25Cl/sgwp/jD3d6A8Lu0skXoIH3UY/y2LbhUQg7f0wL7VWlB5NuJ4p9IDya/SWVVR+d9PhggPJq5EZ5BdLm+MWy7GBweZp9cSXRjuhXGVQTt9i+T+v//eGWUqYS4udyBDdGb9+do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845364; c=relaxed/simple;
	bh=GOSZNMpepZSiRXQb6OCR0aA+kwVSo+yAJoDC7Siw2Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIy8cKpznxXtHnJbssN1nSM12rJBds6/UzWZGX2HMVo+1RGCP//FNMh+HGO4dAZuD3xwIuH6VECF7jEE1xNNXzhKKL4elZUFl+ODim9CUJhRYagIX1M170XrTsbps4DFA8hRbdfXnC+LE7+5bx2dD1E2dWnpFF2ToFA1+OpYj84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzGazTuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzGazTuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C5C433C7;
	Tue, 13 Feb 2024 17:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845363;
	bh=GOSZNMpepZSiRXQb6OCR0aA+kwVSo+yAJoDC7Siw2Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzGazTuAplnC+J9UghunL9XHR/gYTgMnh56YHsIR6xaWZUUXmRlt/1RSAh+58Tjcg
	 W7DbL+XNoP1KkncaRZc287DkvIbos8bLtyepCBwmFkdA97dkuW5uoPktLnf4DVd452
	 xMv7mueXCZIPYHW5f/VrrWgxfZ/ElSVvTHWmaX3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/121] atm: idt77252: fix a memleak in open_card_ubr0
Date: Tue, 13 Feb 2024 18:21:07 +0100
Message-ID: <20240213171854.688032569@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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
index e327a0229dc1..e7f713cd70d3 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2930,6 +2930,8 @@ open_card_ubr0(struct idt77252_dev *card)
 	vc->scq = alloc_scq(card, vc->class);
 	if (!vc->scq) {
 		printk("%s: can't get SCQ.\n", card->name);
+		kfree(card->vcs[0]);
+		card->vcs[0] = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.43.0



