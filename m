Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063118;
	b=B4/KCVrg4x0nyrGvxx9+jL4oMGp5jQcglqvq8AAM/wWRJA5/KeYCjDH5vNzVcRYt1XNX
	 R4dNUZnce6/5qIURnrKuSt3abmZR3hbrsh1mQKIXbD8cusQ+JNzU105T8koOjakrq3F59
	 5jpJXJpArbih/gTL1jdcmsxrgc9HKaPkF4Rf7EhmmGU6q6VqQKqHj5ZU+tZZztg73NjCs
	 jVMaUbE1gR/ViL/7YwkrMWs2xAe2D+rxlXgC5cub7IW2EtJiVr0c/41PyNj/bDz2yi/r7
	 dLxMH9rgcioCgnnSSsABqQw5khGYgPQz2syPiTmdw++IKhI6BC447vm66vT5iSMZI0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8pBFb9etE8E3ZR43ErPARbTDz5oOeR/uPt8mNE/CqoY=;
	b=KaQdUy0dnnvRthoP37Dd2vmNxEtSwYh379Da8r3A7bhFXAW6hJ390YaPd80L1BJkSud9
	 N28xX9qEUXJvZRhH9Xx8j0WEnXbBGHICOIMppS1CaUzJ7AV2LqVgx1eAM/mPXpuAcxbIZ
	 2ODQeyvpnExnBvZ27Lj0of1DyvacSXPBmA1W3TwRKAXnKN7UHqlUkZa1DfuSpRl0UWpKw
	 xPukm858Tb9ywpUbOUV6j2PULEb8MmlQJ2bRonfuIViZM/wSPS9YVRPbreOl5v/3IV5Ld
	 SI0Zomrz7xZzVlv/Y1/r8fOqUDDRLDcLusJoFxXRWGrdMu74M55G/GpGRrBfNk2lUEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GDaALI/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1B5606A33B;
	Sat,  7 Nov 2026 14:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDaALI/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0DB1F008A1;
	Sat,  7 Nov 2026 14:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063117;
	bh=8pBFb9etE8E3ZR43ErPARbTDz5oOeR/uPt8mNE/CqoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDaALI/PdR9g2NSeGjnHXz3XcTW2+2+GZ6kAwRc8r24HDqHJC6M/GVWv7RC7asMM6
	 XL3Ctos/YQ4CzM8mP0BYhmmJmWdqhI5AO0E7gWpB5+BZsbk1DvryBFuUFFJkDdqglI
	 Ws2vavdvzcqosqKpKXkk6OsriVubjmeOY4etDcJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/869] media: platform: mtk-mdp3: Fix device reference leak in mdp_comp_init()
Date: Sat,  7 Nov 2026 08:50:30 -0500
Message-ID: <20261107134904.191206693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7fcb2fbdd64ee..acb2758a7b42d 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
@@ -1730,6 +1730,7 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 	struct device *dev = &mdp->pdev->dev;
 	struct platform_device *pdev_c;
 	int clk_ofst;
+	int ret;
 	int i;
 	s32 event;
 
@@ -1756,8 +1757,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
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
 
@@ -1782,7 +1785,8 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
 		if (of_property_read_u32_index(node, "mediatek,gce-events",
 					       MDP_GCE_EVENT_EOF, &event)) {
 			dev_err(dev, "Component id %d has no EOF\n", id);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put_device;
 		}
 	} else {
 		event = MDP_GCE_NO_EVENT;
@@ -1791,6 +1795,10 @@ static int mdp_comp_init(struct mdp_dev *mdp, struct device_node *node,
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



