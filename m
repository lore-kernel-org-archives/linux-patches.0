Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB2528314A;
	Tue, 26 Aug 2025 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218005; cv=none; b=tyFTZyzc+aG3PGe7K+xVes8ETwW6c0yaB4rIi1aR14yBdA34J+pJ8+oNkbIHEViwbh6G+uep+Jhut3zvWu6gp7VWqmcYU1k20bptq9+ceC4QnTIhuZ3P+PETGHbhPhXDeJmXl0tLExoJBVYIzDE8kiT85RHNzb0olKHVHS6mfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218005; c=relaxed/simple;
	bh=SSNdB0hJlgHoucLN2/EGWH5nW8rG3fVmMN7+QYOYi04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rocr8SJjmQn6SYV96AHS2oC1x/y8YWZXwLgqP116ebo4ARMywzgKGPfCD5nUJi/9PKdemKvKCr7tKOCTelCyuLZosZrA637uQ7BlXNTldN1hJHqihO8SO/MetNvVbKIXBeFCvYZsH2fHtr+KGXqCy1eyJyzKdDsscOmOiykV3DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLeSss5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLeSss5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84152C4CEF1;
	Tue, 26 Aug 2025 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218004;
	bh=SSNdB0hJlgHoucLN2/EGWH5nW8rG3fVmMN7+QYOYi04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLeSss5hymwKXH73zfe+a7FunS7zGB1B7/8Ac71TK7Zvro/a/5GiG6lyVJW6Q2LTj
	 dos47ifSFNzMbJFSNQ4daJ9gZ8sLMphoKKC0Erwb1vn1qj8U/69Qg2ZdRBmMLlMIMu
	 p7jtKGWJzy1/lwMTFI4/9DKPGxEWraXZx7vD/cho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.10 357/523] usb: dwc3: meson-g12a: fix device leaks at unbind
Date: Tue, 26 Aug 2025 13:09:27 +0200
Message-ID: <20250826110933.273791762@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Hovold <johan@kernel.org>

commit 93b400f4951404d040197943a25d6fef9f8ccabb upstream.

Make sure to drop the references taken to the child devices by
of_find_device_by_node() during probe on driver unbind.

Fixes: c99993376f72 ("usb: dwc3: Add Amlogic G12A DWC3 glue")
Cc: stable@vger.kernel.org	# 5.2
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250724091910.21092-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -844,6 +844,9 @@ static int dwc3_meson_g12a_remove(struct
 	if (priv->drvdata->otg_switch_supported)
 		usb_role_switch_unregister(priv->role_switch);
 
+	put_device(priv->switch_desc.udc);
+	put_device(priv->switch_desc.usb2_port);
+
 	of_platform_depopulate(dev);
 
 	for (i = 0 ; i < PHY_COUNT ; ++i) {


