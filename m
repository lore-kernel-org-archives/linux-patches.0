Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCECC386C1C;
	Tue, 21 Jul 2026 20:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666009; cv=none; b=D6PV/RliNP9v+ElR5w0RGeK40VAoQHnvvHvEsdwnDYhim+nPght+WuoWYcb1d8oxpMi+OjBH9M3XcTTnkp8b6hzloswsjoVmGkIXb8uZYJ+BJPu5av4VVyp9m/FHJm4vPCvK5rpUPXwTcPSrfaEeo6NNp2Wke3Y0crWRgRyMuoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666009; c=relaxed/simple;
	bh=kWcP8b8vtd2+Ik8CZzBvAie+0UWeGpX/cj2TMDYvo/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAihcv627MEMAkN5Dr6I55Xh1rfscr8XvXRX+Y9t1Q1wRcwvUFxKcMcyVlXkFg5akm1SG7QUHeu3u6bDz1ETXnPPQzs8fr9/Q7bfSMrdpC2WkJLS3W6Vd2bnut+BewRqDz7YkgxbsfCqHOb6wNCwgrHIIEHi4FZtbu5IbH2nYYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZh9dNi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZh9dNi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1B01F000E9;
	Tue, 21 Jul 2026 20:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666008;
	bh=zvHI0mBhv4Z1t+2ZPkZ1oXFNFPoKAyt4+HwZdus8ANI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZh9dNi0EcI80cie+m9VugS0xsaAXwDFA5S2+7iresVWgJ2yUjVZZx3Ke31v8bsR1
	 iLMdcTFXu1WZtYbNGGaGVgAzox9N9YESN7FlsQSkyBmwTQN9h6H2qwrLAkQMvNY1Sj
	 Zvj8bcK7r/VSxZGCU5CFBZJIfPjZSUU5ncE0rmuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Dev Jain <dev.jain@arm.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0521/1266] vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Tue, 21 Jul 2026 17:15:58 +0200
Message-ID: <20260721152453.511845624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Hui Zhu <zhuhui@kylinos.cn>

[ Upstream commit c55dd3b46c1208d6d2ea737a8aefef4aa4c70cb8 ]

find_vm_area() can return NULL if the given address is not a valid vmalloc
area.  Check the return value before dereferencing it to avoid a kernel
crash.

Link: https://lore.kernel.org/20260529014130.671291-1-hui.zhu@linux.dev
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmalloc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 897f2109f6ada8..5a6ef0ae032a7f 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -209,7 +209,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
 	 * allocated in the vmalloc layer.
 	 */
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
-	return find_vm_area(addr)->page_order > 0;
+	struct vm_struct *area = find_vm_area(addr);
+
+	return area && area->page_order > 0;
 #else
 	return false;
 #endif
-- 
2.53.0



