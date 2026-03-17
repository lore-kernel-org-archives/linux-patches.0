Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8063B3F787D;
	Tue, 17 Mar 2026 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766638; cv=none; b=SVWQSddO7iwNHmZhm9Fh5CLhvoGlfhy4epsX47fyrmzsgLitaJzpRMtwngpX2rGLah9JuN2aXa+K98piSTmCV8yq0cBs4n25E4NxZ8SuPoVQEWrufOBfoU6EZXc14nJJJYX+pLk/+nl9zMERCC9d8YA+8/yPDfeTX4lcc+5xLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766638; c=relaxed/simple;
	bh=+aSi36l/qgHBTfUJjn4Ul8bQEYbGe4XQ3zdfNZ+qJM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwLlbnBbgdOmLE4oHQ907ZdH2xyJoG0xNMGVrW2QSTb6vOGFhcKkJILGWoX7PFhHM+pA2RLFNIBpAeYhyFFrf86gaznihQ3ayfdKtFmBlnedTD4jZQaarn6i6mDDFMCB61AZT/iAybRbTap6xVIozyvc3ByAVaejyu3snVQ2Pto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMMEFo9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMMEFo9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF39C2BCB0;
	Tue, 17 Mar 2026 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766638;
	bh=+aSi36l/qgHBTfUJjn4Ul8bQEYbGe4XQ3zdfNZ+qJM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMMEFo9VwMQMkI163Rz7lwgS8r4KCCCL9oYJzY6bSjIDKx9LwF6d8mipg2+d+bnw4
	 JNaWafbcO5E62JOmijlJIeLg9ntZ6kC/ZG48WQEeGECpJoFS4FockiL/WdCMrmagId
	 RmX8un5S8vymQ9JMQLQoiHbPinG3j6DxKKHz0sKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Li <hao.li@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 289/378] memcg: fix slab accounting in refill_obj_stock() trylock path
Date: Tue, 17 Mar 2026 17:34:06 +0100
Message-ID: <20260317163017.644134495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Li <hao.li@linux.dev>

commit dccd5ee2625d50239510bcd73ed78559005e00a3 upstream.

In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should use
the real alloc/free bytes (i.e., nr_acct) for accounting, rather than
nr_bytes.

The user-visible impact is that the NR_SLAB_RECLAIMABLE_B and
NR_SLAB_UNRECLAIMABLE_B stats can end up being incorrect.

For example, if a user allocates a 6144-byte object, then before this
fix efill_obj_stock() calls mod_objcg_mlstate(..., nr_bytes=2048), even
though it should account for 6144 bytes (i.e., nr_acct).

When the user later frees the same object with kfree(),
refill_obj_stock() calls mod_objcg_mlstate(..., nr_bytes=6144).  This
ends up adding 6144 to the stats, but it should be applying -6144
(i.e., nr_acct) since the object is being freed.

Link: https://lkml.kernel.org/r/20260226115145.62903-1-hao.li@linux.dev
Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
Signed-off-by: Hao Li <hao.li@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3052,7 +3052,7 @@ static void refill_obj_stock(struct obj_
 
 	if (!local_trylock(&obj_stock.lock)) {
 		if (pgdat)
-			mod_objcg_mlstate(objcg, pgdat, idx, nr_bytes);
+			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);


