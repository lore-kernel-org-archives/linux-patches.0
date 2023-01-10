Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3567CA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A877BC433EF;
	Tue, 10 Jan 2023 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374538;
	bh=vNsH7eWlvcz5wFJt4aj6lVyLWaIj7f8RGZr3NLiL5yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmyLIBFqEyP0jwER4/OWZ3i9H8XP94Ol55vCJujf3T+pDufhuMZCUaiEklHtT5On3
	 wmyK1MCutGdMIdrD5sQ8KLetNBFU0eyf65/Rk0uc+JXsnDQ26TGlbAeS1TKqwkqMYX
	 3rOYGDypo8GeLpIanAsfsHUizaxH4wbkCXHuwfwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Dawar <gautam.dawar@xilinx.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gautam Dawar <gautam.dawar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/159] vdpasim: fix memory leak when freeing IOTLBs
Date: Tue, 10 Jan 2023 19:03:18 +0100
Message-Id: <20230110180019.899324949@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index b20689f8fe89..cb88891b44a8 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -689,7 +689,9 @@ static void vdpasim_free(struct vdpa_device *vdpa)
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



