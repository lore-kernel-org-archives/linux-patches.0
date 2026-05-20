Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600683F8706;
	Wed, 20 May 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301661; cv=none; b=ri/taKz0BHhnxmK8b2v7GOAGHOMXAiPM+SKqxFRj/sui8hvczrX5HjTWIgr/gO8yGpwIIf52HA4iyyD3vNSDZRWM6hdcU9/eL+yLQF50sjxD+xUdrZm8FMfo48wFMqzJB6KvrB7lWH5ThFCuza9t2QB65U+0f0rqUQZiJur6MHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301661; c=relaxed/simple;
	bh=j5WMzmscTHDfVqTaMJKGnNMyA/fgOeGEkCU19M3Cpj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoWG/BQGt6W0uLTSFAw6uspKgiHdOnY5HB6IiKv0GcJQRV15Grvmd84VgkGONnNTtVnpiZvbRup/QCBb4MeMLaLLkROPbrdsxbhpHPoqxcpZkNMix23YGf4mdm9Asvs59L1AxeqZRjBxUxWWm5sSfyxUAoDiJAeeJA2QRKur/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soZuZARC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soZuZARC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821711F000E9;
	Wed, 20 May 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301660;
	bh=JQMySFDA3z6+uZAIiAbqb/ZfNO02P/iEAQhaGE5sDek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soZuZARCgpYk0aHS10r4ysc+igC9DuwjdRiPX24DyqTyKAyhfvdC6fon6lKNYt7Nz
	 SgYECSBO0B3rx20eb8YXXUuARs5tqcxp4iLPoxa0H01klZasFgsNSF6XczLzPB8ft8
	 l8iJnBp1Zxhq249gJ3OEB+22kvFBJh63OSuDLd5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 638/666] libceph: Fix potential out-of-bounds access in crush_decode()
Date: Wed, 20 May 2026 18:24:09 +0200
Message-ID: <20260520162125.104652558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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


