Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C883F2144B5;
	Tue, 12 Nov 2024 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408419; cv=none; b=l9/OBDxXNKiKLu1X8eBuEKdxVrUZ0zKt1RqPlalMiwGDf6pFpp+Tp67WCtEcQjLF0Ave5U1Uzck/WV397hPXSUZGjIoGt6roLi1Xua1PPFrk++zR9gtie//0Sr3xcvNO1M/oVURTBXqN6TLbercgMEaL1WHW7Alh5w1voqAew/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408419; c=relaxed/simple;
	bh=YAKjjb3neQHtNmYmCA69sCC/dMlmyyirr5Mqa1MfGTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHpDZi2uxgfH2czZg6KIFJ4IKxmZsntTGdYbCaMuz3HO2jt9x7NB0w3ecPAqGh8dlWABksbc2/D3N24bMvUiZaeOcEc6PsGSXZPJG/8DxKzo2Rxn7G/aJZ9GWSekBe7Q2KuISKQwIxIXzbhZC5lWSNc1zBAo6cpGxOhZAKPRNVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZYTil4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZYTil4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF93C4CECD;
	Tue, 12 Nov 2024 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408419;
	bh=YAKjjb3neQHtNmYmCA69sCC/dMlmyyirr5Mqa1MfGTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZYTil4XcpkhehUV7h1J68RX/W+jcOSroVE+IGQJjpxhdXvn2UOBZ1dZJNm9wnJXA
	 J56nJRBfSV+aCCEPhdqI/ECoNNpjkrR4zudLwO6B3+N40ivAYV0ZwaPQyGOkKiTkbA
	 40HMvMnU+ESB1xh312E49LOVMXRD/TuCz2EY5ijg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.11 156/184] usb: musb: sunxi: Fix accessing an released usb phy
Date: Tue, 12 Nov 2024 11:21:54 +0100
Message-ID: <20241112101906.858393911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 498dbd9aea205db9da674994b74c7bf8e18448bd upstream.

Commit 6ed05c68cbca ("usb: musb: sunxi: Explicitly release USB PHY on
exit") will cause that usb phy @glue->xceiv is accessed after released.

1) register platform driver @sunxi_musb_driver
// get the usb phy @glue->xceiv
sunxi_musb_probe() -> devm_usb_get_phy().

2) register and unregister platform driver @musb_driver
musb_probe() -> sunxi_musb_init()
use the phy here
//the phy is released here
musb_remove() -> sunxi_musb_exit() -> devm_usb_put_phy()

3) register @musb_driver again
musb_probe() -> sunxi_musb_init()
use the phy here but the phy has been released at 2).
...

Fixed by reverting the commit, namely, removing devm_usb_put_phy()
from sunxi_musb_exit().

Fixes: 6ed05c68cbca ("usb: musb: sunxi: Explicitly release USB PHY on exit")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241029-sunxi_fix-v1-1-9431ed2ab826@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/sunxi.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/sunxi.c
+++ b/drivers/usb/musb/sunxi.c
@@ -293,8 +293,6 @@ static int sunxi_musb_exit(struct musb *
 	if (test_bit(SUNXI_MUSB_FL_HAS_SRAM, &glue->flags))
 		sunxi_sram_release(musb->controller->parent);
 
-	devm_usb_put_phy(glue->dev, glue->xceiv);
-
 	return 0;
 }
 


