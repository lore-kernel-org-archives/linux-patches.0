Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B91330D23;
	Mon, 13 Apr 2026 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099597; cv=none; b=pdm+aqCm21u76R0j3Oy6oZXnO5rX0hP8LTwxQoLhyr5GGQ8dlnpG68qZgFUOqrSL0QfTEyJHOmaCupn4G4xrRHPiJ3zHvSN3D6NUQOJ+63FyQiXvgJo+seMBqwm9y+149+GyIzlq/xMGpa89220vSsKjRTQjd4WjRUOz1Aj9JdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099597; c=relaxed/simple;
	bh=d+RkbDvqWXElF9b3fHBb2FcvsdFLjA/W0jcnlBXvWRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgUMkJpe6VbdOH9YwdzEmvRL3jQJmagZu4HQ8uKye23JjvBJH6O51Qp0I4yxs3fE2lPD8EGHbN+sEMw+cRX+thVYvAFXMvTnQY57uz3tEPhtefhYWaAC3gF1t3p8m7Nn0TGeARoD7cIclPa9laf4IF6unA9BwU7Qtn5cejt4lMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq+EcfpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq+EcfpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740A6C2BCAF;
	Mon, 13 Apr 2026 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099596;
	bh=d+RkbDvqWXElF9b3fHBb2FcvsdFLjA/W0jcnlBXvWRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wq+EcfpYIfhcDqzry8JvqqN8CYrm9AG/QWpovk7U5JqIvap25T4kujrTS3ffGTkcy
	 nkII5T+PhCevU500qXDEQnkNeO3mA1BLq1qOCZSiTMS7b9HYXHUBkOL76i+U3yMNq9
	 rU99xmacypwuH7bve3ztF1apVR5Y8YO1w1n0S7Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 402/491] netfilter: ipset: drop logically empty buckets in mtype_del
Date: Mon, 13 Apr 2026 18:00:47 +0200
Message-ID: <20260413155834.081793120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Yifan Wu <yifanwucs@gmail.com>

commit 9862ef9ab0a116c6dca98842aab7de13a252ae02 upstream.

mtype_del() counts empty slots below n->pos in k, but it only drops the
bucket when both n->pos and k are zero. This misses buckets whose live
entries have all been removed while n->pos still points past deleted slots.

Treat a bucket as empty when all positions below n->pos are unused and
release it directly instead of shrinking it further.

Fixes: 8af1c6fbd923 ("netfilter: ipset: Fix forceadd evaluation path")
Cc: stable@vger.kernel.org
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1108,7 +1108,7 @@ mtype_del(struct ip_set *set, void *valu
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos == 0 && k == 0) {
+		if (k == n->pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);


