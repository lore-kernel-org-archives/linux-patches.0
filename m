Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993252E7398;
	Sat, 30 May 2026 18:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167028; cv=none; b=q6dLA+t6YLtmQPxWW6NU3BAu49EifgbuZkGnhpZVS2wzNe77T8tOjg8lyd/qPvaS8IKRnT7qBevuJ1UOQERQ43q1wRM8BIIwVCT4KEOn8qLWYVvcgnPG66ltvPhezvSUGB1ksACVgvAjAwUrfAOugVm6SsABn3sT020k8TWG2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167028; c=relaxed/simple;
	bh=4xbLBABrI3JWyw1MZ3QbWPSvtrzwwCBU+uus+rnWhx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGs3HdTOxwH8+lwQZXlY+XDxtkd04V8S4D0pZ74RaGt2MpyGyLSG2mTiSNfKSwvV3ZJfZ2mNzwcbEFHF19/OoWAgEzkNXWY70NftpeA4zwp2TBGf9ZfFeFGcUO7tFF8zvcsJhvo8DcWkpPMuxq3Q6XXE8vE1MuY4lCZuyfxsBb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYL6af1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYL6af1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD2A1F00893;
	Sat, 30 May 2026 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167027;
	bh=3b1Mm1ty3LKZ44IrDHH/lih2ZXCAxRwprtJKajbHOnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYL6af1kHgJykagr14c8ZJRaWVVFVZJmriSF9dJLRBJRVUmGm3j5am2APl/QGU6n6
	 i6hC/3fizV3UGeJYW6tloRf6p9IOV1hFzwnl0ls3yav/3+HX4s8bY+svQz3cuKbDrE
	 oJ06DOSgIZg84CTYuQJrSvaqUg9nFPCAnPYYVgAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 513/589] libceph: Fix potential null-ptr-deref in decode_choose_args()
Date: Sat, 30 May 2026 18:06:34 +0200
Message-ID: <20260530160238.118481370@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 28b0a2ab8c82d0bbdeb8013029c67c978ce6e4bf upstream.

A message of type CEPH_MSG_OSD_MAP contains an OSD map that itself
contains a CRUSH map. When decoding this CRUSH map in crush_decode(), an
array of max_buckets CRUSH buckets is decoded, where some indices may
not refer to actual buckets and are therefore set to NULL. The received
CRUSH map may optionally contain choose_args that get decoded in
decode_choose_args(). When decoding a crush_choose_arg_map, a series of
choose_args for different buckets is decoded, with the bucket_index
being read from the incoming message. It is only checked that the bucket
index does not exceed max_buckets, but not that it doesn't point to an
index with a NULL bucket. If a (potentially corrupted) message contains
a crush_choose_arg_map including such a bucket_index, a null pointer
dereference may occur in the subsequent processing when attempting to
access the bucket with the given index.

This patch fixes the issue by extending the affected check. Now, it is
only attempted to access the bucket if it is not NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -374,7 +374,8 @@ static int decode_choose_args(void **p,
 				goto fail;
 
 			if (arg->ids_size &&
-			    arg->ids_size != c->buckets[bucket_index]->size)
+			    (!c->buckets[bucket_index] ||
+			     arg->ids_size != c->buckets[bucket_index]->size))
 				goto e_inval;
 		}
 


