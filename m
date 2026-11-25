Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621214;
	b=lgdiQbKtEtK9McEJ4kJEXQScvP3l8v+Qt8un1UqdqqL19po/hxnq3NgWZvyDM/yYGXwR
	 9GdgawgbAZcZCa4XX9wE8+Cbz0XpRq83jC8LXnk1vzpHujyvIzid4Ju/yiV/h4qJYQ7Nt
	 maqQjMOb7CnYITgrOsvkrYo/QGfaZmlFaK1BFGK2yA41ea2fGF97r/RLb8jiQqIRBPSUv
	 zEyWApZmp+sSfvFqit9zrRfXnCnvO0hj0xAhG7WJDCa6WkURe/8MoEqe03bo6sIg9SoEx
	 UGIIjzjZgkYrtfrnvoCkoCWoJE5uSVLzldAEHWC1QHHlIKajyMNymd+SzSB0Db6J/xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4fMD/fTiIslgZBwV6ZUEK8VxzFqIdO5G4yM/mCNZSmQ=;
	b=bu1/xgjH0ezy3XqG6rjYSkpahp/o/Gx3X6vKRB2xpcX98P9m70LpvnUwHxDAxbfGC2ib
	 +UYJhTvYm6G0MnnIVRQt76x3h4IEZK2k5FoG3tIH1k1xQoM4c5MIxcV6ekmDg0Wr0MK/d
	 bb3HWsxPmpCLk4uPVZLRPs89JGZdMqsL+2FYo+TpmD+NgOcagZzhCoAwZlz1jbaOwUah1
	 qJrzw949N43bZOkOCjntAFSxXEzgpToasnDSfPog5HsD4Skt0YPwJ9GosXI7hTj0m9Uc0
	 SMKT/PBNZNlS7Z9SueYihJOrb/EuRmPKHD9iAagtAgP/maf68Etoi3oh6T0ZyKXMWZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSEEM2o4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E2960A2607;
	Wed, 25 Nov 2026 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSEEM2o4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE781F01564;
	Wed, 25 Nov 2026 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621214;
	bh=4fMD/fTiIslgZBwV6ZUEK8VxzFqIdO5G4yM/mCNZSmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSEEM2o4gPFQFAF51g86sLdOrCqPfKQ9k311p6CiGpMmsZd6YFD5E9xsDq4+WSNx7
	 FBV/MpIkjbR1lyLSkMfmINTArncJQHxvM9QAzTBN332+9volgMCfQ/Rd9kwtfgdxrf
	 sZDDWOKOISjf8oBAJ4C5qs1tjf6gtNYj5+6Aaeks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/990] vhost: fix dirty logging for in-order used ring entries
Date: Wed, 25 Nov 2026 15:25:22 +0100
Message-ID: <20261125143825.724312153@linuxfoundation.org>
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
index 78cee55cedf85..87079382c9714 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -3136,7 +3136,6 @@ static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
 		return -EINVAL;
 
 	start = vq->last_used_idx & (vq->num - 1);
-	used = vq->used->ring + start;
 
 	for (i = 0; i < count; i++) {
 		if (vhost_put_used(vq, &heads[i], start, 1)) {
@@ -3149,14 +3148,31 @@ static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
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



