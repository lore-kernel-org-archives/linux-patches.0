Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B3E46EF92;
	Tue, 21 Jul 2026 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657011; cv=none; b=LA45OKyDyjpStewesUJGc0dDtek7yUsEXI7XHIDGGsa9bSGssMBNRHV9czDNVKvjm/b17dAZlztebVGMa+oxu8vXIc6zpNNHx4Whqbxj1iJoJOe+7hgcy0rwiUiNhU9UmBKZ8EsSMGggLGq7FgfFb5fiP6T/m5S2HjLJpYgZnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657011; c=relaxed/simple;
	bh=ha9ktEbahbGBYwjl6QqCJKXQQJUCsjHAD0ahknuazDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahczlZsN/kDSe7/rAkwKwnvPRB27M+ub1sHy8qnbcV/u2IOquPxfhijoKWiy28FfitYBEauSqQ0dLvAFMciLWevE7HwfO00v1S10yYyxhfjh2VPwtDYtESjbKVR+gFvDi1zJxGDfPo5GBCHnvAlfG4m482S6DIwIZ680tTWlAv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iithGOFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iithGOFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA451F000E9;
	Tue, 21 Jul 2026 18:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657010;
	bh=gbHvQvGTm7jaBoIQQTcvjjWn7W5/YXqGBEBHWIZ5cOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iithGOFB4tI1jcwvOEWWoexD6/MAe76DOK9gRdp7zBAF05fNy/O9S4QvN16lxNrso
	 77yBa6TOTTZ+oPqaEGKxxKQE8VOoThhZiByVqtcZKSy5UujFK5Sth1Sa36h52HBwin
	 qNoijLQ9Q2CbBpdvNXAUSubMO59R/71RwdQ0CH9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0601/1611] mailbox: mpfs: fix check for syscon presence in mpfs_mbox_inbox_isr()
Date: Tue, 21 Jul 2026 17:11:57 +0200
Message-ID: <20260721152528.904925390@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit e30d8b2730a33e5e8789371e947c3529789a6070 ]

mpfs_mbox_inbox_isr() writes to the sysreg scb syscon, not the control
scb syscon, but checks for the presence of the latter. Ultimately this
makes little difference because if one syscon is present, both will be.

Fixes: a4123ffab9ece ("mailbox: mpfs: support new, syscon based, devicetree configuration")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index d5d9effece9797..ef40fe2be30d65 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -201,7 +201,7 @@ static irqreturn_t mpfs_mbox_inbox_isr(int irq, void *data)
 	struct mbox_chan *chan = data;
 	struct mpfs_mbox *mbox = (struct mpfs_mbox *)chan->con_priv;
 
-	if (mbox->control_scb)
+	if (mbox->sysreg_scb)
 		regmap_write(mbox->sysreg_scb, MESSAGE_INT_OFFSET, 0);
 	else
 		writel_relaxed(0, mbox->int_reg);
-- 
2.53.0



