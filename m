Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EA7208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcCTmurp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B6C433C7;
	Tue, 31 Oct 2023 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774394;
	bh=DVuqq+buzHwqnlArojlZStkL5De6GFcA07KQ9sCGExA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcCTmurp06sp5ACSB2aKkAai30YGWViIXBGDRWGLyBLC2Zfb9FKIgGPoKO2EYW+hN
	 4dp85l7P6hIB6W/yYRbPOVd4gNbTvHrnWVbZNuwzMQsbWkyqYWPivNYiV8PBND1sYg
	 XMutmymEjRfGjeEE3EUDQcNEOe+7D2XbQ7kk3KXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shawn.Shao" <shawn.shao@jaguarmicro.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.5 032/112] vdpa_sim_blk: Fix the potential leak of mgmt_dev
Date: Tue, 31 Oct 2023 18:00:33 +0100
Message-ID: <20231031165902.339672220@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn.Shao <shawn.shao@jaguarmicro.com>

commit d121df789b159e9a8ee770666f210975a81e8111 upstream.

If the shared_buffer allocation fails, need to unregister mgmt_dev first.

Cc: stable@vger.kernel.org
Fixes: abebb16254b36 ("vdpa_sim_blk: support shared backend")
Signed-off-by: Shawn.Shao <shawn.shao@jaguarmicro.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20230821060333.1155-1-shawn.shao@jaguarmicro.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 00d7d72713be..b3a3cb165795 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -499,12 +499,13 @@ static int __init vdpasim_blk_init(void)
 					 GFP_KERNEL);
 		if (!shared_buffer) {
 			ret = -ENOMEM;
-			goto parent_err;
+			goto mgmt_dev_err;
 		}
 	}
 
 	return 0;
-
+mgmt_dev_err:
+	vdpa_mgmtdev_unregister(&mgmt_dev);
 parent_err:
 	device_unregister(&vdpasim_blk_mgmtdev);
 	return ret;
-- 
2.42.0



