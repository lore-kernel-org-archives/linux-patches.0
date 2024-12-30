Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0012F15E8B;
	Mon, 30 Dec 2024 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574391; cv=none; b=lgksX5ZiE5UvSOQACb9qG0/9HUliVYDYjrkb3qiSuYn2tqh25u1LjgM8N9LiCy4r2OBtVZMCrWIORPCANf/eW+n1XumonN69E2ZvMtnhF1Z8605iu0+1K1t43zBYfWcp8oh62j8O3AC4S9c1+xCffROOJdvk4thr81IOcR5iT6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574391; c=relaxed/simple;
	bh=B/DWdi+/JiSLJ6WoXOyc7jRkvQsO0rnoMbXgKjIBahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZih3HU/iomKCaR+/4j9MsuN48skOYNaa+G/NJC5W/upv9ppyq74H+x93qt99DVZIoQjLeSWafmKi2C5/ndLUO26mERDQuvKZmvE7cxQgfNYlsUBypYEXTfU85/pZApNS0cmlu3kfSKsf9R1UVtXgz0zGMUZZxBK0tHaWzyxpok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxnKakRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxnKakRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643F9C4CED0;
	Mon, 30 Dec 2024 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574390;
	bh=B/DWdi+/JiSLJ6WoXOyc7jRkvQsO0rnoMbXgKjIBahk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxnKakRX5BSjZxwTDewxbSitTvuln3DC9d+m6eptwF36nPIDkywv6x76WGdrHWcto
	 iEavWQaFGjeAPPcXsbYuXUVU6QMFG6X2V6HF9hRnbLUZZ+Iy/eOBkzeoAYO2rh6PKa
	 NCOs5lJgzhaxwM9TErkfORNO6KQxqMJoE1OZl/e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.12 091/114] virt: tdx-guest: Just leak decrypted memory on unrecoverable errors
Date: Mon, 30 Dec 2024 16:43:28 +0100
Message-ID: <20241230154221.602389517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Li RongQing <lirongqing@baidu.com>

commit 27834971f616c5e154423c578fa95e0444444ce1 upstream.

In CoCo VMs it is possible for the untrusted host to cause
set_memory_decrypted() to fail such that an error is returned
and the resulting memory is shared. Callers need to take care
to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional
or security issues.

Leak the decrypted memory when set_memory_decrypted() fails,
and don't need to print an error since set_memory_decrypted()
will call WARN_ONCE().

Fixes: f4738f56d1dc ("virt: tdx-guest: Add Quote generation support using TSM_REPORTS")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240619111801.25630-1-lirongqing%40baidu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/tdx-guest/tdx-guest.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -124,10 +124,8 @@ static void *alloc_quote_buf(void)
 	if (!addr)
 		return NULL;
 
-	if (set_memory_decrypted((unsigned long)addr, count)) {
-		free_pages_exact(addr, len);
+	if (set_memory_decrypted((unsigned long)addr, count))
 		return NULL;
-	}
 
 	return addr;
 }


