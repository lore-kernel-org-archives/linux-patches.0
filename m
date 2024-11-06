Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F571FAF00;
	Wed,  6 Nov 2024 12:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897521; cv=none; b=TaKd0/ncE4HFt37CsDuDdHEF23rVeStai81iarQCJS7OzwDYZ2uyo2ke2hC+gui411PsLogwllbRXsXg886IuRhPk74DtsqRSrcLT/SlP4q1t8i1tr9ZLNDQ4nwEk4RkDHAnizr0FuWKl/4kF7WNu4rFfCb060JX3jgmwN+jD5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897521; c=relaxed/simple;
	bh=Ik7oPadOK+O/X+CoeTVG0L8wvw1PXWl+Jxet5vbBr0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbLM2MJ7twua0htbm9C2x1BX4L98uRub/bKly49S43209eLCHwev1xw3yrPS3P20u31UaSrwQufAZmyqqFdvfClSZWg4cdn0Q+04Jb4O0tOEjvzIWl3UG4byTi9RnqfJ+M3Qru0yYTvMox1Jk5GHGzHvCqe1aItrPx+j7/pMKzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOkZzGvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOkZzGvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ECEC4CECD;
	Wed,  6 Nov 2024 12:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897521;
	bh=Ik7oPadOK+O/X+CoeTVG0L8wvw1PXWl+Jxet5vbBr0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOkZzGvciA4kYsQB6/CcBx5wHXKHUhGPmlU5LWoyZ3XoF07tQsefIowh+HpzWOBdl
	 JJ8EobGWtr/AfQpTHNpZAh44I+SJ9XqF1warXcLA/1nMUjIPBhcIkfCxbSmSDNzG93
	 Z6EIO8AvSEhNOj3dL69N5tuObhA9d4STYOQQlOp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.6 082/151] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:04:30 +0100
Message-ID: <20241106120311.116470486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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


