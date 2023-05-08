Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394C125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3D2C433EF;
	Mon,  8 May 2023 11:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544099;
	bh=/PxnHSArEIzcdqlsIpz5kh7HkrZk3vIOP5r85rtzA68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otK1NlMnX5jnoNaAbFhJqZrkv9nfOuih64++rAqEuUv2AlKMO/sbMfgPHtIk17XGy
	 ck26mEW1DvvvPzdei38s1K8Whhc0rx4XOKmAZAdUsEsqRMTLnVOHWEXFhts0BqJ3EM
	 Q9+Vul2zZFV3TZpTis2FBvd+hnxlu4fPbQAZZmiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 301/694] media: hi846: Fix memleak in hi846_init_controls()
Date: Mon,  8 May 2023 11:42:16 +0200
Message-Id: <20230508094442.039511410@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 2649c1a20e8e399ee955d0e22192f9992662c3d2 ]

hi846_init_controls doesn't clean the allocated ctrl_hdlr
in case there is a failure, which causes memleak. Add
v4l2_ctrl_handler_free to free the resource properly.

Fixes: e8c0882685f9 ("media: i2c: add driver for the SK Hynix Hi-846 8M pixel camera")
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Reviewed-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/hi846.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/hi846.c b/drivers/media/i2c/hi846.c
index 7c61873b71981..306dc35e925fd 100644
--- a/drivers/media/i2c/hi846.c
+++ b/drivers/media/i2c/hi846.c
@@ -1472,21 +1472,26 @@ static int hi846_init_controls(struct hi846 *hi846)
 	if (ctrl_hdlr->error) {
 		dev_err(&client->dev, "v4l ctrl handler error: %d\n",
 			ctrl_hdlr->error);
-		return ctrl_hdlr->error;
+		ret = ctrl_hdlr->error;
+		goto error;
 	}
 
 	ret = v4l2_fwnode_device_parse(&client->dev, &props);
 	if (ret)
-		return ret;
+		goto error;
 
 	ret = v4l2_ctrl_new_fwnode_properties(ctrl_hdlr, &hi846_ctrl_ops,
 					      &props);
 	if (ret)
-		return ret;
+		goto error;
 
 	hi846->sd.ctrl_handler = ctrl_hdlr;
 
 	return 0;
+
+error:
+	v4l2_ctrl_handler_free(ctrl_hdlr);
+	return ret;
 }
 
 static int hi846_set_video_mode(struct hi846 *hi846, int fps)
-- 
2.39.2



