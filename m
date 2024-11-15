Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850FF18785C;
	Fri, 15 Nov 2024 06:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652848; cv=none; b=ryagdjHte0he9FATdfxpvqy9b+8dD2AkvTjtGHlgxHl08j4lXaC3Pl9ofXngULrvB1JHJJDXMS7z5kQiAjp3+aWqFtHceftUcyO9lI90+ACfJagWb8phvNfMZJg0WIUpkdGoDQPh2zAW+yV+s3XWpyEcf3FT7OZUeNRyNsQLbwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652848; c=relaxed/simple;
	bh=nNk+64xjZ6HpHKnWrucrqCPse7bfSWOXXz3JqdGkwe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikqmMb8jG7B8Cq0gqknE2djh5zBHwvkeo/ALyFy+zMmZmRAVWE16Y0ORCDAnyqyTdtykmkYDiVWiNp/DPIXJlvf/3rQATwqJDNg+QBtuBVWvMh4bdGOKRROn4G2rKrn1iIpy+xRvuOZDyJp83TdLawh5QZKKsDct1nmbz9BxruI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAMji8us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAMji8us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF003C4CECF;
	Fri, 15 Nov 2024 06:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652848;
	bh=nNk+64xjZ6HpHKnWrucrqCPse7bfSWOXXz3JqdGkwe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAMji8usCCXV5KxBoUBMMHzE/5UV8Q+WFIzIBpH/pw3W1RscWvohLlfCKx30K2Wf+
	 LSgU2L3KxR69bE6l3XYciRxC4RZHAlK1vw5XeWtDTNFe/oEuzVVckOfQq91CIoyeSN
	 zGOgxLSe5Sw6zvgogl+9aIegK4KViUyXWn02dQX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 4.19 31/52] usb: musb: sunxi: Fix accessing an released usb phy
Date: Fri, 15 Nov 2024 07:37:44 +0100
Message-ID: <20241115063723.983598490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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
@@ -286,8 +286,6 @@ static int sunxi_musb_exit(struct musb *
 	if (test_bit(SUNXI_MUSB_FL_HAS_SRAM, &glue->flags))
 		sunxi_sram_release(musb->controller->parent);
 
-	devm_usb_put_phy(glue->dev, glue->xceiv);
-
 	return 0;
 }
 


