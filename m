Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E461A6160;
	Tue, 30 Jul 2024 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356818; cv=none; b=fh06UaNx6YNVFgFreEXcyHjCjzCiHnCtpFd8lST8Rq8v1Z7zcITxXzSS7oHpw18bMGPXLgThYCdDJLa1CFtSKWfcZpG7h2eHdS2Ke6/oTANu/QHwwnk/IKbBpmlvg7o2xV3RHJ4A9rQTKgpaK2W14PGyx/o8qUSCDK6NbHLUD9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356818; c=relaxed/simple;
	bh=EkQh0iQqQEf1woWpA/62qInoqrpPlcnqZJLFHoi6jQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJJlQDg8+VCqKRxCLhY5Jg7fvYWvaM9b5T7xUHJE94YYaP8OMy46YPVwSbVi8+bw75wPAVUgMVbzhiSajwwEnBAIPVNdIqA66edEGHaz+1y6v2wJwkU3nFDPyq+O1LqU+ue0QktE75hShJCxzoT4sKVjzbxB/WjtdaSbnVwf6Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtwwp+Eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtwwp+Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0183DC32782;
	Tue, 30 Jul 2024 16:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356818;
	bh=EkQh0iQqQEf1woWpA/62qInoqrpPlcnqZJLFHoi6jQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtwwp+EomKZtJZP7I+D6FF8ysI8htRr/WxZ9iDcOiRSMyU/vGnI5UK3BbjxbJ2Dj/
	 7yNtm0ajLO2HQlC1tyS06kAjbV+JyhdyVfdKPIgfqXRkI3n8OKldMhw2F0y+Rllytm
	 jM/NmiemAdyRwbdWG7YnY8Duaod8SN5XJfOYCT5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allen Chen <allen.chen@ite.corp-partner.google.com>,
	xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/568] drm/bridge: Fixed a DP link training bug
Date: Tue, 30 Jul 2024 17:44:54 +0200
Message-ID: <20240730151647.187633634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>

[ Upstream commit ca077ff8cac5af8a5a3c476983a6dd54aa3511b7 ]

To have better compatibility for DP sink, there is a retry mechanism
for the link training process to switch between different training process.
The original driver code doesn't reset the retry counter when training
state is pass. If the system triggers link training over 3 times,
there will be a chance to causes the driver to use the wrong training
method and return a training fail result.

To Fix this, we reset the retry counter when training state is pass
each time.

Signed-off-by: Allen Chen <allen.chen@ite.corp-partner.google.com>
Signed-off-by: xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231221093057.7073-1-xiazhengqiao@huaqin.corp-partner.google.com
Stable-dep-of: 484436ec5c2b ("drm/bridge: it6505: fix hibernate to resume no display issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 2f300f5ca051c..b589136ca6da9 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2240,11 +2240,13 @@ static void it6505_link_training_work(struct work_struct *work)
 	ret = it6505_link_start_auto_train(it6505);
 	DRM_DEV_DEBUG_DRIVER(dev, "auto train %s, auto_train_retry: %d",
 			     ret ? "pass" : "failed", it6505->auto_train_retry);
-	it6505->auto_train_retry--;
 
 	if (ret) {
+		it6505->auto_train_retry = AUTO_TRAIN_RETRY;
 		it6505_link_train_ok(it6505);
 		return;
+	} else {
+		it6505->auto_train_retry--;
 	}
 
 	it6505_dump(it6505);
-- 
2.43.0



