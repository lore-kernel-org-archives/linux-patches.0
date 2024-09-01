Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6581DFD1;
	Sun,  1 Sep 2024 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209798; cv=none; b=goA7Fqc5Fx706d3CeVS8KnVR9ED5ojojveQ9MxmzyGbVBijogt4ftNgbuvszxCelsD1EXL+fT5kFStmxzqMhs3StXOGvmMBiCaqGlPAXoLEfYDp+dWbQHI8zCmpuSeLwQsgkKm4jm/lk/Ul9Ey91TDfBfzcp3nesw4FHF2i9a14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209798; c=relaxed/simple;
	bh=0KNd7XqUG2pW9CVxfPXRxAtzB0M5W61+F9ddmNC0FUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XagNZbynLjJ5srcedYj0HZWe+EweiGMlH9oDT78A86eoDMi8bmjiZ1gAiHL7gW9SxXPBtwl/F2um+WJ8LfLdMbKQjIsB+FFnLYBzs7toQhLSbjv/bHihSqw1g5WP1T8H23zgbGf3sbw2qJiUvWCL7af9npK5aTjkSZi7MIJSplc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5UXs0Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5UXs0Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B05C4CEC3;
	Sun,  1 Sep 2024 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209798;
	bh=0KNd7XqUG2pW9CVxfPXRxAtzB0M5W61+F9ddmNC0FUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5UXs0IyXwXw5FuwQnaRax+nhfmxf9K1B9cbV9RXJNLa/tRh5AENuKkohJKY336V4
	 +OwL1Rak7HxB751CW+bqA/9nIAAb7ot7JmKYB+F/eNpfUK7e0xkQYJCT8A7JIIf/rs
	 0Zj+Az5u4zJ7JGxHW8uEMaoNJcfnEoIgCFhztRsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 148/151] usb: dwc3: st: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:18:28 +0200
Message-ID: <20240901160819.681358285@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit cd4897bfd14f6a5388b21ba45a066541a0425199 upstream.

Depopulate device in probe error paths to fix leak of children
resources.

Fixes: f83fca0707c6 ("usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240814093957.37940-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-st.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -266,7 +266,7 @@ static int st_dwc3_probe(struct platform
 	if (!child_pdev) {
 		dev_err(dev, "failed to find dwc3 core device\n");
 		ret = -ENODEV;
-		goto err_node_put;
+		goto depopulate;
 	}
 
 	dwc3_data->dr_mode = usb_get_dr_mode(&child_pdev->dev);
@@ -282,6 +282,7 @@ static int st_dwc3_probe(struct platform
 	ret = st_dwc3_drd_init(dwc3_data);
 	if (ret) {
 		dev_err(dev, "drd initialisation failed\n");
+		of_platform_depopulate(dev);
 		goto undo_softreset;
 	}
 
@@ -291,6 +292,8 @@ static int st_dwc3_probe(struct platform
 	platform_set_drvdata(pdev, dwc3_data);
 	return 0;
 
+depopulate:
+	of_platform_depopulate(dev);
 err_node_put:
 	of_node_put(child);
 undo_softreset:


