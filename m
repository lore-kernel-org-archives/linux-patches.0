Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAED524C2;
	Thu, 30 Nov 2023 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkfvQPU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA7EC433C8;
	Thu, 30 Nov 2023 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361774;
	bh=ufOu60yQgbsht7YFzxl8N+Dm3alMvUL0RmXYuEwNsyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkfvQPU2WDA5fhE2NR4h46AJcKqFf5wI37rAZTvz3Nn1qlTKgTiv0+Lgdpx7FQ/vM
	 BhkhTRc3VN1nOWauTkIYeFultMEEkg6WLoj4Zd8vR0xhhTaCMLl5LZp8xnJXLZhpw8
	 eqJfTgHNM3JwKo3R/+KtzWVoAFk2TBGdqRS9FjGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Aishwarya Kothari <aishwarya.kothari@toradex.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 6.1 41/82] media: qcom: Initialise V4L2 async notifier later
Date: Thu, 30 Nov 2023 16:22:12 +0000
Message-ID: <20231130162137.257185562@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 5651bab6890a0c5d126e2559b4aa353bed201e47 ]

Initialise V4L2 async notifier and parse DT for async sub-devices later,
just before registering the notifier. This way the device can be made
available to the V4L2 async framework from the notifier init time onwards.
A subsequent patch will add struct v4l2_device as an argument to
v4l2_async_nf_init().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # imx6qp
Tested-by: Niklas Söderlund <niklas.soderlund@ragnatech.se> # rcar + adv746x
Tested-by: Aishwarya Kothari <aishwarya.kothari@toradex.com> # Apalis i.MX6Q with TC358743
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> # Renesas RZ/G2L SMARC
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: f69791c39745 ("media: qcom: camss: Fix genpd cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 04e65edbfb870..f794215948e71 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1613,14 +1613,6 @@ static int camss_probe(struct platform_device *pdev)
 	if (!camss->vfe)
 		return -ENOMEM;
 
-	v4l2_async_nf_init(&camss->notifier);
-
-	num_subdevs = camss_of_parse_ports(camss);
-	if (num_subdevs < 0) {
-		ret = num_subdevs;
-		goto err_cleanup;
-	}
-
 	ret = camss_icc_get(camss);
 	if (ret < 0)
 		goto err_cleanup;
@@ -1652,9 +1644,17 @@ static int camss_probe(struct platform_device *pdev)
 		goto err_cleanup;
 	}
 
+	v4l2_async_nf_init(&camss->notifier);
+
+	num_subdevs = camss_of_parse_ports(camss);
+	if (num_subdevs < 0) {
+		ret = num_subdevs;
+		goto err_cleanup;
+	}
+
 	ret = camss_register_entities(camss);
 	if (ret < 0)
-		goto err_register_entities;
+		goto err_cleanup;
 
 	if (num_subdevs) {
 		camss->notifier.ops = &camss_subdev_notifier_ops;
@@ -1689,9 +1689,8 @@ static int camss_probe(struct platform_device *pdev)
 
 err_register_subdevs:
 	camss_unregister_entities(camss);
-err_register_entities:
-	v4l2_device_unregister(&camss->v4l2_dev);
 err_cleanup:
+	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
 
 	return ret;
-- 
2.42.0



