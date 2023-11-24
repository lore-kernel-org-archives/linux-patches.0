Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C97364BA;
	Fri, 24 Nov 2023 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srwpVQPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20762C433C8;
	Fri, 24 Nov 2023 18:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850799;
	bh=8CXzczJwK1MSy6No0XQKHJeVwLfW91R+iPwKorDh+84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srwpVQPrlJJ/3EOgJZA9wiswbypgmHCc720MSNoQiBnGqtgmfkpqFgFaRrnjLZeGh
	 I0V5WNzvTSTLFTIXS+x2k/5EeKt1iaGSg9cPJlcnlq9P9k6YicPALFtn+fpZIiJOeV
	 8pcW6m7fZrWqQqX/WQ92Vmo8xwOBZug8PLcndZXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 169/491] vhost-vdpa: fix use after free in vhost_vdpa_probe()
Date: Fri, 24 Nov 2023 17:46:45 +0000
Message-ID: <20231124172029.549712209@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e07754e0a1ea2d63fb29574253d1fd7405607343 ]

The put_device() calls vhost_vdpa_release_dev() which calls
ida_simple_remove() and frees "v".  So this call to
ida_simple_remove() is a use after free and a double free.

Fixes: ebe6a354fa7e ("vhost-vdpa: Call ida_simple_remove() when failed")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-Id: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b43e8680eee8d..48357c403867f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1498,7 +1498,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
 err:
 	put_device(&v->dev);
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
 	return r;
 }
 
-- 
2.42.0



