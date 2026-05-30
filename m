Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E13A481DD;
	Sat, 30 May 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160611; cv=none; b=s4V1i87GkXyuUtVm4ta0xzBVzNrsJ+OGMXsbol8MejWyAwZBlNqrIdBWwpRlMmzYCnfWkdQdUN3fzr0lLqnRWBYDIiBnuWjyc3q2VItIXtrs4uXeOnI+2PZceiDLWls4DEF9+J7Nnj6mROqXjgJkDwN3bJ94mFNwFtNKB6CdsN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160611; c=relaxed/simple;
	bh=YgXKG/C4sme/MlY0TQ8kDWtIHiPOrhBwd7bTpyATCjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW+6RfF8OHXpKb2WfL4eUSd+AwwpC+mtK1VmtVUb3f0r6CIazjsqKARMP/NNDM7SVj0igVUMnzN/RoJZCLSvPydIy5pdmYHvgurOg+UvMXO9YbXU1FJfC+lpPtNIh+niMfc1ngZ49uRz+1ZmWJtEtwbNrNJREiH8/fJdQX/448Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3j3jify; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3j3jify"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5FB1F00893;
	Sat, 30 May 2026 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160610;
	bh=jw5yebGOOqG1nSIwehfQ4xlak62+MvQXF1paTs3jrzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3j3jifyMigBkY4iTwdKt90AQs2pKThmSrN+Oze0PYq+pHUV34y5ie047iaeQBivN
	 if3OjT7gsH4kR0/NstNE3nLl6cmGmpfF3G1ZlVQ6fYwMAWpfvrw6XOHm90Tc3ipKo3
	 m+BhNiGZVjVDtyvdW7sjMB5YZGAIMM27WLjLtor4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 385/969] media: i2c: ov8856: free control handler on error in ov8856_init_controls()
Date: Sat, 30 May 2026 17:58:29 +0200
Message-ID: <20260530160310.936602943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <akoskovich@pm.me>

commit f75e160745663ce9b13362ae6e90bd439c58df69 upstream.

The control handler wasn't freed if adding controls failed, add an error
exit label and convert the existing error return to use it.

Fixes: 879347f0c258 ("media: ov8856: Add support for OV8856 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov8856.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -1954,12 +1954,18 @@ static int ov8856_init_controls(struct o
 			  V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
-	if (ctrl_hdlr->error)
-		return ctrl_hdlr->error;
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		goto err_ctrl_handler_free;
+	}
 
 	ov8856->sd.ctrl_handler = ctrl_hdlr;
 
 	return 0;
+
+err_ctrl_handler_free:
+	v4l2_ctrl_handler_free(ctrl_hdlr);
+	return ret;
 }
 
 static void ov8856_update_pad_format(struct ov8856 *ov8856,


