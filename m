Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A2B1A76AB;
	Tue, 30 Jul 2024 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360165; cv=none; b=K4johG0wCJCat0jNwsk4lNcHGrzzWJJ3dzTzPD6rPqqFVJriNOHaNpCHw3XYqv4IC/1HKqGtI/5/vgYfjp8jDdN+TgPaeEte9V9qa6Mrj3NWqF1UmAyWeS0U+7eA2cPZRaUXP8es3JgdW8+z6pbVHpoHbsh0uHNTVlDPsEoMTCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360165; c=relaxed/simple;
	bh=Ki0/cVyFG7iOgYEIqqVhxYMv+YRpoOAlXw/dU/LAa4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzPzQxX1pM7uRZ544c1ma7JpU0z8EXzdeqwvBV/dlVd15/m1rNkNrfo3Kn+w+Cys0F6Q36l8pt2udxEr7YdbAU58eFOQqiKuPnr9p+tmijcwJ/jaKMgrJLCQX3gMQ9P3QAR6l1yhEwrY54GuDsrz/LrPyBzwPpG0nzpLRdX2KFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff/E0RO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff/E0RO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF690C32782;
	Tue, 30 Jul 2024 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360165;
	bh=Ki0/cVyFG7iOgYEIqqVhxYMv+YRpoOAlXw/dU/LAa4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ff/E0RO/zebA9QDw5YxhKurLhO9A/uo9GlGzzEOuMcTNBTyP3253/fcmn8CUgonGP
	 XB7gqLw8ROd5NTzTpnw8wkfmE0Jq/SAjfTw+f1lVpY1EbobWzd26shScIsnJg9sLhr
	 PaX5N14jyKhassYwe4oddzYT20aGMHXuS0iHp6DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Wentong Wu <wentong.wu@intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 616/809] media: ivsc: csi: dont count privacy on as error
Date: Tue, 30 Jul 2024 17:48:12 +0200
Message-ID: <20240730151749.169413984@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -192,7 +192,11 @@ static int mei_csi_send(struct mei_csi *
 
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


