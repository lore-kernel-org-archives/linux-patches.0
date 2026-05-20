Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F865407579;
	Wed, 20 May 2026 18:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302997; cv=none; b=U0OOW6Dym2K5jQjx3g+9hfy7hceGNlSHUIHHV3VOYLRa7Sx/eiMNlS2YRysRfVL+8CiPgo1Ij5+K7jYv3R0JqT/8SWwdk3hnqAoveR7QJ+4rIISQSGRAX4ht1dQg6VNcoVHEhqZR4rwi1ZM1uizIMrt3fscaGhpWRJy3KAQNaFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302997; c=relaxed/simple;
	bh=FTytzraHbsBb7vjqCRStSrNitNowHh+pjmTb7febIY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVaezP9U2EL39e2AItMrLoD5IHxhdbNbJscaw+nKl1jO//6j2rSdQNfuMjtPaIQhYnfjnlFw1g6MfUPJ//zA2d+q+odpksoDtPreiwzqmBXY8wuEaMYILjbPqDkwVQId9sWwQFn50x9VR9oClqKe9JM9a/IJ0L66hN4Pmol8sz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR83aEIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR83aEIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA95D1F000E9;
	Wed, 20 May 2026 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302993;
	bh=qyQoUxRCI7M4zYZSXK7HwvqQ1I0m6W0MOuQAopiK8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QR83aEITttHI5d5gEakKo1FhNgV+KwkDIgSeKKrfApLQb5wGddxNa2s3fYEK+QLYD
	 ijity7Q8Bhm3+BTfL+M0PYKs7dy2/+XAkG9oOpIdxGvt9Gg+/Vvlx+4s6A4srwmLuW
	 vJU/sH/z1W3yw36A7I7tQ81xjJC2pgTB7tRAEN0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 476/508] libceph: Fix potential out-of-bounds access in crush_decode()
Date: Wed, 20 May 2026 18:24:59 +0200
Message-ID: <20260520162108.908065814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 4c79fc2d598694bda845b46229c9d48b65042970 upstream.

A message of type CEPH_MSG_OSD_MAP containing a crush map with at least
one bucket has two fields holding the bucket algorithm. If the values
in these two fields differ, an out-of-bounds access can occur. This is
the case because the first algorithm field (alg) is used to allocate
the correct amount of memory for a bucket of this type, while the second
algorithm field inside the bucket (b->alg) is used in the subsequent
processing.

This patch fixes the issue by adding a check that compares alg and
b->alg and aborts the processing in case they differ. Furthermore,
b->alg is set to 0 in this case, because the destruction of the crush
map also uses this field to determine the bucket type, which can again
result in an out-of-bounds access when trying to free the memory pointed
to by the fields of the bucket. To correctly free the memory allocated
for the bucket in such a case, the corresponding call to kfree is moved
from the algorithm-specific crush_destroy_bucket functions to the
generic crush_destroy_bucket().

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/crush/crush.c |    6 +-----
 net/ceph/osdmap.c      |    4 ++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/ceph/crush/crush.c
+++ b/net/ceph/crush/crush.c
@@ -47,7 +47,6 @@ int crush_get_bucket_item_weight(const s
 void crush_destroy_bucket_uniform(struct crush_bucket_uniform *b)
 {
 	kfree(b->h.items);
-	kfree(b);
 }
 
 void crush_destroy_bucket_list(struct crush_bucket_list *b)
@@ -55,14 +54,12 @@ void crush_destroy_bucket_list(struct cr
 	kfree(b->item_weights);
 	kfree(b->sum_weights);
 	kfree(b->h.items);
-	kfree(b);
 }
 
 void crush_destroy_bucket_tree(struct crush_bucket_tree *b)
 {
 	kfree(b->h.items);
 	kfree(b->node_weights);
-	kfree(b);
 }
 
 void crush_destroy_bucket_straw(struct crush_bucket_straw *b)
@@ -70,14 +67,12 @@ void crush_destroy_bucket_straw(struct c
 	kfree(b->straws);
 	kfree(b->item_weights);
 	kfree(b->h.items);
-	kfree(b);
 }
 
 void crush_destroy_bucket_straw2(struct crush_bucket_straw2 *b)
 {
 	kfree(b->item_weights);
 	kfree(b->h.items);
-	kfree(b);
 }
 
 void crush_destroy_bucket(struct crush_bucket *b)
@@ -99,6 +94,7 @@ void crush_destroy_bucket(struct crush_b
 		crush_destroy_bucket_straw2((struct crush_bucket_straw2 *)b);
 		break;
 	}
+	kfree(b);
 }
 
 /**
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -518,6 +518,10 @@ static struct crush_map *crush_decode(vo
 		b->id = ceph_decode_32(p);
 		b->type = ceph_decode_16(p);
 		b->alg = ceph_decode_8(p);
+		if (b->alg != alg) {
+			b->alg = 0;
+			goto bad;
+		}
 		b->hash = ceph_decode_8(p);
 		b->weight = ceph_decode_32(p);
 		b->size = ceph_decode_32(p);


