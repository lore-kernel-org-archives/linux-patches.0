Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F7726B0B8;
	Thu, 13 Feb 2025 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459756; cv=none; b=NTwHyy9wBe2CRQCe0lQIRDlT7ckG7gJ2mmgtcxzlxpUC0cmNmweCri81CuS8G6BAb2oWpFrpP6IjaXa41qaUtSNA6P3awbznFWMrDjHEKmyXQN6/p83K+o92GoqkIFqhmlM+3PWQHwDvxY3JmVqQtAwga6ZMx5QWvoND9/T8Lck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459756; c=relaxed/simple;
	bh=TfqoIyX08t/4QS4cmunbJoU7hgftKSiLaGMvqkf/7gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjAuAM/SlWbKwc0ZKGYB/t41ib2YDhEc1fJ6ZPBOacjzHOCMcIxxyeRvAd4ThaAKgXlfohyyZ10vmSq7RBhrNYp/o0gCD9lckEbMqYc7S1da5WkjFJSV4n1NC7w9uBuiOPJ9JsHOPtlt9Zi5ahKH3KGsaAJGjfVfJTZ7yR2tr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3UXEL4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3UXEL4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565D0C4CED1;
	Thu, 13 Feb 2025 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459756;
	bh=TfqoIyX08t/4QS4cmunbJoU7hgftKSiLaGMvqkf/7gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3UXEL4o1JF/vufcmg3Bps+7j1BUnSqMNZYVvzvp+F9hguU+zK3Z1U1zNu1/0Hxaq
	 +V0Erk7E5Q5OBv1Yutbmz/svwum0c3wLGLUIN2x5DV7g5oqmJkd+YoBvhIFQMXqgS/
	 OrEbTXs9WRl5Osdgs7+YQUJ4ujsQeBqLOa9Qq4Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 356/443] media: mmp: Bring back registration of the device
Date: Thu, 13 Feb 2025 15:28:41 +0100
Message-ID: <20250213142454.352436432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


