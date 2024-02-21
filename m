Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3E17CF33;
	Wed, 21 Feb 2024 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524478; cv=none; b=pD8Nu3kOVbEaBnamH2JiFLjemcOdnNPiOFM0R69g0IN+iGLfkACpeY9oXm97h5rPZSbzWSKVkUhlDHriCDeZ0MxTDP1ToH6RSPItTamX+L+6AeTXU+He5l2sByWAuTlH+LGlvFm+1Z8n+Er/cwT3+HAdSGok1DdCAjWdaFv+n5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524478; c=relaxed/simple;
	bh=qyn/kM6crTrvXZeyiQqoiLrjW7McniMEEJ/ky9Qk4P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtjV5NtrqSxifKxrsWpK0Ep8QwMDmoeHI9lCSYRWVeZGLLzNdH8TwfFrTpUpWZZjED10MEnCuQneD9oNgTR++0Bq8FwaXbVjqFsD/0r638qTZRchUIkYMmdoXdVPnTGSGu4R0TzfADjZXuy5olLvkRv4X5hsirAaqLbvCqeH/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8ZvaKaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8ZvaKaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A065AC43390;
	Wed, 21 Feb 2024 14:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524478;
	bh=qyn/kM6crTrvXZeyiQqoiLrjW7McniMEEJ/ky9Qk4P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8ZvaKajBw55vvcw9zzpoynh+aVmUXGyYoSpDqFYzV5yBtda5IkgmNNK51s0xp4It
	 zbwoDF4LYKGHnOpOonxuUB8IJd0u8C/KQB4bI3H1Vuu5J2xFZiVXPcFXDfp/dRBZzG
	 MBqnlHCE2m7nYjOlNR+B31CR/K1z9Sl0NksiFLHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/379] atm: idt77252: fix a memleak in open_card_ubr0
Date: Wed, 21 Feb 2024 14:07:16 +0100
Message-ID: <20240221130002.521263241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index a217b50439e7..e616e33c8a20 100644
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



