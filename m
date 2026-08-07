Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BD127466A;
	Fri,  7 Aug 2026 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116520; cv=none; b=gzTVYYba80w8akuPWhm3dOnC+UKPE14Hmour8Ga8dDWiL+u1lkVHS5Q7OlM7FhJEyi6f+bqZxO39t7HR9R/YpZ9UeL7t67zxCUVljc9d1w7GlGwEXFMfo8No0GJUh2y50ZikwWXn8ExeJiahyp55Pml2ZN9wjvrr7zAtb7wx0Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116520; c=relaxed/simple;
	bh=/i9UjsH1hhOMebXozkwoIS38S+/JjwYaEkgvvttIwlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJBsOwmI3II3wCHvWSRdoBbhpOioNlISS8t3beyrMND/ofnrksoFJXLv23a8r+2QXARPHeFjA2CV5g+gjcE8frPed8vd3g8Di86VGnR8DReAShrERLCUt6YyuaJmbUIYMky3SJWyZ88BPZtZA7jReV3HaUdTRid4601QgjfiqcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCeAiIO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCeAiIO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAD61F000E9;
	Fri,  7 Aug 2026 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116519;
	bh=ZGEp9vVUyxe3EEaEaxGANMxAjPeOAuzrRQ9N9BVYrQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCeAiIO/UYRTpWamoWomS1p+A9+yPl2Mu4cFNR2tPGu2ZH5OeN7crbaV41TA9tFbT
	 zojb2YdoyFgG5yL33lLjM2IWnrwOjGnED40tR91nN3pRD/YIZxaa/RHQ7XCPIm6eQE
	 d+Uamu02jv3tz0VX55ZOJcusO8fOW+/d//GwLPdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/261] usb: musb: omap2430: Do not put borrowed of_node in probe
Date: Fri,  7 Aug 2026 16:39:32 +0200
Message-ID: <20260807143420.004793808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit c947360ae63eee1c9eacc030dd6f5a53f717addf ]

omap2430_probe() stores pdev->dev.of_node in a local np variable. This is
a borrowed pointer and the probe function does not take a reference to
it.

The success and error paths nevertheless call of_node_put(np). This drops
a reference that is owned by the platform device, and can leave
pdev->dev.of_node with an unbalanced reference count.

Do not put the borrowed platform device node from omap2430_probe().
References taken for the child MUSB device are handled by the device core,
and the ctrl-module phandle reference is still released separately.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260713114711.955253-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -455,7 +455,6 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err_disable_rpm;
 	}
-	of_node_put(np);
 
 	return 0;
 
@@ -465,7 +464,6 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err_put_musb:
-	of_node_put(np);
 	platform_device_put(musb);
 
 	return ret;


