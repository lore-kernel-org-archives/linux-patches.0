Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485234A35;
	Tue,  6 Jan 2026 17:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720996; cv=none; b=pkEjzmXF/e7BCu5dhBkufipDEtLdHJgAs2nq1d8LH+z22/tQbRJS7lhgI/UieSDuihfwuuK5J5Ics3iz+UDuGlqpJ15R04lVHrhfqSU5UVGm2vLTZWs88bFSYC3jM+NN4SEGLIA1t8gVl4yyyb6lMZrJRc6tbw6cCE79UVgN79o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720996; c=relaxed/simple;
	bh=4ZoVoprKO36lPFe93BBx2ZI7nUoVqwrQa5od930/VBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOCl5P6COFS3LGQ/o9VGYtPQtevve3dh7hbo+AAF4apHbqkD1/KMGmpWZ0VgrEet80tFvsEamda7sVThiI+6H/6yG2CCzWTvUwWDjdaGktOoIRJQSeQo9wdj8IeSV1DwUjmcuciqvhn/h5r4X+mwAzheZ4K2h/tsJG1vQVRxVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uyR/i+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uyR/i+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB78C116C6;
	Tue,  6 Jan 2026 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720996;
	bh=4ZoVoprKO36lPFe93BBx2ZI7nUoVqwrQa5od930/VBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uyR/i+tQnBJyhnzCReVXPZVn6HslmzZS2Q46rbu2fyi0Ts62XXa63Qe8W1VXsXPE
	 AhRYo76R7HtXnJtrWZ3OTIyFmJZqONtpVh6tz69yk+vmV+gCJOqWk8So36FIJJA5M5
	 8o+ZEzjmu3h36Bzq6LZh5ZDNhCAIXddXlKUDywVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 404/567] media: platform: mtk-mdp3: fix device leaks at probe
Date: Tue,  6 Jan 2026 18:03:06 +0100
Message-ID: <20260106170506.287266243@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

commit 8f6f3aa21517ef34d50808af0c572e69580dca20 upstream.

Make sure to drop the references taken when looking up the subsys
devices during probe on probe failure (e.g. probe deferral) and on
driver unbind.

Similarly, drop the SCP device reference after retrieving its platform
data during probe to avoid leaking it.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Cc: stable@vger.kernel.org	# 6.1
Cc: Moudy Ho <moudy.ho@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -176,10 +176,18 @@ void mdp_video_device_release(struct vid
 	kfree(mdp);
 }
 
+static void mdp_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int mdp_mm_subsys_deploy(struct mdp_dev *mdp, enum mdp_infra_id id)
 {
 	struct platform_device *mm_pdev = NULL;
 	struct device **dev;
+	int ret;
 	int i;
 
 	if (!mdp)
@@ -213,6 +221,11 @@ static int mdp_mm_subsys_deploy(struct m
 		if (WARN_ON(!mm_pdev))
 			return -ENODEV;
 
+		ret = devm_add_action_or_reset(&mdp->pdev->dev, mdp_put_device,
+					       &mm_pdev->dev);
+		if (ret)
+			return ret;
+
 		*dev = &mm_pdev->dev;
 	}
 
@@ -298,6 +311,7 @@ static int mdp_probe(struct platform_dev
 			goto err_destroy_clock_wq;
 		}
 		mdp->scp = platform_get_drvdata(mm_pdev);
+		put_device(&mm_pdev->dev);
 	}
 
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);


