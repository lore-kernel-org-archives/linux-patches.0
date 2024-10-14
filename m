Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699C31C6F55;
	Mon, 14 Oct 2024 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919821; cv=none; b=QhA4AhKFipZS+JcTl4EeHd6m+V0Diy9rGt+J5SY1HldgSjyDC7h5FAUK/lU5v/vXdAIUcaPdjctg5xbqHB+foigM5m8vz0f0qVr9dpL9uUNVBheP+0eKhqUxalXJ6yBv2XlvWsfQnFJHF2LuLhOgaUJCf1VKqpAfy6pV5Xs0LkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919821; c=relaxed/simple;
	bh=yw8bFlcuoYW6CUfl41SnGEKKbsiyBVEurfzGaOnaPaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/ZuqIxOiOtJgWA57EHSw42cU1AytYecUhpIl4aIaUpG7sKjwEhci/Ol/xlUlv/+Y/C6AZZ36cBKl9Zmc3nNc4+4SfITvzRZG2NJSyTtqpZo9ZWo88PKNJaGc3/JilFzyfkiptql6Tkk+FWTtSHvNUTB0Cv20hDpUBxef1wBfNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nd58eAY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd58eAY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFDAC4CEC3;
	Mon, 14 Oct 2024 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919821;
	bh=yw8bFlcuoYW6CUfl41SnGEKKbsiyBVEurfzGaOnaPaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nd58eAY2JQoEhiPZWl6Q5+P0jlP/BIy5ST/N7rfCq8f7k0TRoPjh5AJkmrKkeQnE0
	 ocm37p9dpX+FcbSUtDQi+LKFRKyUk+sM5bceZT4RmZkel9pHGrRRnCdN+/EDxRisnw
	 4k1J4gY06KtffOyJhf0xP8HAgGnLjOJ9eBKR559o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Chen <philipchen@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 716/798] virtio_pmem: Check device status before requesting flush
Date: Mon, 14 Oct 2024 16:21:10 +0200
Message-ID: <20241014141246.195593584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c6a648fd8744a..a78e17a43a9d2 100644
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



