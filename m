Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136B322D799;
	Mon, 10 Mar 2025 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627599; cv=none; b=t7uuszDKAwqa72i61gg2waShnG41f4N4TuIkm+3Jxf3LpLT1hyyh5+W6INjiJD7nzON6WuamT6xPsG2n9FaHUr5HBH1ZnGlNy7x5w8IYY2YS6dHDTuJZjC9P1n/OhZVkJ0oL74Ci8g8WbmpoRRg4a4q1wpEuajtanwtJL7X9Acw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627599; c=relaxed/simple;
	bh=xfavAObudxEKkVmuB6LRaCJSYrQpb1rBWsmkF7xcwhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEyb9N/Kheln1kSwIVJUaT5MUOghjpwY9WvLYJE0R2R0egYUbXTjtvcVIxizpcA359st6B0Fx0DxNReL+aX4fvC+kfybS6D3J9gCaUm0iP0pVn8Y4+DSMuHXmpyBTMKaLONw6hCPFSopg2nRNWIv/q4qHTFWcWbrPJWCorE2qa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA6Q3fqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA6Q3fqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B23EC4CEE5;
	Mon, 10 Mar 2025 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627598;
	bh=xfavAObudxEKkVmuB6LRaCJSYrQpb1rBWsmkF7xcwhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA6Q3fqkghBW/E+iJAWoslgkY4IRGu4EyLS+I/o1NbYFFBniuiSLbTFNlA8O9Mosa
	 9hRipyGlfmg144KMnXKfqfUe2ODVGG6W3HbR73JUH71nMuXyuFM+391vg7V5KcuNM0
	 m9vl6MS3pBF5aF56ysZnA1/b62C1m08hjV9iI1KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/269] nvme-ioctl: fix leaked requests on mapping error
Date: Mon, 10 Mar 2025 18:05:05 +0100
Message-ID: <20250310170503.780475467@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 00817f0f1c45b007965f5676b9a2013bb39c7228 ]

All the callers assume nvme_map_user_request() frees the request on a
failure. This wasn't happening on invalid metadata or io_uring command
flags, so we've been leaking those requests.

Fixes: 23fd22e55b767b ("nvme: wire up fixed buffer support for nvme passthrough")
Fixes: 7c2fd76048e95d ("nvme: fix metadata handling in nvme-passthrough")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d4b80938de09c..e4daac9c24401 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -128,8 +128,10 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	if (!nvme_ctrl_sgl_supported(ctrl))
 		dev_warn_once(ctrl->device, "using unchecked data buffer\n");
 	if (has_metadata) {
-		if (!supports_metadata)
-			return -EINVAL;
+		if (!supports_metadata) {
+			ret = -EINVAL;
+			goto out;
+		}
 		if (!nvme_ctrl_meta_sgl_supported(ctrl))
 			dev_warn_once(ctrl->device,
 				      "using unchecked metadata buffer\n");
@@ -139,8 +141,10 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC))
-			return -EINVAL;
+		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC)) {
+			ret = -EINVAL;
+			goto out;
+		}
 		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
 				rq_data_dir(req), &iter, ioucmd);
 		if (ret < 0)
-- 
2.39.5



