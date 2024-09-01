Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F59A183CA3;
	Sun,  1 Sep 2024 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209293; cv=none; b=TL/FzbkUCsmDqGRMDu+LPBZvK+lPnLS8yxX3bkD4gWMhDXICeW0dvjdSALhvAkg+4YBvyHDndKoGNkpFovjZf2f6bjK5e210XtsWziXxncZOKugyEOey4vOyXkqoz/FVywA/F5Pwpq96Y0Du53It8uWjy6vH41g4yTWyVBXA1WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209293; c=relaxed/simple;
	bh=0+AuAji31pXLg+QAvwwqKrr3afFlaMCEDSkDf/XvkFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZxWOgfc9RSy+uKFKOn5KEKT4XnoDdqvcV8RsC9vdRhTZTJPZjiQvo4vm6svbZOhs+w7YwSHVYqmC/RbZ5SwPGGM9nbqU7fb0RRqetn+ll0lxcHW7IKIwQ/7YHAXA0hB1+y0zv1PHzWq8b7PMp+AdgCBsx06vCWEvMTqc/GRKkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1o6OhAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1o6OhAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D102C4CEC3;
	Sun,  1 Sep 2024 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209292;
	bh=0+AuAji31pXLg+QAvwwqKrr3afFlaMCEDSkDf/XvkFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1o6OhAOhnUOEe+0PPYRZMcm1ZmduG/t1e8iBSJuspvp8/wjaJ+fav2xv7ja2vdid
	 kANCbLGext13M61XKrw9Nc2EduLFJXCznOH08Q/Y9yLPzHRPrD81MFOKK0Gw+jd9Z3
	 HWfKLVmYfU7tKeEV8QdfOOwT2F4CPPThEW5fj/eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 62/71] usb: dwc3: st: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:18:07 +0200
Message-ID: <20240901160804.226973358@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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


