Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D681A76C4;
	Mon, 14 Oct 2024 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916142; cv=none; b=DNanRBDQEI0Tt+fnf26UbluIpZPDQcrmWn8NWqYTcAMhCpfBsmmie29VCg/san0pLDLx0J/sFKwBSqfws0rY7FVYDkSzkfVFgiE6VVkwOamYd9qbIcuvKeHZ8clnqa8ZfdiGW+0ONIm9Ad1pjnADma9iCGQWlaZ8hR8AMR9oq5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916142; c=relaxed/simple;
	bh=Ggh4g33dJtVlzqBZ/gCe6sTOvpcYqUnei/4S3oWpXA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmCXXPk8kRbuGioFOhZq9H9K5rYi0Lv7HYez9hL+YttFxQ/yc/CgM3lQqOlKsv7zPI2Ct1KQVV0nmpTALjy5gqHJ7Fc52g1LXQpgH/rJW5r5D/h/vVen87MgcFFG1nzgL4sdOD3CKmMLaScDVYCIDCMhXlWOd3IvJJR9uFmQgRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIHi/Qhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIHi/Qhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B4FC4CEC3;
	Mon, 14 Oct 2024 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916141;
	bh=Ggh4g33dJtVlzqBZ/gCe6sTOvpcYqUnei/4S3oWpXA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIHi/QhlUEHvRCgS9mOjlFId55jyc19c5DQHVaWrtTfF4hF/lecRdAKrP7u0Ixkax
	 9er+Dull8wQ++LsPAgpsRsLjQsUlPV5o3r6HIkb8rks8lbxx6RtIjVlx98PE2SBjfs
	 FNtzBgY/KwsSTSi1oKTJQZ6ricCfahwr3GeSyxwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Chen <philipchen@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 065/214] virtio_pmem: Check device status before requesting flush
Date: Mon, 14 Oct 2024 16:18:48 +0200
Message-ID: <20241014141047.526819046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 35c8fbbba10ed..f55d60922b87d 100644
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



