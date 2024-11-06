Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346111DEFC0;
	Wed,  6 Nov 2024 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898672; cv=none; b=dwhdZJ7UGo7DG999g+bPoJELTPvlZ3/ZnWfrwiUxCUd5xaji6zRpZ7c0AMhX2AphsxrMi/NBuTG0QCeqKz9oPpQY1VNgS/+KUR0jEwb3nHGZ7coCYwiwR0ctK/k2Vio5tCftpROKGIH1aRHuzvlwmO6NUoCv4rQ9FyoBrWv4iQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898672; c=relaxed/simple;
	bh=YPmSyyoQcfEqPFmIO6B1PLumwDeSgHI+IivbWPw2nag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7D2OozyY/rwylkTiX/+xEtaTIktYz76zUg8fbVZCW7Z4vtr+xy+LAjE/yW19mE+99m1t3AD1JdoBbVu9ggwU2/l7kUHO7DvHc4luV8x5ZIuE938Esvgvzk/W7Nxy8NGTp3sd6FiLdKVu5yjePXeQrnq48qztcfaVoW3AGt5vn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZHPB0PO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZHPB0PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565B9C4CECD;
	Wed,  6 Nov 2024 13:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898671;
	bh=YPmSyyoQcfEqPFmIO6B1PLumwDeSgHI+IivbWPw2nag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZHPB0POtneuGfVhCOdgaKQDU8sXZH7NZ3dpbxe5XW32ZMgsd8fcqATjupPPeMYiM
	 TOgXH0iihZ2q7aHv3ZCMW1ZKNZHdMJGshEN2S5AQmxz/IbSSerb5oTpHm4lHleSktc
	 n6fZa8ZJH+CGPIK/VxWpZ+n2iqqf14mMQylOjHA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Chen <philipchen@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 317/462] virtio_pmem: Check device status before requesting flush
Date: Wed,  6 Nov 2024 13:03:30 +0100
Message-ID: <20241106120339.355805191@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



