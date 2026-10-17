Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09A53AB286;
	Sat, 17 Oct 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255429; cv=none; b=lL0vORv89uzv+frv6kKk8xhivuiAta49+YIXoXh3SJ8S3L1p2wd1LKQLKHsEZjwtJ7GPtyv2FFbQVu6j1EFqqS26dn7msAFWbStAW2GNhfFh/MIiu4LetVETseZlbtocBAZvZFoNvn6zYLmiEDQgvbJ/zhKWY+H+MGNixTMImOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255429; c=relaxed/simple;
	bh=+OS1TNtPLlvecwjwks6lqg6NBFZ7wMe41FFqMzC6lac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk+GIzK8uT4rpbBRXhtamnrsRKYRXQimUKnBsODqy+syaTzRg1p0zSOcCNY0RyQf1OyEZJreZu+5jacFkoOr6Tp7zA8VOsIzAW7QpHlEJJg1IJmWhoO+tKx+XTK1jEifh4jMdrODhuHymG4lb9NEDOJOuLh5VVzYPg0Fk8uF/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoMoELhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoMoELhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137571F000C5;
	Sat, 17 Oct 2026 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255428;
	bh=HtVqt1VfDMDnI2Azxbpr7JjoRhg2nYglzkfQaNzD/xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XoMoELhn0CeVh3D8s27us0QpVnfOLBWLwE3fuNCOg8Q4d2a6UWd8bJUttfk8zVhV5
	 9Kdl01LuX3bojpcPPcJ/x88XfBKvbQFP63WuDCJ0I3vgPRHfpVnHP6Fk0zTk80h/IR
	 GqE5+sUVROL+zJcNka3UUKfa9pL/I36Bpgz+1f0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 773/869] virtio_ring: fix stale descriptor flags after a failed packed add
Date: Sat, 17 Oct 2026 18:00:14 +0200
Message-ID: <20261017160056.738611772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <graf@amazon.com>

[ Upstream commit 75d276e5bb68778b2916f98a2bc30f142ebadc64 ]

In a packed ring the AVAIL and USED bits sit in the descriptor itself,
so writing them makes that descriptor available. Those bit combinations
flip meaning on every round of the ring, tracked by a wrap counter, so
invalidating or validating a descriptor means inverting both bits.

Commit 1ce9e6055fa0 ("virtio_ring: introduce packed ring support") has
virtqueue_add_packed() make every descriptor of a chain available as it
maps the chain, and write the head last. The device consumes the ring in
order and stops at a head that is not available yet, so it never reaches
the rest.

When vring_map_one_sg() fails partway, unmap_release unmaps the segments
and restores avail_used_flags, but the descriptors it wrote to in the
ring stay marked with AVAIL and USED bits. The head is now the only
entry that keeps the device from consuming these stale entries.

For example, the ring would look like this now.

  Z - pre-previous command
  A - previous command
  B - aborted command
  C - current command

  [A1 DONE] [A2 DONE] <C1 EMPTY> [B2] [B3] [Z1 DONE]

When the driver now attempts to issue the C command, the next add starts
at the same head as B. If C spans less descriptors than B, there is no
end marker because AVAIL and USED bits were still in place. And that
means the device will start interpreting these stale entries (B2/B3) as
another command entry, which then blocks the queue.

This effect typically happens in swiotlb configurations under memory
pressure, because vring_map_one_sg() can then fail with larger I/O
requests which then leads to command abortions.

There are broadly 2 ways to avoid leaving those flags behind:

  1) Defer those flags too until the chain is complete.
  2) Rewrite those flags for the previous wrap counter.

Implement the second option in both packed add paths. The first option
traverses the chain a second time on every successful add. The second
option invalidates all added descriptors when any add fails.

With this patch applied, a packed virtqueue keeps completing requests
after a failed add.

Fixes: 1ce9e6055fa0 ("virtio_ring: introduce packed ring support")
Fixes: f6a15d854986 ("virtio_ring: add in order support")
Assisted-by: Kiro:claude-opus-5 checkpatch sparse
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260817223229.28954-1-graf@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c0276979675df..2dfc815c54f68 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1412,7 +1412,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	struct scatterlist *sg;
 	unsigned int i, n, c, descs_used, err_idx;
 	__le16 head_flags, flags;
-	u16 head, id, prev, curr, avail_used_flags;
+	u16 head, id, prev, curr, avail_used_flags, unpub_flags;
 	int err;
 
 	START_USE(vq);
@@ -1535,15 +1535,30 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	curr = vq->free_head;
 
 	vq->packed.avail_used_flags = avail_used_flags;
+	unpub_flags = avail_used_flags ^ (1 << VRING_PACKED_DESC_F_AVAIL |
+					  1 << VRING_PACKED_DESC_F_USED);
 
 	for (n = 0; n < total_sg; n++) {
 		if (i == err_idx)
 			break;
+		/*
+		 * The mapping loop made every descriptor but the head
+		 * available. Stamp the previous wrap counter's AVAIL and USED
+		 * bits on those, so that a later and shorter chain at this head
+		 * does not leave one of them available beyond its own last
+		 * descriptor. Marking them used instead would hand
+		 * is_used_desc_packed() a completion we never made.
+		 */
+		if (i != head)
+			desc[i].flags = cpu_to_le16(unpub_flags);
 		vring_unmap_extra_packed(vq, &vq->packed.desc_extra[curr]);
 		curr = vq->packed.desc_extra[curr].next;
 		i++;
-		if (i >= vq->packed.vring.num)
+		if (i >= vq->packed.vring.num) {
 			i = 0;
+			unpub_flags ^= 1 << VRING_PACKED_DESC_F_AVAIL |
+				       1 << VRING_PACKED_DESC_F_USED;
+		}
 	}
 
 	END_USE(vq);
-- 
2.53.0



