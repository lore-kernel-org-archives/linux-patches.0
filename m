Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C841DFE06;
	Wed,  6 Nov 2024 12:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895799; cv=none; b=YaqdyUgT4lyAychVCz7VVu6ZnMh8/5mnyCUlGWjy4uzcZIjwJEIS9uYFeJvUpyD6tu+fc1XbYl0KRVfWgx8gaKJ68xT6KQp/EJX3EmB9TRXplYhwsclvXxrSoWL88qbE/0tkFCTyqv27iM5OAu+rjBAHALg7AmX2fHEvVRyrrdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895799; c=relaxed/simple;
	bh=Yq/NfmAk4yagtDZxArKRqJtdWqsCTmY3CrSUuqxGcgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1aW+cu1rBOezT8l8E+pjoqwgansyh6iN8baKbRuB44wpwtxJGOHuGpXH6AORWP2sJcUOPooexYIpRyr1Pg8+p4xspwftr3Yby+Cb74tTZaj2B29SCb9E51kBu6F2Ytpo3RCgTKJ2FHJ8nKxLB3xnycC5rfXnmeWGKkgLUCER0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUgTdUH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUgTdUH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EE8C4CED3;
	Wed,  6 Nov 2024 12:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895799;
	bh=Yq/NfmAk4yagtDZxArKRqJtdWqsCTmY3CrSUuqxGcgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUgTdUH8Nh5MzL8wRsuLaINTvQpNKmMvpnx/56ZjbKi0OeaegULLh/sHNbRsw2H3D
	 72A4ojrfBkDSSd9uGeHKwDBXSMVNiV0x9FuEpe8s1oJF+0G086x5mbswzSWrakM8Ov
	 UycReIkDQIKUWZwHq0LTDm/O4SdlSMG506VCGJVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 4.19 340/350] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:04:28 +0100
Message-ID: <20241106120329.097885213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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
@@ -579,7 +579,7 @@ void devm_usb_put_phy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
+	r = devres_release(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_usb_put_phy);


