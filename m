Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DDE407CCF;
	Tue, 21 Jul 2026 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658879; cv=none; b=dp7OknwpFbWI99XmaHEjvTSW5NS2qAWZFo7gpY9PAPx9KNo4cUxp3mWXSfoMZ6bRKIi60x5jgQZd8YlpdT6Fnn6F81YNY3vUgOAe2YmN6JWmWgrG4YuXp7lMm6C4gwcyouW2CaDN6Zqxx03muT2KPukPiVoLU1+n8rC5iEcaEyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658879; c=relaxed/simple;
	bh=c2jZJ9ZFsHQdw18c+2mV81Csfwg/6XEPv2P9rVqObSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHvlhT2eSzJ7SCjg1t/zk4FFWf8kUgTNLQfu9mxci0WvV/H4o4405nu4blZCHBXgBc2AA/sZo4YwFGECfBaemJL/eMtpNGq34gxxtDzMyPOABIuSC42ujcHuJU2/ya0PF10tnezL5duMyDBP1kvLXm25hUP8ivHeoq0YtNqNSms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jedYuKYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jedYuKYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BC61F000E9;
	Tue, 21 Jul 2026 18:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658877;
	bh=Lr/RMIL0EM5ulnSEUkU7YrrSofV48VRG58O52wXIm1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jedYuKYCnohg9WjRCfQxdscUvmu7KEdXgWKjLBq9fJoVD6h4tWOnHUpZEAahj4yV7
	 EWs+84D0pxQJlBt8rB3RCIsOtSLqRdXfsrtfTrPmTLvsXeBamsc81pDtk4HO+dJdB7
	 qSUEh/ieik5PZAQZIe+ZMC4sr2ooZoe4Y73Ok1lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 1311/1611] i2c: spacemit: fix spurious IRQ handling returning IRQ_HANDLED
Date: Tue, 21 Jul 2026 17:23:47 +0200
Message-ID: <20260721152544.942648415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

commit 9db20d23aac7916ff49be409a4bfd48fe7cbbfb4 upstream.

When the interrupt status register reads zero, the handler should
return IRQ_NONE instead of IRQ_HANDLED. What the return value
actually feeds into is the spurious interrupt accounting in
note_interrupt(): falsely claiming IRQ_HANDLED defeats the "irq XX:
nobody cared" detection, so a stuck interrupt source would never be
caught.

Fixes: 5ea558473fa3 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Cc: <stable@vger.kernel.org> # v6.15+
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/ef8b623f45d4e430721e46572c2598d882044aed.1783667875.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-k1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -425,7 +425,7 @@ static irqreturn_t spacemit_i2c_irq_hand
 
 	status = readl(i2c->base + SPACEMIT_ISR);
 	if (!status)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	i2c->status = status;
 


