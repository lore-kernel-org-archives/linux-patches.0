Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148DC3090F5;
	Mon, 13 Apr 2026 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098334; cv=none; b=pi5Rfb47fQ+BC6deZr1l/T7sZfPxIo2l/rMXivzRuiwqxH3DbH969qGJzi4pJF/HMCMGLD+w9/zKEeyXP8tbXTOGf17u0IhKg8tdoIQPRGgUKhzSQB/+ZhcY6q5L39EZxli102Ih6I7n5DoyYzHCSAGSKFP6uZ4IsBJ5LzjPr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098334; c=relaxed/simple;
	bh=ZT9L14WUXROiHApT8xFVSLSx9T95ZG3kQQpu7IuAwzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjAOQhjf2ikJeuf5WppqLM7XPydhBkm50/Dp0niVjx0db4satlgYTMrvDx4wzp4bxAB3UIcTpLBe89FlHPLbSpknYCNAGYYRn899H88aHncVza29GXqfVtPR1QXPkAZM08veOFFG/HOPFXTyf8GkhHML0Ej5FlQG2KvA28XpXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYTpykuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYTpykuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C242C2BCAF;
	Mon, 13 Apr 2026 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098334;
	bh=ZT9L14WUXROiHApT8xFVSLSx9T95ZG3kQQpu7IuAwzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYTpykuQbRKVplVchtqGQG3DbXA3ZJUAdZ2hwld6Q/mAXRcGPWHV3x+3r40xQST1G
	 jG9QuuU/uOdZOR1/sxUQ1vrzZvIKqnyo+v+f4+fUXK27krRr3uiIkQN26JkL5HX5dV
	 hZAr3lNlXEE3xwqla7GQuMQ1DbO4umE0pFEOf2R4=
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
Subject: [PATCH 5.15 485/570] netfilter: ipset: drop logically empty buckets in mtype_del
Date: Mon, 13 Apr 2026 18:00:16 +0200
Message-ID: <20260413155848.625804267@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1086,7 +1086,7 @@ mtype_del(struct ip_set *set, void *valu
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos == 0 && k == 0) {
+		if (k == n->pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);


