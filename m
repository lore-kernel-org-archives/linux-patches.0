Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0F3D9029;
	Mon,  4 May 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903325; cv=none; b=QyKjFOJytLj6BErvQdu1BE0nHPASyIz6yyYvQyHIzLpITfa3w2iwcIeQ85geqt35UcCKlGObYuGYm/15A+L8wkjdAuN4v7Q0wUx6nelCKR94VRpZ5SzrBD03Ltdetd8wWz6JMYePUDkhSC205WXdnGyKgFKJhRZ8Cw2ptrKcP00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903325; c=relaxed/simple;
	bh=GZwBC9tK6SH5MUY/TDggBC3AVanLhKiZRacMSOC2p6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPHTec9haD31R++g755MvCGBfKm5YLUPPfy2MrrMdem87/GpeTY5ByryjYQCW1gCEy+PIUGlUxzsP5yGs1JbvWjXhTjzvtJuznUaFW+AI5FiBNa57fQZRO8fJDmmfjdGHItX6R/o8E31tc6QQlxRz4vvbX+ji/2LIxD1/YBSU/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt/9VzJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt/9VzJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66533C2BCB8;
	Mon,  4 May 2026 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903325;
	bh=GZwBC9tK6SH5MUY/TDggBC3AVanLhKiZRacMSOC2p6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kt/9VzJgvmmrOP+Le54VHjd0v96T1OiKrzJebbEEVVEb61uyz/qAfhxYvBaXmQAjN
	 JQrfdI+jokumRRmVYACEn8gb1NJTRyxuCLuhdCKSLAQV5AcGMkgAs0QDqJMaVizSI8
	 OcXvBYSCJrbi8Wv59wovbFwdrFjQ98UjbhVgslEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	chenyichong <chenyichong@uniontech.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 190/307] mm/vmalloc: take vmap_purge_lock in shrinker
Date: Mon,  4 May 2026 15:51:15 +0200
Message-ID: <20260504135150.030948040@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5416,6 +5416,7 @@ vmap_node_shrink_scan(struct shrinker *s
 {
 	struct vmap_node *vn;
 
+	guard(mutex)(&vmap_purge_lock);
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 


