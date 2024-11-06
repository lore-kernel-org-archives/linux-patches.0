Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B266120513F;
	Wed,  6 Nov 2024 12:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896830; cv=none; b=flUmGW9I8Ox56T42nDG4VLtKaV+f+SBORfGpZotfpxoeXrnLSWOD73kNjt70xADgZvELkTEU3lBaLIEB0NEHle6dmZlrj7BbdUNCOfKf1y/zZt00026BRNrFHCcj8vX7hNXPJ210TsrZHm8I83GVOU7OpqN31prQ84n8TObSNiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896830; c=relaxed/simple;
	bh=Ix6DEJhWZP9BoK2G07uYh/Bcl9YY4IHRpFCzzJa5TJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pbot2nYEq/0XFuxDRQn1RIK240+OycThXP64t/nIcFPoy46bEIwuwAOqxNlqyTUQU54ZaxHin+7N5W4ntE95cvuAVhsYsNY53feevLmYwHLv1/On5fZkSwJX+2fT7nGvlH0nz9fGOqxF16DNQX04zUes8hXT0czGmmOWxQ/D268=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOGhO3R8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOGhO3R8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0159C4CECD;
	Wed,  6 Nov 2024 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896830;
	bh=Ix6DEJhWZP9BoK2G07uYh/Bcl9YY4IHRpFCzzJa5TJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOGhO3R8egAuoFPkNL6D1wnI/CjCIVo13ucaqZ5oOMJRr/NlJDch/TnBwClmv5HCh
	 yedQLa+SalVgmQygsTGGahNeWrfTDmz+lezSlojTt9CFgXaddVW6CgcA0SPVk91xPY
	 aRLUjU/J5WEo9IA9qVs3U+yADTaxWi6sq1O3JnIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.10 086/110] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:04:52 +0100
Message-ID: <20241106120305.566993112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit fdce49b5da6e0fb6d077986dec3e90ef2b094b50 upstream.

For devm_usb_put_phy(), its comment says it needs to invoke usb_put_phy()
to release the phy, but it does not do that actually, so it can not fully
undo what the API devm_usb_get_phy() does, that is wrong, fixed by using
devres_release() instead of devres_destroy() within the API.

Fixes: cedf8602373a ("usb: phy: move bulk of otg/otg.c to phy/phy.c")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241020-usb_phy_fix-v1-1-7f79243b8e1e@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -590,7 +590,7 @@ void devm_usb_put_phy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
+	r = devres_release(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_usb_put_phy);


