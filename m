Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A3A26B08A;
	Thu, 13 Feb 2025 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458166; cv=none; b=guUtxKzumHMKYFTNPsUV0yDwAGEP2j/TsmaMTm6PXB2LYAFIDHJUqFYuN4ttEhoQgl6VNzGMQ0OzWYWjqnEHDwBmscyFPWK466t63ROWrUKVuFQKIFywxdhTR691aVD/LaPb94p7LgzBmzH4bGsJGPAPOidIroqgJ8SYXQ4wuVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458166; c=relaxed/simple;
	bh=zRm6JWhO1EpnFIBJNQ89nsuj+anRJCVa9oJBEKoEuNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDDSQYNKHeC0hOonqxQW7TdS3TFQIcB1MDmNyS0y+OzA0iD2zbBd6tUb406Y3lzqawU1e8t7Ezt7uSrfX/I8vI8sxuyEOMNnishigIgz/wUdvpp77BswUqHVn0nSc+Yo8d37rcpUukg2uunWKtNqTdFWMoBAnf2GFQX2AF23eRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOXwm+aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOXwm+aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C34C4CED1;
	Thu, 13 Feb 2025 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458166;
	bh=zRm6JWhO1EpnFIBJNQ89nsuj+anRJCVa9oJBEKoEuNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOXwm+aqEnrD2wmiaxv3bd5J6GGTGU9BviuDyCKxji8ToQpfiHKkoXRJdFfnORWWr
	 8InmFvgyUmxKAwYgSp3U+atDM9RVO/fh8IBRkphsE0u8Sf++V7ldirsIs8aUtKcQDF
	 6cVjSV6PHW9z/iS35j1iSWjwmxggnpKxdeGt67cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 321/422] media: mmp: Bring back registration of the device
Date: Thu, 13 Feb 2025 15:27:50 +0100
Message-ID: <20250213142448.935674137@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -232,12 +232,22 @@ static int mmpcam_probe(struct platform_
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
 
@@ -246,7 +256,7 @@ static int mmpcam_probe(struct platform_
 	fwnode_handle_put(ep);
 	if (IS_ERR(asd)) {
 		ret = PTR_ERR(asd);
-		goto out;
+		goto out_v4l2_device_unregister;
 	}
 
 	/*
@@ -254,7 +264,7 @@ static int mmpcam_probe(struct platform_
 	 */
 	ret = mccic_register(mcam);
 	if (ret)
-		goto out;
+		goto out_v4l2_device_unregister;
 
 	/*
 	 * Add OF clock provider.
@@ -283,6 +293,8 @@ static int mmpcam_probe(struct platform_
 	return 0;
 out:
 	mccic_shutdown(mcam);
+out_v4l2_device_unregister:
+	v4l2_device_unregister(&mcam->v4l2_dev);
 
 	return ret;
 }
@@ -293,6 +305,7 @@ static void mmpcam_remove(struct platfor
 	struct mcam_camera *mcam = &cam->mcam;
 
 	mccic_shutdown(mcam);
+	v4l2_device_unregister(&mcam->v4l2_dev);
 	pm_runtime_force_suspend(mcam->dev);
 }
 


