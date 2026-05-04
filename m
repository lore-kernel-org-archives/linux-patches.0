Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C111C68F;
	Mon,  4 May 2026 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904128; cv=none; b=C3GFxGoBNtdJtVB+8bgqrOAtsul6z8+H2/lMmxk8kOTInfTSoznu3hc+pIqGvg2+0LHSVFdT4Ar0bCHgj0qi84JErdfmv1NSaCkuNXlvuWN+myXMsHV59YY0EgXzzVSfaYxbcAvLzeFr2JvFMCWCyVPI0cZpA+8SYCDs64QTdYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904128; c=relaxed/simple;
	bh=rum3pUC+gv1GbwVpErrRNN/Jmqxfywsv2hX3pBuEA/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puhUfyDaAAhLwhEWGwb38mVKv6BwboOLzjeXMr1pwT/Y43yeeYjbefLdK2Jd8gkBc5Ds1odd9DVHc3O0EwyrGeFOnwAYOvRKQqQHE7fc73Iza1xgmx8Y1ealCEbeXuW/SiUDxV2Q4eSbtMzsYRqbNWVhsSTlTVcuRDgAqtmxRDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxhRf8C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxhRf8C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A158C2BCC4;
	Mon,  4 May 2026 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904128;
	bh=rum3pUC+gv1GbwVpErrRNN/Jmqxfywsv2hX3pBuEA/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxhRf8C7uMBpqBofkpP1HlRBHPnys9qC6Dvv5HVI4oAJmHJlV8BKq9wt2a9ISYV84
	 EtK5bKjqsSTXnCh9TglUYbGKWmtS40vOmozBT4xIsM5PNtTcJVsRUGo4Awu0t0D5Qw
	 YMbyW8lBtzF6ClaQdBn7sgmit59EE1E/eaRt3QwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	chenyichong <chenyichong@uniontech.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 161/275] mm/vmalloc: take vmap_purge_lock in shrinker
Date: Mon,  4 May 2026 15:51:41 +0200
Message-ID: <20260504135149.028306219@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

commit ec05f51f1e65bce95528543eb73fda56fd201d94 upstream.

decay_va_pool_node() can be invoked concurrently from two paths:
__purge_vmap_area_lazy() when pools are being purged, and the shrinker via
vmap_node_shrink_scan().

However, decay_va_pool_node() is not safe to run concurrently, and the
shrinker path currently lacks serialization, leading to races and possible
leaks.

Protect decay_va_pool_node() by taking vmap_purge_lock in the shrinker
path to ensure serialization with purge users.

Link: https://lore.kernel.org/20260413192646.14683-1-urezki@gmail.com
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5255,6 +5255,7 @@ vmap_node_shrink_scan(struct shrinker *s
 {
 	struct vmap_node *vn;
 
+	guard(mutex)(&vmap_purge_lock);
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 


