Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591089;
	b=JwDGLR9TNpwUKam6knLQiOtkGR6AnzjoklTZkp/TRcCoblhDaQtwt4kgfL2aTSlsWuYx
	 xKg1onIvHRuYmZDHfGA+lLGJ0N+L3KWsEPAm/W1WT/e/M3stLOCC3gRu6GIMt/m5QGnHA
	 1iAEvn1Kmser8tUHYUliW2tP745W107sU+bVCodfe5+sbHF5+nVaPQDhQ6+yna3CWAVkR
	 hPVDPIj+lHm5uztFCatmKT922KH2kvwY3cHbAsYTwOqKND7r0+C4F3Hrshnn0Fn6er69d
	 6DZJPpc3BbTsx2fKOamKV8uoAK+bPZwfH0/ZLz5KJp0V0FhoPW4yq4mO0Co153K5OjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZfkWcr0IMXEvTsrLeJLgtr/9l9B/K3Dy/1BL3BI71s=;
	b=kvbVTPdnfcXl1lRNsZVy/RYKu0Dc4tUeAxqQdW9zkwyKve0O9DaA1TfZnKMPQThXu2jB
	 OvU1EwE4eptSGtcpD/Gwwai/af9AujLapZ9QHhJSeBbclLyr1sXBysUFV18xBjj5etCEn
	 B1QorJgdvqGrO3T1jxWhJtWZghpsBKqDDv3N4miPOn+PKYwA333xefwgxmF2PQaZz/Pjl
	 fyagtkt2JQ3JQZVKpvS8Xq8G1ONPfRiqf8jBFYfVOBEjafnskBdhlOHoNSFeOu4wQmXIj
	 sfwURK5j9b4a5n3eXNaBPB/LeeNDucg3cljz2DUXhk/VdXpL4k8pGJ0tlPSaB1bXqjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+3i+6R1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92BF606B35A;
	Fri, 13 Nov 2026 17:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+3i+6R1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951911F000C4;
	Fri, 13 Nov 2026 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591088;
	bh=TZfkWcr0IMXEvTsrLeJLgtr/9l9B/K3Dy/1BL3BI71s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+3i+6R1TTv3YZ5BEEJk+zEE3jPhrQ7j+1DCkwB6YL1bYDHA3YVwLrASPOM/wF4E/
	 fkG7Z+8MTOV45y0GsLQgvgxpxt5blC6Wl7/yHeMytWAYIatlNLkytTVHXdKGiSGwpi
	 lSx7PE1vOPMtkI/90Wju82skDq7GTNcQqbZNGdzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/670] vringh: bound top-level re-entry into indirect tables
Date: Fri, 13 Nov 2026 10:46:45 -0500
Message-ID: <20261113153820.013511504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit f898439ace7f89922e853b43bcbfcd26ea2e0a98 ]

In __vringh_iov(), the F_INDIRECT branch descends into the indirect
table and continues before the descriptor accounting runs. A top-level
indirect descriptor is therefore never charged to count. If such a
descriptor sets NEXT to point back at itself, returning from the
indirect table resumes at the same top-level descriptor, which is again
not counted, so the walk never makes forward progress.

Because count stays flat and indirect_count is reset to 0 on every
return to the top-level table, neither bound in the loop check trips.
A guest can spin the vringh worker at 100% CPU inside __vringh_iov(),
an uninterruptible host DoS.

Move the descriptor accounting above the indirect switch so that a
top-level indirect descriptor is charged one top-level traversal step
before the walk descends into its table, bringing this re-entry under
the existing vrh->vring.num bound. Each top-level descriptor is still
charged at most one step and indirect_count still bounds a single
table, so legitimate chains (including the multiple-indirect case in
tools/virtio/vringh_test.c) stay within vring.num, while a cyclic
indirect descriptor is now rejected with -ELOOP.

Fixes: dbd29e075228 ("vringh: Fix loop descriptors check in the indirect cases")
Cc: Xie Yongji <xieyongji@bytedance.com>
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260922122955.69433-2-fangxy@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 781731eb95cfe..07dafd10ef8b6 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -334,6 +334,17 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		if (unlikely(err))
 			goto fail;
 
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
+			vringh_bad("Descriptor loop in %p", descs);
+			err = -ELOOP;
+			goto fail;
+		}
+
 		if (unlikely(desc.flags &
 			     cpu_to_vringh16(vrh, VRING_DESC_F_INDIRECT))) {
 			u64 a = vringh64_to_cpu(vrh, desc.addr);
@@ -359,17 +370,6 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (up_next == -1)
-			count++;
-		else
-			indirect_count++;
-
-		if (count > vrh->vring.num || indirect_count > desc_max) {
-			vringh_bad("Descriptor loop in %p", descs);
-			err = -ELOOP;
-			goto fail;
-		}
-
 		if (desc.flags & cpu_to_vringh16(vrh, VRING_DESC_F_WRITE))
 			iov = wiov;
 		else {
-- 
2.53.0



