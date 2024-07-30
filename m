Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB0D1A6166;
	Tue, 30 Jul 2024 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357940; cv=none; b=YSu54a7YMWYXd49CFemP3XYEtmtS8WlyV2j23oY2vKPXfO4swGPHgvTVCypAtAkgpiKFXoBsEv+GjNNZAhiD0NceApTtsoA/2fdIEf8JusROdYry/KXmLHXij0xuD8nhX3nf+TVGZixIg0j8uIpXYNS1gdB50kFGkrDLYwbEnNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357940; c=relaxed/simple;
	bh=vZqItG7BWZsxm9SLA0+R1T0mpkpDPaQ0fXQtIS70/dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCO+I7hKjMlQyKelbHVp9pdjkK74gnschsgho8gcFJ90Q12zLlYXN4M/TRhdxJNrarqmfsQTkgn9J8KkCwG7aROjp5p415/ywofZln6JFse6nKuqZXyNUc3DtyVBP8WP6fgWODaJ4cbSTVGZ5hXq+zYAfn6M7TtDQ3zXNa5w+tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0bYU01x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0bYU01x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E563FC32782;
	Tue, 30 Jul 2024 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357940;
	bh=vZqItG7BWZsxm9SLA0+R1T0mpkpDPaQ0fXQtIS70/dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0bYU01x5i6OG7VvTIvqHuDbks9RMLoOXiz+QLenFP15Xp8dFtCF8gJWrRDyU9L2O
	 iwWj4Akgh/sQbyIc62IEcLG0RicVB+FCBnTntr7NpuSJkT9qqqNOLzOlZ1nw9QyzWM
	 6Qn9yoA8frfVv5yydtcZbB32Pf5VzZZT6GVQtA8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Arseny Krasnov <arseny.krasnov@kaspersky.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/568] vhost/vsock: always initialize seqpacket_allow
Date: Tue, 30 Jul 2024 17:46:34 +0200
Message-ID: <20240730151651.089883986@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 1e1fdcbdde3b7663e5d8faeb2245b9b151417d22 ]

There are two issues around seqpacket_allow:
1. seqpacket_allow is not initialized when socket is
   created. Thus if features are never set, it will be
   read uninitialized.
2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
   then seqpacket_allow will not be cleared appropriately
   (existing apps I know about don't usually do this but
    it's legal and there's no way to be sure no one relies
    on this).

To fix:
	- initialize seqpacket_allow after allocation
	- set it unconditionally in set_features

Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
Reported-by: Jeongjun Park <aha310510@gmail.com>
Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
Tested-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20240422100010-mutt-send-email-mst@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 61255855d4906..d94a06008ff64 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -656,6 +656,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	}
 
 	vsock->guest_cid = 0; /* no CID assigned yet */
+	vsock->seqpacket_allow = false;
 
 	atomic_set(&vsock->queued_replies, 0);
 
@@ -799,8 +800,7 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
-	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
+	vsock->seqpacket_allow = features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET);
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
-- 
2.43.0



