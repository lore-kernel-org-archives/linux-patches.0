Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D4E1E22E2;
	Wed,  6 Nov 2024 13:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899059; cv=none; b=u5TiI9wgrS+/D17/vmFjijo0C6Pxb0PIV+15fnulbvm2buwMbt010CqgI3Nkskmlt4tZ7JFOB6Qp0dJWel4oRIEeq6CsJoNjUR9UsPVHhxJhotXWJlPKIx6z0ehAB/UbAUpkwn3/e3kViBQaEBmsSzMIll9YnW258Wz2wkTgjcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899059; c=relaxed/simple;
	bh=czmGriN8FyrHP/LmFQhDYzo3cCga35juw9IvQ1moolw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seow21Pex/5yI78g9nyCCLehbnJF8/5FXmP+U8CPuQkoDxtYLD6a12dEUSTi9L7Ymh+pJi8d8mQRnDkQ3WEGBULwApkG6b/UE61cQVNKINCQB38w7a14Kd7As7fx9EiaBrMwG66vYpJ3qEV28f3R1gFxa52iC/ARyZj0MHO+2iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAlUlRvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAlUlRvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82970C4CED9;
	Wed,  6 Nov 2024 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899058;
	bh=czmGriN8FyrHP/LmFQhDYzo3cCga35juw9IvQ1moolw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAlUlRvvipN0cVAZe6VGIUNytQ2ectxP6e0vi0HOAw4itvz7zdjeuoJeGczwpihAn
	 A1xVD2k/hmcF+48v5+Lee5zycdTXEpjTOZWZ8qcEn7ZfXWaLTUzc7BXsLZ3zKFi8gX
	 4qO3yytmbUJOKqnMF8MoVoQviJhUaWKCe2HDCvSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.4 447/462] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:05:40 +0100
Message-ID: <20241106120342.544298390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


