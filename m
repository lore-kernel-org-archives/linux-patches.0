Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585650;
	b=Y3tBhkWxomftqBCkpy3HoKcG0F4JYrAxPPNhNRA3bOsuz8H3ldU2KSX5i8KWaQw+Z3AX
	 5cNtoV6Gk2nnWCfC9Xu0nvMx84FzPXvUFPXZy/MgjPNhnjCz2baN6lrubx389+uvNhh4a
	 gFDrSp7NOCG2v9HJaxhlL71hhgbvylvEhQBD8XBkmrWWiTXWclkDUI4D+wxZqyct552MV
	 8n5HMyV5xlHgZB+0tea8LHejkXlCspG4n7aYKhlWPPd04IwaUAgC2zltIAwZ76TRVBx+M
	 Q5ViS1fbrQeypRHnzVYKUaxYD2q5v4j6UFnjYxNsj9S1w9c/c2fDefpQdU/cUy3fqWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vH3sk1yw71abdop+cadEO+l4Q8tn76oVvjedFTS1+cE=;
	b=xRvg6KYGnp2fRj850us8DhM8w42WTjXctyful0EwMxXh5dnFAbFtb9UkksI9muqE+bdZ
	 8q3gyTjm0T++dvS4M1xiF5jPGlg6/E0/OkVu+d1KmQ9SZYd9GVXRH79Qw322VS/sDoE5u
	 S+LhBllw9JHOkMLaRr+GB1mcqqk0AzPkq2AZhB54VQrb+zNkWFK0Ccrl/7BAdbsEbHYCy
	 GUAUJ3xIxV20t2qQAMphw27O0vFd+gCN5uGe0zO7q5/xzsERdPCni4GgnqGaVqfPzYnBw
	 n50r83fSHqx/RrzBFxFcqyuDAWfkmNoUgRswHyu02BMkv3L9OQoqnjkr8Ez830T2S1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJFOW41P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBDE606B2D9;
	Fri, 13 Nov 2026 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJFOW41P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B80A1F000C4;
	Fri, 13 Nov 2026 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585650;
	bh=vH3sk1yw71abdop+cadEO+l4Q8tn76oVvjedFTS1+cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJFOW41Pm0C/w1pq/NhtDYCPhfKvU+Yn2rnw/Ez4sKi+BwRZ6MF56uRoXvIsS1zmF
	 dEMvvxsUdinxYw0VYUpjlzrBHHGj3bTqy6g0dPdH9ssrF84UCSealM5Db55qm0cI1n
	 wWC2VhxaFwjK7RrL3aq7bhA0FBhQjZjLRO8/bW80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 266/507] vhost: fix used ring index wrap in vhost_add_used_n_in_order
Date: Fri, 13 Nov 2026 10:49:30 -0500
Message-ID: <20261113153803.615039634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit e244725e86be02cd85cb878b3ed8570eba2e4be1 ]

vhost_add_used_n_in_order() advances start by nheads[i] but wraps it
with a single subtraction.  If start + nheads[i] >= 2 * vq->num, start
can remain outside the ring.

With used-ring logging enabled, start > vq->num makes (vq->num - start)
underflow.  log_write() then sets bits beyond the dirty-log bitmap,
potentially corrupting adjacent userspace memory.  This is reachable on
the vhost-net TX path with VIRTIO_F_IN_ORDER: done_idx can reach
VHOST_NET_BATCH (64), triggering the issue with a 32-entry ring.

Wrap start with a mask to keep it within the ring.  VHOST_SET_VRING_NUM
enforces a nonzero power-of-two ring size, allowing start to be wrapped
using & (vq->num - 1).

Fixes: 67a873df0c41 ("vhost: basic in order support")
Cc: stable@vger.kernel.org
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261020232956.99970-1-fangxy@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 44cac11b68d2a..0226c4c597093 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -3172,8 +3172,7 @@ static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
 		}
 		start += nheads[i];
 		new += nheads[i];
-		if (start >= vq->num)
-			start -= vq->num;
+		start &= vq->num - 1;
 	}
 
 	if (unlikely(vq->log_used)) {
-- 
2.53.0



