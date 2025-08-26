Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8137260586;
	Tue, 26 Aug 2025 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218069; cv=none; b=EDBh+aOoHws0nZCXaigzpFcmTZxDjACpNOOlZEpg6tMCsBLi9cUNaE47AlEkH7g9VrP2XwP5MT9KlngrCuSIVzUjL9pBF+KB3ELTf51WJKzLBLZ/kihGVdxDa3cF30ZDGGWHybpsGaHrhyMNP4GYnI6VStZFCmCwzrjbGVBjx40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218069; c=relaxed/simple;
	bh=2NvpdKMuQvbFs/PgCT+YVJZpdyitfEOefKQy8oVOP0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a37zDp4cNTLcbl4HerL/4UFgQam/lf1zFszOUyA7JNUAncg9K2i3dRPefGf+V2UilJRaxMJJxpr6TK+kbPU283vASpsVgPtI2AoWAjzBO8Na00JQ6825t3C6bHMiUSX1YmOteO3h0gnlpjXecz6sYEzO3yR+bWaUnXC2cDcScJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diaXbywE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diaXbywE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1C0C4CEF1;
	Tue, 26 Aug 2025 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218069;
	bh=2NvpdKMuQvbFs/PgCT+YVJZpdyitfEOefKQy8oVOP0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diaXbywEMEeisVTmulo56lsB/GNp18ywEyJ4cGO7vT6+buRBh26ZMyMUSeAv/MDOS
	 vEzRWZZWlg5gYl8+YB/P52rrL4JadhDwXbrbm6X9IO6Ikh1J8MYjWbGE8QOHANxlrA
	 je1w0A0ow1vJXGv7XbyZwueU9H2undZuLG5cPdIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 382/523] media: ov2659: Fix memory leaks in ov2659_probe()
Date: Tue, 26 Aug 2025 13:09:52 +0200
Message-ID: <20250826110933.884958684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1482,14 +1482,15 @@ static int ov2659_probe(struct i2c_clien
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


