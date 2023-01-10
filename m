Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DAFA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA979C433F0;
	Tue, 10 Jan 2023 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374110;
	bh=FVlfO/J8VkzYWSb9W1b6+Ms5IcyRbnr1I8DQGyb17Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWqGGi6I4gDkFDaiUALoimLTtT7kP4RivC8oAu8cZsD9q3eqwNPGfdzUxvKoh+8UZ
	 0y4HfpXlytv+ZmvMvwGPrz0UHmDn1a1BjD5mTj6dpcSF7b2g6kJ3s41LJ8AcL/bYE3
	 OK3MQQvFItIoKfP/HceW2+laPJellQkQZJED1cX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Dawar <gautam.dawar@xilinx.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gautam Dawar <gautam.dawar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 049/148] vdpasim: fix memory leak when freeing IOTLBs
Date: Tue, 10 Jan 2023 19:02:33 +0100
Message-Id: <20230110180018.766578406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 0b7a04a30eef20e6b24926a45c0ce7906ae85bd6 ]

After commit bda324fd037a ("vdpasim: control virtqueue support"),
vdpasim->iommu became an array of IOTLB, so we should clean the
mappings of each free one by one instead of just deleting the ranges
in the first IOTLB which may leak maps.

Fixes: bda324fd037a ("vdpasim: control virtqueue support")
Cc: Gautam Dawar <gautam.dawar@xilinx.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20221213090717.61529-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gautam Dawar <gautam.dawar@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 1701e0623408..6489f44bca1a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -679,7 +679,9 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	}
 
 	kvfree(vdpasim->buffer);
-	vhost_iotlb_free(vdpasim->iommu);
+	for (i = 0; i < vdpasim->dev_attr.nas; i++)
+		vhost_iotlb_reset(&vdpasim->iommu[i]);
+	kfree(vdpasim->iommu);
 	kfree(vdpasim->vqs);
 	kfree(vdpasim->config);
 }
-- 
2.35.1



