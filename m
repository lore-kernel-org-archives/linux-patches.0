Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2EC1F80B2;
	Wed,  6 Nov 2024 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897106; cv=none; b=hHnxbYhImBZDyNq5gKha7FlIYQtyeo5Xas9khmmECU0RXs5mz/2SZA2iWBISketIiQVcK5AFlOB2+Gq0w9Wemk0Z+HwmnF+0fUdUh+uFQnz8dMOs7AEfQNrNnw7rBY+BhHKZaE+kcqdqDwteXiEkflR0iOVnJqvtkAxFgX9E27o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897106; c=relaxed/simple;
	bh=Db4+9+IYgjCallxSpYrdtOCYaD0xmXsEQI89OVRNZBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2kfOk2FwjdohCEM3iCu02ai7unrV74dIr6mBRzzzZ9p5SfpTrfexS6hvh8fitOWmbHRgHvEDT0nECSIw1Ba+aPqi8Eh04OISMzg28L6L/p7Mzzc1TtfvAvZr1MUO6p65FypD56YHeg+4IE0+9crt/iBAJOh15XHKrmwziBdZKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRuWveAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRuWveAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A274CC4CECD;
	Wed,  6 Nov 2024 12:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897106;
	bh=Db4+9+IYgjCallxSpYrdtOCYaD0xmXsEQI89OVRNZBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRuWveAYku8qLFebGVwk0sf9cMJAUGh3DgnDMxCcG90Fe9D98gYHyFmZXDjX080Sc
	 Bw/p9hdb3JnpsICPWL/4v9GKU9I7lEOYOUwh8qmnozrbB062yAiNMYgNshHLSnZKjA
	 EP4j9Q+ddibgD8vCizqbLNjeljhg7egqi6z52Fmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.1 067/126] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:04:28 +0100
Message-ID: <20241106120307.898183133@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -628,7 +628,7 @@ void devm_usb_put_phy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
+	r = devres_release(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_usb_put_phy);


