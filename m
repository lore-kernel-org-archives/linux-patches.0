Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704297;
	b=whfCQrmYz321T7jJC6H8gAK6mBoRWFNRy+5RXlzubQcwbpbPPuG3j4OHqBUMyPUcPnXg
	 r/B4MY1AWqcgRa9CFviUiXuQAtw02vybI6aho/wSr/Uq80EncxNfCMHWJfyqX2h9pthCZ
	 WOQNAcJELB/cEqp4vQ+4x+UgRqoecdJcU8RjCLj7YuBwXM32bDSdfE6HUCjBBcbVHnHT6
	 LkZO2SGXW5ENxVo83EcXLsnthpuS8uR3tDwUMm6Om5EL+qgoi9lJYeJtj88ukl5py+MpD
	 c5e9x2fuXNh5L4jeNsp7BWxtyfTcXoUbjsE6Ul6dnEXxSLiyFaQtiaGNd30wDff31+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nivPiwwKFerUVCAw/MkYLS69wh9NcdxWgcH8pbKwcHE=;
	b=TkURdRQxE7kmhjX2+pjK4ffAMtqpsER7iIfRnX5Xhr6Pq9u4KVH3HL4sP8S+0vlu6yAF
	 SGa1o+Yaa023FtWDg+oSdkMPTXmHq5cdo2a2USVm6pAbAhYskI3TArJrxtcWOI8Zfg9Q5
	 f+fiSTEfJ4QctrqOdwNE9Y3ZUse3m1AAN7Pf0qN94WHeRSooLvxUvqFkow+/PIPpGfiNI
	 OwYNl14n/Gjhb5fdM7u2TeJrOspUoi35p98pyBXYrRNtSWU+E3cKmIk/r6GpXcBd1a94v
	 2ZyfbdbKuXmk361QCFlmTTwPTc6PjNhFiG/X+MGkri0JOZeoM2oQKxezS3pJAXh/CgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e51Wd5f3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA79606A31C;
	Thu, 26 Nov 2026 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e51Wd5f3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5211F000C6;
	Thu, 26 Nov 2026 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704297;
	bh=nivPiwwKFerUVCAw/MkYLS69wh9NcdxWgcH8pbKwcHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e51Wd5f36Hn238mh9Pd0jp4FswzdOK5gq4lS0wHdSbWiZVycw265TI1zTzgWu4Oxx
	 NECVVmV8zFILGVIJGB5IjlyV1baxsabsmluvZf2TO4eCCPFf6OCJOacoYwqKSWXLFe
	 fKRw7FY6y9QPhoSN1hDgx3EhYNiT934wnRldbBIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
	Anirudh Rayabharam <mail@anirudhrb.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/265] vhost: fix hung thread due to erroneous iotlb entries
Date: Thu, 26 Nov 2026 15:36:17 +0100
Message-ID: <20261126143608.379003266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]

In vhost_iotlb_add_range_ctx(), range size can overflow to 0 when
start is 0 and last is ULONG_MAX. One instance where it can happen
is when userspace sends an IOTLB message with iova=size=uaddr=0
(vhost_process_iotlb_msg). So, an entry with size = 0, start = 0,
last = ULONG_MAX ends up in the iotlb. Next time a packet is sent,
iotlb_access_ok() loops indefinitely due to that erroneous entry.

	Call Trace:
	 <TASK>
	 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
	 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
	 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
	 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
	 kthread+0x2e9/0x3a0 kernel/kthread.c:377
	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
	 </TASK>

Reported by syzbot at:
	https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87

To fix this, do two things:

1. Return -EINVAL in vhost_chr_write_iter() when userspace asks to map
   a range with size 0.
2. Fix vhost_iotlb_add_range_ctx() to handle the range [0, ULONG_MAX]
   by splitting it into two entries.

Fixes: 0bbe30668d89e ("vhost: factor out IOTLB")
Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20220305095525.5145-1-mail@anirudhrb.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: b179f21d2d8a ("vhost: reject invalid IOTLB update permissions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/iotlb.c | 11 +++++++++++
 drivers/vhost/vhost.c |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 5c99e1112cbb7..e262d7366c398 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -57,6 +57,17 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 	if (last < start)
 		return -EFAULT;
 
+	/* If the range being mapped is [0, ULONG_MAX], split it into two entries
+	 * otherwise its size would overflow u64.
+	 */
+	if (start == 0 && last == ULONG_MAX) {
+		u64 mid = last / 2;
+
+		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
+		addr += mid + 1;
+		start = mid + 1;
+	}
+
 	if (iotlb->limit &&
 	    iotlb->nmaps == iotlb->limit &&
 	    iotlb->flags & VHOST_IOTLB_FLAG_RETIRE) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 4b667cfbdc498..9e9455054ce6d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1171,6 +1171,11 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
+	if (msg.size == 0) {
+		ret = -EINVAL;
+		goto done;
+	}
+
 	if (dev->msg_handler)
 		ret = dev->msg_handler(dev, &msg);
 	else
-- 
2.53.0



