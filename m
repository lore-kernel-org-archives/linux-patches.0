Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EFF37B40C;
	Tue, 21 Jul 2026 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654821; cv=none; b=ZyUeKIhfxV1uji3JuJIRdhn21mMXHIcqh27vu5M6IAnGbEfs+8C3UsTOUnazWv1x/76JiWKzXj7zPJTEeyhDBXKZADybPx9BndtbFMgOfemGe7JMr3y75zUkE4wlsikjHJxhiHDOT9765T9Pz3NYdMvxnOQdDP5TYSJXz/36CUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654821; c=relaxed/simple;
	bh=aJDZtX46h7k7ctw/2faLyuZ9MaV64q1Jb6x5smnckOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiJgIHTRGXTjf7H7eJTNYJ794k5kch9MM0t/Mt1UqoCV6N/+46ZfQN5iZxhVqN4vVuKahf9Kfi9zkJo7MmFn/p+lKlBo8ReyLXz2ZN1flrBxBK4Hxy/fhnpxaXHezBx8G4PEGHz6UdVSosreuDyMZJ0W1VyQpW652DsY4KWFjaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERTGGoEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERTGGoEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70F31F000E9;
	Tue, 21 Jul 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654820;
	bh=1i5362EdR3W+038KrO/NpPkx2H4E9Dd845hIfl5x9Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERTGGoEuoDdmYYhg0KdBrX1qAhE9fdaEZZ+Ifnzxr/3KlggJTJXLWOExR7hYADm6V
	 +w/teFktkUO/hAnZqgv0cYqo/bXFnDm1zjB8qB1wR6bvXq2nGWweATpERTP/wEf9IJ
	 m1Hdiem55CeKoKRkF7iJuCWd629gtDmvv/dJRpYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 1797/2077] i2c: spacemit: fix spurious IRQ handling returning IRQ_HANDLED
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152635.132887223@linuxfoundation.org>
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
@@ -596,7 +596,7 @@ static irqreturn_t spacemit_i2c_irq_hand
 
 	status = readl(i2c->base + SPACEMIT_ISR);
 	if (!status)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	i2c->status = status;
 


