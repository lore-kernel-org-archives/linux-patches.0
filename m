Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FD922DFA7;
	Tue, 26 Aug 2025 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216653; cv=none; b=O3dMvLxA1eG/Xw8WjpQgdaJ2x25CV3nt+OC77sFedQDD9CogD+9QsI+QQXZR0hV6XQxz8J3dZETeNrH/KRLK6A7YD1DvRFI7A1nuWWx5u0YKaDkmj4jGe+ZlZBt2SP8e8LTSuff79m7DLJXHkmM9F8ZTWvddkhIM/He/gAasV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216653; c=relaxed/simple;
	bh=0S44TwZTgEhYG18pIRrZXmrSRDyrsC7YTd+aT/ZVrMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0wgOX08zjK9rS6KpwELu9MIW01B6qIU/fFMOWy2yPUPbsCAuDD0G41+DJ/QYmD3GNDct9m90owo+956ITljm0GMMhRPr0ZhgVuwYC/xYw4I01pn7hwMkOZMzUwrGxMtwlgRPWjwhk9+mbmP57aSapT86/V4Nb6loXXsyrjLgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MLxi5wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MLxi5wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D4DC4CEF1;
	Tue, 26 Aug 2025 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216653;
	bh=0S44TwZTgEhYG18pIRrZXmrSRDyrsC7YTd+aT/ZVrMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MLxi5wTBbuxyilTEtjekLunQ1D7LhJzauH6l5N3Og+/yOMGDSujOszlJ/DF8UKHR
	 11hvBYUhFFOkWi/R9N0KjNITi78hDRdKyCaSQNzDJj+wqpIVDjEqSbrqIFVfmRAa/Y
	 JXuIempAMsFraYiiVNjjwH43XiHit20s3IkuzNNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 492/644] media: ov2659: Fix memory leaks in ov2659_probe()
Date: Tue, 26 Aug 2025 13:09:43 +0200
Message-ID: <20250826110958.684793545@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

commit 76142b137b968d47b35cdd8d1dc924677d319c8b upstream.

ov2659_probe() doesn't properly free control handler resources in failure
paths, causing memory leaks. Add v4l2_ctrl_handler_free() to prevent these
memory leaks and reorder the ctrl_handler assignment for better code flow.

Fixes: c4c0283ab3cd ("[media] media: i2c: add support for omnivision's ov2659 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov2659.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1479,14 +1479,15 @@ static int ov2659_probe(struct i2c_clien
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov2659_test_pattern_menu) - 1,
 				     0, 0, ov2659_test_pattern_menu);
-	ov2659->sd.ctrl_handler = &ov2659->ctrls;
 
 	if (ov2659->ctrls.error) {
 		dev_err(&client->dev, "%s: control initialization error %d\n",
 			__func__, ov2659->ctrls.error);
+		v4l2_ctrl_handler_free(&ov2659->ctrls);
 		return  ov2659->ctrls.error;
 	}
 
+	ov2659->sd.ctrl_handler = &ov2659->ctrls;
 	sd = &ov2659->sd;
 	client->flags |= I2C_CLIENT_SCCB;
 #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API


