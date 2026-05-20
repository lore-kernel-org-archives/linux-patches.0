Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26440757A;
	Wed, 20 May 2026 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302992; cv=none; b=Op2cgVrPJliM+p7bBQq2VRFXJ2p6YteNgCSstlmVlvRQj5JiXQNkyDbJhRQMMzugplFs3FOOPkrZw6I9JZbmewQGgKFD0NUoy7QmUV0un1uWVcyOjaI5seuXcvhWLtC34enTXT0JfE/rlkyt7mpMSAAKF3n5As4HgIWcLNA7xWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302992; c=relaxed/simple;
	bh=v3nMcywEG/9HJb4zMQmFgGbB7/WQxw084/lRTQFCcv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZOUaYyrtMWdiQe3ieVeEdVY20p2OtibKDd7R1ZF5emWEHblbuhE5VtP1QBoxQStof+zHtQuy7D0yY1kckKf6DW3CAYK4yL/aql7FnWQIx2d/M/3mFHg4jqcz/hpluaMaJPG0Svkt5rAWbupCxE7XEK6/RGbca2rQKr9xX/Omks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWApOzhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWApOzhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD021F00893;
	Wed, 20 May 2026 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302990;
	bh=Z4MG35FcAWQUqDCw0yhKp0whL97+kVKUIGsESmFWatY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWApOzhiMuAlbjiiUDUcY5mLSQa41hySDGqblO+TpMOrc2e2/i5Rg+hxxLRvwndv/
	 cTciGgnT49PlGXTPI78EnGUBoDKVWuSwUUNRLh2eWW2Uh+yoNS3wUmAl6AR/afB4vz
	 XmZ8vL/4FEBw5hiA7P6EdCztBvw3YQGQwCr9GKps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 475/508] libceph: Fix potential null-ptr-deref in decode_choose_args()
Date: Wed, 20 May 2026 18:24:58 +0200
Message-ID: <20260520162108.886482458@linuxfoundation.org>
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
@@ -390,7 +390,8 @@ static int decode_choose_args(void **p,
 				goto fail;
 
 			if (arg->ids_size &&
-			    arg->ids_size != c->buckets[bucket_index]->size)
+			    (!c->buckets[bucket_index] ||
+			     arg->ids_size != c->buckets[bucket_index]->size))
 				goto e_inval;
 		}
 


