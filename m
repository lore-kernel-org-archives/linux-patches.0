Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A4921D3C0;
	Tue, 26 Aug 2025 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208508; cv=none; b=ZvTtG/1H20BTU0CWM2QVnXg9QbX6nYU9xjLbCpinCTxKR8+g4Ei0G9Lxg41UMccECdhL2TzFzhSYN8sk08C5fg1RztHpbVs6lkd/vd3hsMVocomhZLhsIkSxCuhc9gRVZbaQMIjhhQ2GVH7+Nv93Y7EUNMp+LWL6G6O31QANhqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208508; c=relaxed/simple;
	bh=8zgqqfBSvN6Cxeb2+7vtGrz7o/AOleB7wjekqIWoeWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBBXDPZk9mTLENAtzyDWqeFsSRnxKoEfp4e+WRqtGD5Iyd8YyLAUv8KkuFqgHP56825Im/WJt9vEaw/7YIlTqkBTAzL9e9t/26E0AErGnnY0BLmO7/PSamHToOFaZXG5c0jub9EkO8Xdmo75sy/vqHEIAjz8wAkGFyrnkpBmGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPMDOuYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPMDOuYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04619C4CEF1;
	Tue, 26 Aug 2025 11:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208508;
	bh=8zgqqfBSvN6Cxeb2+7vtGrz7o/AOleB7wjekqIWoeWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPMDOuYSO5HfBJXAIqOMftaBgDE3TXMWInniFlXzswIWaawMe/IdWaObARqQUuhk9
	 JaqYCfsGiMa0jifpVUvEKrZm55phLdpp7tBEmiQEFQ7QJAZMYYCnnbinUVDX5mSmjR
	 Rsgn6TJNyuiBGjZ0Fc6NvleoHkuVyQtJGjsfYrcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 108/322] media: ov2659: Fix memory leaks in ov2659_probe()
Date: Tue, 26 Aug 2025 13:08:43 +0200
Message-ID: <20250826110918.442691841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -1469,14 +1469,15 @@ static int ov2659_probe(struct i2c_clien
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
 


