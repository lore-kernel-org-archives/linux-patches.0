Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB14614A614;
	Mon, 14 Oct 2024 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916485; cv=none; b=UtBR2LhPeczkz08qlTFppQuGvEiOsNXAmfxo3SslvbQbgK5vFXFBWPdtKUUwAmbWkRzCpFVOhDe5O3yC0kvUo4Bo0uhdtzKaEtWwx0suo49gUXwGaoJbulJXGGr9Fz7RXV4wUUpDR2JNzoem2uG7wcn0PQM4nqyk+LwOlP5vMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916485; c=relaxed/simple;
	bh=8PUjvuA9S28L7VtrOwP7L/m1z52YNNXRu0yoP8+ERLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9QM9+Xga/fxgHvOAeP+EEPYsFeh5A9m6ao5rI+PYNm5Q2N7oM7wz/ZGyEaMZjPOydFxVL43UceXkhgLcjDDRNp08i6/tmYoLog8P8FFIUUujx8iJxLxZB3Dpp66KqcbIS42Lf7ItzOjtjkdbQLd6hVduzwGyZUlnTCHOMeyIjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTDiGNiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTDiGNiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C144C4CEC3;
	Mon, 14 Oct 2024 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916485;
	bh=8PUjvuA9S28L7VtrOwP7L/m1z52YNNXRu0yoP8+ERLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTDiGNiMluY+Py9funtucXqosam9Vukp8dfkSMJQ7wVgeOwdpQPPq7cfPT8OGES1t
	 fpjm9uGPuWRu9u9/WwsLUA0i3T+FC/vaQKMK0gWx3EbOVU9MGrj4lJFNzV3cyhpmsx
	 UEchvRXNZcg9D5cpd/611JwF+au6E0G2Z8aaZkSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Luo <royluo@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.11 166/214] usb: dwc3: re-enable runtime PM after failed resume
Date: Mon, 14 Oct 2024 16:20:29 +0200
Message-ID: <20241014141051.460315225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Roy Luo <royluo@google.com>

commit 897e13a8f9a23576eeacb95075fdded97b197cc3 upstream.

When dwc3_resume_common() returns an error, runtime pm is left in
suspended and disabled state in dwc3_resume(). Since the device
is suspended, its parent devices (like the power domain or glue
driver) could also be suspended and may have released resources
that dwc requires. Consequently, calling dwc3_suspend_common() in
this situation could result in attempts to access unclocked or
unpowered registers.
To prevent these problems, runtime PM should always be re-enabled,
even after failed resume attempts. This ensures that
dwc3_suspend_common() is skipped in such cases.

Fixes: 68c26fe58182 ("usb: dwc3: set pm runtime active before resume common")
Cc: stable@vger.kernel.org
Signed-off-by: Roy Luo <royluo@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240913232145.3507723-1-royluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2562,7 +2562,7 @@ static int dwc3_suspend(struct device *d
 static int dwc3_resume(struct device *dev)
 {
 	struct dwc3	*dwc = dev_get_drvdata(dev);
-	int		ret;
+	int		ret = 0;
 
 	pinctrl_pm_select_default_state(dev);
 
@@ -2570,14 +2570,12 @@ static int dwc3_resume(struct device *de
 	pm_runtime_set_active(dev);
 
 	ret = dwc3_resume_common(dwc, PMSG_RESUME);
-	if (ret) {
+	if (ret)
 		pm_runtime_set_suspended(dev);
-		return ret;
-	}
 
 	pm_runtime_enable(dev);
 
-	return 0;
+	return ret;
 }
 
 static void dwc3_complete(struct device *dev)


