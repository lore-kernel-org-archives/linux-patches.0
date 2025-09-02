Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408F231A569;
	Tue,  2 Sep 2025 13:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819500; cv=none; b=BLet5YHB6q+yN5L+HcwkIhd5CpcrH3RRKyBcejtVJFVBwfc7Ki7mNyD7m5nL7Uy3exqRCgyokqVAaX2NgYZIrm1Nf+FSRjMDdFYp+BM5WLJmg7iDqeIZrXVFbq9gf6oM/YrsacJ4j5MkEPDbfdq5z10rzyrBeHcxkeOxXhF/l2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819500; c=relaxed/simple;
	bh=YPuvZDvMY7VG4J4NM0F94cjHtHW27TMPdIOF0rsSNJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVmChNEKbSb8vaSUPDCx8RSSVKoJiw78K21zZmvssVWNElAHdgb8Smel/9NXwVzAVWhZgWytMXRuY/xPoDt6AM3R5rSYxoia6BzTi3UToZCctWZQcQ9aMSpC40qbWtb5MYWZ+wTVfaH9aWPnV40Y5VAw4PuUbELgtaQoYmBD7Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psroHZNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psroHZNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C65C4CEF5;
	Tue,  2 Sep 2025 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819499;
	bh=YPuvZDvMY7VG4J4NM0F94cjHtHW27TMPdIOF0rsSNJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psroHZNyFtV99FS8JQlO797KWqEfcj4/oqDdMV5Jo8N1KP6b/jQ4V3TnZ5r/QMiu1
	 VyX4jVDa6eIHKmY3iJoj5CDIB6ZgZVnc6W7VK3rYiWMKyIufQGQNuN+dy4ZL1hmtAP
	 Ep1Ewl9Rz8UYa1Su60u4XXcWIivR1Yap6hFMaBqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	skhawaja@google.com,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 052/142] page_pool: fix incorrect mp_ops error handling
Date: Tue,  2 Sep 2025 15:19:14 +0200
Message-ID: <20250902131950.248891501@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit abadf0ff63be488dc502ecfc9f622929a21b7117 ]

Minor fix to the memory provider error handling, we should be jumping to
free_ptr_ring in this error case rather than returning directly.

Found by code-inspection.

Cc: skhawaja@google.com

Fixes: b400f4b87430 ("page_pool: Set `dma_sync` to false for devmem memory provider")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Link: https://patch.msgid.link/20250821030349.705244-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 368412baad264..e14d743554ec1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -287,8 +287,10 @@ static int page_pool_init(struct page_pool *pool,
 	}
 
 	if (pool->mp_ops) {
-		if (!pool->dma_map || !pool->dma_sync)
-			return -EOPNOTSUPP;
+		if (!pool->dma_map || !pool->dma_sync) {
+			err = -EOPNOTSUPP;
+			goto free_ptr_ring;
+		}
 
 		if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops))) {
 			err = -EFAULT;
-- 
2.50.1



