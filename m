Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90814350D57;
	Tue, 26 Aug 2025 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219042; cv=none; b=o0oonskQBBvUKf3daO46VQT3CvgIQTn3xyhLhFXocfvHOT8ZWPNdUsu3j/0TGGptNdYAz1XW7ogzyUMJRzPqJjGcBduynLrnR/RjlVgm4Xfra7TScOZ8JOBqRVDEM3Yova8qYja1eIprl1F82N+RL4tD1aktMVVkCk36kgibJX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219042; c=relaxed/simple;
	bh=xMjlQuijOvZmWFWVLvztsbZ2kO++tdDBz0rSfvPuSS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hW3iEfQPpbB9dqOxGQoiFz+cXy6NMIqeWRicWZlhjESPiWGMiRmjwX8O5Wg1z2tIxxFp5aG+9Kl3kzOFx9+TCyWg4BR8TxovRDfeeZ9m8ZWj2EK5UIEyEfPwiKUyiLOLvwp72+mtksaqenyl6JOfk9ermSd7xNAnFJKMKStNCMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2L5L4v8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2L5L4v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2377AC4CEF1;
	Tue, 26 Aug 2025 14:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219042;
	bh=xMjlQuijOvZmWFWVLvztsbZ2kO++tdDBz0rSfvPuSS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2L5L4v8Zc1uqTN2k++9nvVYHStcmnqWaCsz3j1DuGTUT0S4uh29aMbBuRwdIrskA
	 JO/2tghndHyk/e/z+YKfG1J84e8YoqJTpW1ea/ewNaf016lER2eXzkLqUlxh47s9s7
	 VRfxFq5xpMI6L/7zVhjEK9JBiaYFcPZnHvj+NdOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/403] vhost: fail early when __vhost_add_used() fails
Date: Tue, 26 Aug 2025 13:09:17 +0200
Message-ID: <20250826110913.213272881@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit b4ba1207d45adaafa2982c035898b36af2d3e518 ]

This patch fails vhost_add_used_n() early when __vhost_add_used()
fails to make sure used idx is not updated with stale used ring
information.

Reported-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20250714084755.11921-2-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 484818796978..8402255760b3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2422,6 +2422,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	r = __vhost_add_used_n(vq, heads, count);
 
+	if (r < 0)
+		return r;
+
 	/* Make sure buffer is written before we update index. */
 	smp_wmb();
 	if (vhost_put_used_idx(vq)) {
-- 
2.39.5



