Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745BF1A6192;
	Tue, 30 Jul 2024 17:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359126; cv=none; b=UO7Cy+dizXg1Kl9kuBqGRy+wPM5IZ1Xha85fN+Hssgspzlp5K+OnQ4EZdl+OW/6Yf9nC8XQQndJvImdyH+3O2QKZRN9+RwfnC37AgakCj/Dmy5Sf0dSHKi9hPgv5NIHxPCcUzfo+QYyBnKeBWU9UWulkqm1RA1jydB+Cns9FmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359126; c=relaxed/simple;
	bh=eOMTNzoIMO0NpM7l8OIHzfas7SMKTc1YTaHYFXgKghk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oADa9vmTCbPIR8PoeR1bbAEfU3fTqTQcABISEcSQP+XGRbMAFFvLfsWQZOn41AhOPR10lfmiKlJqCfx1ibo98gerXEdBapdOcgJ34DfMWVqYi2dTC/jD7x+MrYdLIFgoMKzUA+2OEGq7rxhVOLNiJXPFSj897ria5aelT/+2eWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Gs8ADK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Gs8ADK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B23C32782;
	Tue, 30 Jul 2024 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359126;
	bh=eOMTNzoIMO0NpM7l8OIHzfas7SMKTc1YTaHYFXgKghk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0Gs8ADKB7YjxLGuhMe4rrtSu2o6xL2HilCX86at/ZqokCugVmrVbR/xRPEmQWCov
	 QUI0Fv/3Y5LobaTJNCrSmBPoIQtugt5lT8xYzHpQtZPs4R3qki5T8ii7kUC5br4J8N
	 c16eYs7AiZoROpp4ALisrpFas18sRK1JGjwErFhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Wentong Wu <wentong.wu@intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 414/568] media: ivsc: csi: dont count privacy on as error
Date: Tue, 30 Jul 2024 17:48:41 +0200
Message-ID: <20240730151656.053049728@linuxfoundation.org>
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

From: Wentong Wu <wentong.wu@intel.com>

commit a813f168336ec4ef725b836e598cd9dc14f76dd7 upstream.

Prior to the ongoing command privacy is on, it would return -1 to
indicate the current privacy status, and the ongoing command would
be well executed by firmware as well, so this is not error. This
patch changes its behavior to notify privacy on directly by V4L2
privacy control instead of reporting error.

Fixes: 29006e196a56 ("media: pci: intel: ivsc: Add CSI submodule")
Cc: stable@vger.kernel.org # for 6.6 and later
Reported-by: Hao Yao <hao.yao@intel.com>
Signed-off-by: Wentong Wu <wentong.wu@intel.com>
Tested-by: Jason Chen <jason.z.chen@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ivsc/mei_csi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/pci/intel/ivsc/mei_csi.c
+++ b/drivers/media/pci/intel/ivsc/mei_csi.c
@@ -191,7 +191,11 @@ static int mei_csi_send(struct mei_csi *
 
 	/* command response status */
 	ret = csi->cmd_response.status;
-	if (ret) {
+	if (ret == -1) {
+		/* notify privacy on instead of reporting error */
+		ret = 0;
+		v4l2_ctrl_s_ctrl(csi->privacy_ctrl, 1);
+	} else if (ret) {
 		ret = -EINVAL;
 		goto out;
 	}


