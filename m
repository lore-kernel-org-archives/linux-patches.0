Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621403;
	b=MTEJ3Slh2flofrio6E/lzoLhnAQwo/vdtzaUTIG5AnlgMYU8dSTYOQ/0s9C0OGcHGIP6
	 mu/ydNicsFz9mi5oGDSN/1IhNlh7OT05jixbyXOppviVoJjVTMCRS17xxJ+h9Sh5/cvDm
	 21hEasDbbM85NUQL0FQmrUFMoyFKbj1OWqkXSzLDSOJwONHO5LKHh13d7y+kX94XRacWI
	 Qm6s7Z6HIIrZzs+SAktjDHhc9f1MKpQR9cASU8UfU70Fq/hgXVOvd9onF/nctAkdMMXwG
	 5kgmxMy8Iuw9eCkAmi2aj324XoxrP4g0Gc3CCh51Ee/wue2elE1jX6vIcL0Ln7Tvi3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9YiwMef5dBAFMrOTq1zYO/2TYpZqEaO4jDbm6i54NE=;
	b=Om9QSElYdvT3Ax8mmGEodtT852nZ/5nIgUrl1rBQ5xag1KV33BHYNd5kHvQYZ57J5fn6
	 aCTjZq0lYxwLOsBOe7wGa6dq846A8ATZBq9ZGS8kAM46hMiMk08j9CCwPlk1MZv4DHEpQ
	 kNBLZgxnfQsCD21x6CIDgzNkoXxRRYsfylIQ1HpWV4ApQg0a+Hozgvly1HkxbR5fUA16d
	 0hw9KdScDyt5PgINmv7jHeL3umgVz75yL0JEorRYzmklYVKBelss4km98gNrv52IxNN5w
	 8usgwQUCUcUJBV43VQIgGFapqPO2bonNWayb9uk5w9Ju90T58NuCBHNqUq1gxjKiuog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXOXflHP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3048E606A329;
	Wed, 25 Nov 2026 15:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXOXflHP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C3C1F000E1;
	Wed, 25 Nov 2026 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621402;
	bh=+9YiwMef5dBAFMrOTq1zYO/2TYpZqEaO4jDbm6i54NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXOXflHPmBy1cgWRKgQHZrVAu0AFi8c22bOBH6pG7Ee76rRgfzYHhxWnxPNH3VZDS
	 xn/nVZ9ifOhL6wdwPws01E/n//OLuONNddEwW0NZepy/XUj8/84+r5ybrTNkleEeG4
	 TeztZoxkse99afZKQDg8mXsDRnyuYv4dDPynQ5S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/990] vhost-vdpa: initialize state before publishing cdev
Date: Wed, 25 Nov 2026 15:26:14 +0100
Message-ID: <20261125143826.940280725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 4b03d1e7f13613af708441a061556de99891a516 ]

Initialize the completion and as hash buckets before cdev_device_add()
makes the device accessible.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261011-fix-null-pointer-in-vhost_vdpa_release-v2-1-66ba929971ce@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 665739ba03f8e..9014ee30861ff 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1705,7 +1705,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 		return minor;
 	}
 
-	atomic_set(&v->opened, 0);
+	atomic_set(&v->opened, 1);
 	spin_lock_init(&v->config_lock);
 	v->minor = minor;
 	v->vdpa = vdpa;
@@ -1729,16 +1729,17 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
 	cdev_init(&v->cdev, &vhost_vdpa_fops);
 	v->cdev.owner = THIS_MODULE;
+	init_completion(&v->completion);
+	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
+		INIT_HLIST_HEAD(&v->as[i]);
 
 	r = cdev_device_add(&v->cdev, &v->dev);
 	if (r)
 		goto err;
 
-	init_completion(&v->completion);
 	vdpa_set_drvdata(vdpa, v);
 
-	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
-		INIT_HLIST_HEAD(&v->as[i]);
+	atomic_set_release(&v->opened, 0);
 
 	return 0;
 
-- 
2.53.0



