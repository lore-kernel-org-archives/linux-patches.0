Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F926B087;
	Thu, 13 Feb 2025 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460903; cv=none; b=DOmy/i45GaaOotZpdJxuIcEZ5JfjBaLBS4P4qTtHgNWMfK3LVHroWs6dXuRhZyrVfgM1MEOZCVtnZtDhXsx0YpvEwFjzs0vbjDcJ+0WpXsyvtEU4UIoGYLEAnk8OiKqwXpf5H8fi6SqEJGIjeQECuncAiza1ZTc3FKaR6s8st94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460903; c=relaxed/simple;
	bh=zeIz8ze3heyuG8NCeG4JsrMl/wloFdgDGwso3TfW8+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f13+SCycl/lIk18WHJkU9rBCjp9EnxZbeeSzMnr1Z25ait/UDqG43nIaLabcqZCMijL0SOx0sUQ9HUeXVL6L2xPn3nBvz6dn7W0Bx3dP3PKzp5AMC0BdklOt/JK2C/qoRnIpeyqE+kgrWy5DvHVqLc12wrw3LDd7Q/7K4EfBgTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOTe8MNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOTe8MNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDEDC4CED1;
	Thu, 13 Feb 2025 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460902;
	bh=zeIz8ze3heyuG8NCeG4JsrMl/wloFdgDGwso3TfW8+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOTe8MNqfG8pZiKwi1lJQdqU1SrjME1Sc+3QXgSXxXyTZSaRcf+biuhAXSFNNVbCC
	 flDbg17jvDYszlBqhNbQKUoBaObnQOdeE+u67+w1O5hQzZ5+2lUy+6s3+5f6ZUiadt
	 DYPth9at4yYOVMVAKmjweeLVJ9HqmEEnzrfkZGgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 203/273] media: mmp: Bring back registration of the device
Date: Thu, 13 Feb 2025 15:29:35 +0100
Message-ID: <20250213142415.343695755@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit fbb5298bf1a7b71723cd2bb193642429ceb0fb84 upstream.

In commit 4af65141e38e ("media: marvell: cafe: Register V4L2 device
earlier"), a call to v4l2_device_register() was moved away from
mccic_register() into its caller, marvell/cafe's cafe_pci_probe().
This is not the only caller though -- there's also marvell/mmp.

Add v4l2_device_register() into mmpcam_probe() to unbreak the MMP camera
driver, in a fashion analogous to what's been done to the Cafe driver.
Same for the teardown path.

Fixes: 4af65141e38e ("media: marvell: cafe: Register V4L2 device earlier")
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/mmp-driver.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/marvell/mmp-driver.c
+++ b/drivers/media/platform/marvell/mmp-driver.c
@@ -231,12 +231,22 @@ static int mmpcam_probe(struct platform_
 	mcam_init_clk(mcam);
 
 	/*
+	 * Register with V4L.
+	 */
+
+	ret = v4l2_device_register(mcam->dev, &mcam->v4l2_dev);
+	if (ret)
+		return ret;
+
+	/*
 	 * Create a match of the sensor against its OF node.
 	 */
 	ep = fwnode_graph_get_next_endpoint(of_fwnode_handle(pdev->dev.of_node),
 					    NULL);
-	if (!ep)
-		return -ENODEV;
+	if (!ep) {
+		ret = -ENODEV;
+		goto out_v4l2_device_unregister;
+	}
 
 	v4l2_async_nf_init(&mcam->notifier, &mcam->v4l2_dev);
 
@@ -245,7 +255,7 @@ static int mmpcam_probe(struct platform_
 	fwnode_handle_put(ep);
 	if (IS_ERR(asd)) {
 		ret = PTR_ERR(asd);
-		goto out;
+		goto out_v4l2_device_unregister;
 	}
 
 	/*
@@ -253,7 +263,7 @@ static int mmpcam_probe(struct platform_
 	 */
 	ret = mccic_register(mcam);
 	if (ret)
-		goto out;
+		goto out_v4l2_device_unregister;
 
 	/*
 	 * Add OF clock provider.
@@ -282,6 +292,8 @@ static int mmpcam_probe(struct platform_
 	return 0;
 out:
 	mccic_shutdown(mcam);
+out_v4l2_device_unregister:
+	v4l2_device_unregister(&mcam->v4l2_dev);
 
 	return ret;
 }
@@ -292,6 +304,7 @@ static void mmpcam_remove(struct platfor
 	struct mcam_camera *mcam = &cam->mcam;
 
 	mccic_shutdown(mcam);
+	v4l2_device_unregister(&mcam->v4l2_dev);
 	pm_runtime_force_suspend(mcam->dev);
 }
 


