Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198E81AF0CE;
	Tue, 15 Oct 2024 13:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998404; cv=none; b=qF9rhMwbbauOFPGajz8Yh6067XyhQJQ4xiiimN72+V2nkPM0HkdOXQ02f8xljKZB2Mx0JgsLd5k5lR5GMOCwBL+JSXg8UlzkebyS+1P94tLjIn8rakOHR01cIBdQYpch0rPxJPilmwXXQuundZe5dOz2hjn4cVZJPEp4+kJXnNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998404; c=relaxed/simple;
	bh=oCy8YcWT7obiDtohVtWJc6VHX007J4UlDQTB+FfSNGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVYFGz7lV8iE35uYhVxq0b9iHX+EaTwMgkTSwpOPKwjNW5/hjVtNjWvIsitd8l+ndBX1aQQV6IrLiUCcM+9mY1LNhCQCZii1dYTpwMl5CqF3ZUE5h5AMggGufHyLv8a5yZx5bbuF+d6zfqqNp/3so/rOXx+7x+UIB2H6yC04kjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNPlJwmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNPlJwmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D025C4CECF;
	Tue, 15 Oct 2024 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998404;
	bh=oCy8YcWT7obiDtohVtWJc6VHX007J4UlDQTB+FfSNGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNPlJwmcoBPbaXXLzOR4k6qIvm/sZ90LBWqy6olLOl4/Hx5HsJXhwlaKhPgoz5w7z
	 aU6dOmAduDjSDepuHcnPTv6/WEEAktujMJxQLijgABl0Bhh7Yr0S1TmObbfB73ZNKv
	 vZjfSGgvex3zcR/oSOJwn0WarCRy9LlLouSXjmkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Chen <philipchen@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/518] virtio_pmem: Check device status before requesting flush
Date: Tue, 15 Oct 2024 14:46:10 +0200
Message-ID: <20241015123934.990229789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Chen <philipchen@chromium.org>

[ Upstream commit e25fbcd97cf52c3c9824d44b5c56c19673c3dd50 ]

If a pmem device is in a bad status, the driver side could wait for
host ack forever in virtio_pmem_flush(), causing the system to hang.

So add a status check in the beginning of virtio_pmem_flush() to return
early if the device is not activated.

Signed-off-by: Philip Chen <philipchen@chromium.org>
Message-Id: <20240826215313.2673566-1-philipchen@chromium.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/nd_virtio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 10351d5b49fac..41e97c6567cf9 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	/*
+	 * Don't bother to submit the request to the device if the device is
+	 * not activated.
+	 */
+	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
+		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
+		return -EIO;
+	}
+
 	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
-- 
2.43.0



