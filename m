Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A171EF941;
	Tue, 15 Oct 2024 12:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994200; cv=none; b=OFJJ7gWcFecvw4UydHeTzSWjbzswkjAYIoZR0Q89u4z/l5XLXzUlDwaxOr/bKourF82eQlP0W76/k4h0EKtpfqFpVRZ19BrX0cQDwnb3EdlNq8Gpp/BZIXXokDyOE4UnzNufAGj0ZMy7+pQC6x21lwlem3hARRpgyHDZ7cvedfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994200; c=relaxed/simple;
	bh=MQUgX2Ci4GE285drRM50b2Gtk7+cS1u6g2w3s/WCCNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1mVqD+QXZjpB7bCymFPGv9BmKFiphkdKdstpnqujLAgxYkPPRAoeRjn39O9hilSKPhEoaqN4uA3Nwwfns0geH2MVc8TvjaCQk5CRV9t/9owiFt258chOR+kmQMd9lrHpxORZTup4yY7dymhyWeTYgFCxkigGmzZoa16rp8edp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALP8uMRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALP8uMRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F29AC4CEC6;
	Tue, 15 Oct 2024 12:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994199;
	bh=MQUgX2Ci4GE285drRM50b2Gtk7+cS1u6g2w3s/WCCNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALP8uMRYQKRoEwSPkkscm4Xl17vyNVcSXQyN4Nebzl+VUINEKbMMWrAOl7tLaf21m
	 ZE3f2Ypey0IHy5ytAFnrttQhLrWaGP4eyPGklLonbRdyfEVVGvK5UeJlnAj6igMmPS
	 MyaCRATjtyETLqOIVg0o395ZfMg+0Mfi7Nr9MqO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Chen <philipchen@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 618/691] virtio_pmem: Check device status before requesting flush
Date: Tue, 15 Oct 2024 13:29:26 +0200
Message-ID: <20241015112504.861498881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



