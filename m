Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953A543B490;
	Tue, 21 Jul 2026 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671636; cv=none; b=nml4aParInvIH2Bi3bvu4OFror2kbx2h/2ej3f46OCgeO9udsA+le6Sk+oHmz0S5cntI4d1TKMHQtyUILhpgWf6uMzgur++qIhQFMAG5u7QotBa2V/tyjKFR/kskxRHogKkP1AHR2woBI9e9mn6EE7HBfUtTrRe3QFk79EhUj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671636; c=relaxed/simple;
	bh=vd+bXtWQsw92cM0fjtPnvlhpZD3eOZk/DMX8AfcQjiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jajArQ4qaZMc/PhLpMD+iE+6cParkcPbMpZF0FZBI5L4x6XNVe8YfNpFCVE4VVub/r6DddCGxggf7qywWXoAa1LUA6ycHCMe3x7HdG1KKdS6LkrJjQaLxykkW2mXkLVWabgtFOxiZzRYjW72iPB+6bHlC2PB8FEm4GAQPXLkDCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZA1Rduvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZA1Rduvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1021F000E9;
	Tue, 21 Jul 2026 22:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671635;
	bh=U1bPBcv45DkdcU8DsHoIQ2r6O7cNUyaNz60Bh8Rg3D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZA1Rduvt7Ag8t9O2uZkP2eSRazGVcDT1iXXSOfX1rAYS3URrU3+9ayWvpW8DNGbs3
	 Avi8DwbBaj8//O8H7KQA24At7SinOPYVIFmpSc3trSeKbuhbfSi1LLJcorvBNsRH4G
	 6HLK5PASatxGMIM2uQG0+PTE0zNSM1v/3KNGDtx0=
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
Subject: [PATCH 5.15 322/843] vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Tue, 21 Jul 2026 17:19:17 +0200
Message-ID: <20260721152413.263994204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 9efcd95339c279..5fa4ffefb0394c 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -214,7 +214,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
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



