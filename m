Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74B2C85B;
	Fri, 24 Nov 2023 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4V+DD5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A317C433C9;
	Fri, 24 Nov 2023 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851860;
	bh=ZmO9UHmURWwC8n4eVR0pP6dE05ZdPHkRr9cKBgr46TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4V+DD5I+yUbG/u2mLRe1nQYGT4F5wPr6gDL8atET6DKOzN64j9eqEgx/3KVF7lXp
	 aP3F1RL8ojZoCgP7BmAaxACDslgqaArjsj38WjdLdx1ztoDE6ZfFjIhEAD0apfQuH2
	 QzEO22Oyu7fqdhDT/Mbz5MpvDxlXAGJpF36CpvbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/372] vhost-vdpa: fix use after free in vhost_vdpa_probe()
Date: Fri, 24 Nov 2023 17:48:32 +0000
Message-ID: <20231124172014.645543122@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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
index 31a156669a531..c8374527a27d9 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1427,7 +1427,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
 err:
 	put_device(&v->dev);
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
 	return r;
 }
 
-- 
2.42.0



