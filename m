Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26AC337B81;
	Wed,  8 Apr 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674257; cv=none; b=az8eod2fQOevTh0opogFnqPHhwda7RG+FbCiFIvLl6796WR88fPcrNBHExy3MBWixzm0JiJgmZehvhXVwa2813DZlSB14/flIom7lW7W9rgHJNseFUWbkFfHrrbUV9PhORltDhA368dXm79rfkaDsw94j8NmdzXbABKNd45/8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674257; c=relaxed/simple;
	bh=uDhN1L24SQ5dHx5TsrDIIg0gNryAy6uyR/mTgIhK9Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdLP3f6O2ohUlR8wHwvP6DvuR8xCb4lRGkjejDXGu68Dm23o0wUWQbSk+Ci0Hl/0b4ZVp1eHtfGkR2pUb5NkJP0dUIt872bMgMF6g5KG+6S0SyrbKH94DKRNXqoa2H8H56fIPP2csif/X0OR/JPOBDT8Lp74OVJKK9v4vElXUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM3/Dmcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM3/Dmcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9F8C19421;
	Wed,  8 Apr 2026 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674257;
	bh=uDhN1L24SQ5dHx5TsrDIIg0gNryAy6uyR/mTgIhK9Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM3/DmcuxPPAldU2i89cj2QJbstws+W68JbGBDxjeMUmsYATj+3tH4gVyyXC4Lf4+
	 FTiJgBthNocu76AMRhNvzlO/XuJzh0qEzy84u8mTfuwzhO7Jat4iheoS7BEY8p0b3K
	 qrIvK8PwjmH/4eJPg5MSQ2ldNgfBTjY9/APlS+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 027/311] mshv: Fix error handling in mshv_region_pin
Date: Wed,  8 Apr 2026 20:00:27 +0200
Message-ID: <20260408175940.426789107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit c0e296f257671ba10249630fe58026f29e4804d9 ]

The current error handling has two issues:

First, pin_user_pages_fast() can return a short pin count (less than
requested but greater than zero) when it cannot pin all requested pages.
This is treated as success, leading to partially pinned regions being
used, which causes memory corruption.

Second, when an error occurs mid-loop, already pinned pages from the
current batch are not properly accounted for before calling
mshv_region_invalidate_pages(), causing a page reference leak.

Treat short pins as errors and fix partial batch accounting before
cleanup.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_regions.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_regions.c b/drivers/hv/mshv_regions.c
index adba3564d9f1a..baa864cac375a 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -314,15 +314,17 @@ int mshv_region_pin(struct mshv_mem_region *region)
 		ret = pin_user_pages_fast(userspace_addr, nr_pages,
 					  FOLL_WRITE | FOLL_LONGTERM,
 					  pages);
-		if (ret < 0)
+		if (ret != nr_pages)
 			goto release_pages;
 	}
 
 	return 0;
 
 release_pages:
+	if (ret > 0)
+		done_count += ret;
 	mshv_region_invalidate_pages(region, 0, done_count);
-	return ret;
+	return ret < 0 ? ret : -ENOMEM;
 }
 
 static int mshv_region_chunk_unmap(struct mshv_mem_region *region,
-- 
2.53.0



