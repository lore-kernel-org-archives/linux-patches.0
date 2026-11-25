Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618058;
	b=LUptA4aBtQjDBTLDOrkTZfjwnW2sP+jjX314yuyQh+iSz7UtAEtwmegYmLs6ek4eWHNs
	 1zwkvwL6S/Ec7XeDZFSjks+bJmuWO2hLHx6AraUzUepMwqzACZ02bZdjrvM5bX/q0eUEG
	 EvvSxLrbXrb4DkUJPL4cgUhJyNNrfV/c4g69lUFuDBjEmRtg2mIpkaBkc2lnOcchYBTO7
	 LxTY3mCX9nlZ0JSA4N0c7f/9+LTRUEYxhuuAZtynVvUdR/nLtU9atygOjqOevWUFHs6+U
	 qZxLDbMjuXVtnk+p9NqNBQiSlzQFYSiBhR3cohXegJroWNu0r9Qunw807NaH8fhBFMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N+4lp0imzPKJoma02hOHCA80pyopKErQeBOkZjgNkeI=;
	b=ejE+rRRhPWUWh8NiMKzlfAo12q5VEYXxGUuf+vrsqcBVTmFHqCiYI4v3FB5J6c+OCqra
	 byqPJGRXrcjG0h9WlPtUzU0bAxNREKIGrKgljWULJFjICa4dQhR8amWE858/uA87sII7b
	 g5o7adZb3zlP0rqWHmdF9hjaTzZnwyrwTpQWkNjwf1rBpMvVL94JE6qTtpv4xBFLf54pJ
	 L+yhJC3PYMBpEOi/3VkpGYt+cLp/uGN8flCBTkyR49y+x/Gd+VpE3bupV3Vsy4sgMa1x+
	 6DEb44ZxpbvIneMd6Ox+qKUX+/1G3HyPQmRLXkx6i+BfJkAC/+OlQNgUqSSfalI9z9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdWWKHxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2655D606A323;
	Wed, 25 Nov 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdWWKHxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D0F1F000EF;
	Wed, 25 Nov 2026 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618057;
	bh=N+4lp0imzPKJoma02hOHCA80pyopKErQeBOkZjgNkeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdWWKHxe7dm3D2SIY/qzVtU9DC8DcPRAWtCQSTmo7s8SysyE9Bktt92OA6gmEpxww
	 452Z4xCSSJ+eM1au3N1jMwf0jZ+7ujH98n0CYJIdWXaLqdOcmCaCVkos1kdCOpK21d
	 lsfbQM7jVJuYwcaz7VPUII0+LvxhnwA/9IOHPOEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0157/1005] vhost: fix dirty logging for in-order used ring entries
Date: Wed, 25 Nov 2026 15:24:55 +0100
Message-ID: <20261125143825.415974335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit bfcde6b64769bc168037b8bd882de4def4b2b3f4 ]

With VIRTIO_F_IN_ORDER, one used ring element can represent multiple
buffers, so vhost_add_used_n_in_order() can write consecutive elements to
nonadjacent slots. Dirty logging combines the initial slot with a length
based on the final position, which can miss written elements or log past
the end of the ring.

Replay nheads[] after the write barrier and log the written slots,
coalescing adjacent elements and splitting at gaps and wraps.

Fixes: 67a873df0c41 ("vhost: basic in order support")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20260912-fix-log_write-v1-1-72c23db01268@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 0226c4c597093..86126e2ea8cbc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -3163,7 +3163,6 @@ static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
 		return -EINVAL;
 
 	start = vq->last_used_idx & (vq->num - 1);
-	used = vq->used->ring + start;
 
 	for (i = 0; i < count; i++) {
 		if (vhost_put_used(vq, &heads[i], start, 1)) {
@@ -3176,14 +3175,31 @@ static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
 	}
 
 	if (unlikely(vq->log_used)) {
+		unsigned int log_count = 0;
+		int log_start = 0, next;
+
 		/* Make sure data is seen before log. */
 		smp_wmb();
-		/* Log used ring entry write. */
-		log_used(vq, ((void __user *)used - (void __user *)vq->used),
-			 (vq->num - start) * sizeof *used);
-		if (start + count > vq->num)
-			log_used(vq, 0,
-				 (start + count - vq->num) * sizeof *used);
+		/* Log contiguous runs of used ring entries that were written. */
+		start = vq->last_used_idx & (vq->num - 1);
+		for (i = 0; i < count; i++) {
+			if (!log_count)
+				log_start = start;
+			log_count++;
+
+			next = start + nheads[i];
+			if (next >= vq->num)
+				next -= vq->num;
+			if (i + 1 == count || next != start + 1) {
+				used = vq->used->ring + log_start;
+				log_used(vq,
+					 ((void __user *)used -
+					  (void __user *)vq->used),
+					 log_count * sizeof(*used));
+				log_count = 0;
+			}
+			start = next;
+		}
 	}
 
 	old = vq->last_used_idx;
-- 
2.53.0



