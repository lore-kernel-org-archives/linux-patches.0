Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0472E54BD;
	Tue,  8 Jul 2025 16:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993178; cv=none; b=VdAXBDYZ/gIACgPAjrXsi5UxbDLq0YxRH6YKFl7uv1srZ2vCd9sGlIY2UjVL4d6mCTRsxpDOEMmUbGFAyGOAYLHwbve2PwHUSK+YUSUhmNge6gkcUvIJMdjfy9r4R4xoZDWHUGwZ9bEPvvVyximHL4JCVnvBQxRuE9/VIin6rkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993178; c=relaxed/simple;
	bh=G5Y0TZrQBcrgox4+c9laS3JesX1/VTKD2WJoSsZVLtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQwLQm+AHHYGtRX1JtCe+jQNLc/Jhxo6VyhMVkZg0maKKO73/sdHMkEaIGlJt1V2WQqRcHSHKjPXR9OfDachY8FFyop6mplSVLePKFgooyADuMOo4w0zudVzM+9Q26Xj0gYr1CnYsEQsxt4AbM5q6WlylwukWtYrACvCITrf9z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8m3KfXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8m3KfXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A41C4CEED;
	Tue,  8 Jul 2025 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993178;
	bh=G5Y0TZrQBcrgox4+c9laS3JesX1/VTKD2WJoSsZVLtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8m3KfXhVVkPeg5PsBIzWZ5jyXagIcPmy7ifGFJ1Ju8KeoasmwQd84H2xHD8PFlx/
	 IFPrJSr1qUZN0oMWXPZmTQmIXluG95qRgBseFn+8Uw9aexwUmmwhq9pj4OR9lb808F
	 MsudZJYFV973Pn3CLe0msrXDP8A/VqLrZ8GOMl8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.12 214/232] dma-buf: fix timeout handling in dma_resv_wait_timeout v2
Date: Tue,  8 Jul 2025 18:23:30 +0200
Message-ID: <20250708162247.038140098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 2b95a7db6e0f75587bffddbb490399cbb87e4985 upstream.

Even the kerneldoc says that with a zero timeout the function should not
wait for anything, but still return 1 to indicate that the fences are
signaled now.

Unfortunately that isn't what was implemented, instead of only returning
1 we also waited for at least one jiffies.

Fix that by adjusting the handling to what the function is actually
documented to do.

v2: improve code readability

Reported-by: Marek Olšák <marek.olsak@amd.com>
Reported-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20250129105841.1806-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -685,11 +685,13 @@ long dma_resv_wait_timeout(struct dma_re
 	dma_resv_iter_begin(&cursor, obj, usage);
 	dma_resv_for_each_fence_unlocked(&cursor, fence) {
 
-		ret = dma_fence_wait_timeout(fence, intr, ret);
-		if (ret <= 0) {
-			dma_resv_iter_end(&cursor);
-			return ret;
-		}
+		ret = dma_fence_wait_timeout(fence, intr, timeout);
+		if (ret <= 0)
+			break;
+
+		/* Even for zero timeout the return value is 1 */
+		if (timeout)
+			timeout = ret;
 	}
 	dma_resv_iter_end(&cursor);
 


