Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062188;
	b=a4b3zy/OTwpVAcjSFcQUuxSz3LARyKadgGgoSMJuzmJJaSjSPDBnNs86Fe37bXxXAye3
	 0vBTJYgjqNwutKZbn4Nq0f5P8heJ8WBYVQXbRksuMcjuhVyNlxIdfHRQ3ZRVzwOGU0zmB
	 Mf/rlH2zLz6fJC2mRNdvMX83jRrAc9fZIla8BirNTwJkEVubtcM2mmzjB49A3AZzTStuo
	 9W7sFe5TBQUEIv5EDQoyhxgdDSD6+E8E5FmDzBj5pmuFhx/AppdYDKTC8oE39Em29rY35
	 u5gVTZuWv+rYysb9O31f+I6H5uM4cPStPd6bI+Z1Kf+qGJATHbQ0gAH/kK6No9+qZ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rs7MDZaUbgEdJNzoWdwx0/tV/ekWDGjU/dnWf2oC0cc=;
	b=cXlU84Zzy14A14y3qG8/aepT41o6vNfPMzzhDAvSD/kEKancRJS36Qfn9xOgCGMe+Z2c
	 FkkXrNxZ/hV+J5l2bw58zkAiwsNAqIQPW73lMbff0DwLwQT/0mXCa6/xk7+RxaWXOhZxZ
	 LyMrUADMqh8wE1WVAW9K9bhZVTweF2oUZN4wE/AAbvPNcPcp+A8+lKGn5LNqoNbkZ75rk
	 HSQQJAga8Of8ltGltxqHGErEPt7m5aK6Iu5klhYOOSfnKN4UI800q67Bp+mmRENuW2Wpn
	 F3ERX3BwrksyWV61yA4KFdx9/Q9A/xHNQYyqevEQYg4AxxR6Y/9l5wvvFH2a8Oj1OTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+uPrZEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BC0606A326;
	Sat,  7 Nov 2026 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+uPrZEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF88B1F008A2;
	Sat,  7 Nov 2026 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062188;
	bh=Rs7MDZaUbgEdJNzoWdwx0/tV/ekWDGjU/dnWf2oC0cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+uPrZEFBqz2d45v2qgd3y1QTXhMzsYrlMNTvAhurlmf8aur6GzS/xyJbLXelCbZa
	 AQorBz8CPxE68f+RsZQFqUDOCKjfI6ojYtxb8jUx/6COXe0vYyDEHVycqF+CBDX39g
	 D0JRdQjc5zG0sGJIlmialD0Oan4P0he4y8Hsk3pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1145/1536] media: platform: mtk-mdp3: Fix device reference leak in mdp_comp_init()
Date: Sat,  7 Nov 2026 08:52:41 -0500
Message-ID: <20261107135029.879984692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ff3308afa9c9da0ef9113cb80803588adabef902 ]

mdp_comp_init() takes a reference to the component platform device
with of_find_device_by_node(), but the error path taken when the
clock array cannot be allocated and the one taken for a component
without a GCE EOF event return without dropping it.  The caller
frees the mdp_comp in those cases, so the reference is leaked.

Release the reference on both error paths.

Fixes: c4320f9721fd ("media: platform: mtk-mdp3: dynamically allocate component clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/mdp3/mtk-mdp3-comp.c   | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
index 8f62fb167156d..9f7cf5ac20723 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
@@ -1788,6 +1788,7 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	struct device *dev = &mdp->pdev->dev;
 	struct platform_device *pdev_c;
 	int clk_ofst;
+	int ret;
 	int i;
 	s32 event;
 
@@ -1814,8 +1815,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	comp->clk_num = mdp->mdp_data->comp_data[id].info.clk_num;
 	comp->clks = devm_kzalloc(dev, sizeof(struct clk *) * comp->clk_num,
 				  GFP_KERNEL);
-	if (!comp->clks)
-		return -ENOMEM;
+	if (!comp->clks) {
+		ret = -ENOMEM;
+		goto err_put_device;
+	}
 
 	clk_ofst = mdp->mdp_data->comp_data[id].info.clk_ofst;
 
@@ -1840,7 +1843,8 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 		if (of_property_read_u32_index(node, "mediatek,gce-events",
 					       MDP_GCE_EVENT_EOF, &event)) {
 			dev_err(dev, "Component id %d has no EOF\n", id);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put_device;
 		}
 	} else {
 		event = MDP_GCE_NO_EVENT;
@@ -1849,6 +1853,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	comp->gce_event[MDP_GCE_EVENT_EOF] = event;
 
 	return 0;
+
+err_put_device:
+	put_device(&pdev_c->dev);
+	return ret;
 }
 
 static void mdp_comp_deinit(struct mdp_comp *comp)
-- 
2.53.0



