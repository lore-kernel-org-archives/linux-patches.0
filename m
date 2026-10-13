Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8924FB9BB;
	Tue, 13 Oct 2026 12:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893289; cv=none; b=iMciqSjXsgaT5ZfZE3R+Wbrwv01mV1qdFbfdf2Yk/yHVigxdPG1JummPr5AkTth2vAKSB2OA0OYoaYmH6UuQAaxoOf8pnzTOkapezjV553o/gsep0o3Nf7rZJ3WAKOigwBpGLQqTtVF8ttSLw2BpwxxR5LY6/Zeu+Om+YYlmJvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893289; c=relaxed/simple;
	bh=QjEIe4KlSAKyttdgA2i0KxB7sTup8g9KDeTUUk0ScXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRxiv/2B9B09qm07+HSvPLG0HgUXx3QSUJf1c1l5tI1sKo+nbW1yqtwtrL/p0t6Kn9u6T8xmB15BlcrTlD7JSOnlHkXtycDR1fZugRGqfAjtOIrhmRvs7KsmKaWGYT9F7QLZ1ejVoTmZRgIPO2h1j9tOjRkxM+vBo83S9EWz0yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUhApReY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUhApReY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61FF1F000FF;
	Tue, 13 Oct 2026 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893288;
	bh=YSLxG7D2qWO+1v5+sO+e7leo8yIqfIiO3Xwp5Rnuyes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUhApReYykP2N7mYGzaBnz+Fv/wRs1xelsdL4+X5Ko3fzvb7k3aT5/+Sz6LdoqrjN
	 2Qpo+dxB0ujR6owZACi/E5zKFLhbDNryQZlILvTaUXnnYWWwJzDPY8YWSRbL5m8gYW
	 5tenLGl6+VCEFkS+Q1KkT64bd1MK+87iw2O0GlCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/621] mshv: Fix error handling in mshv_region_pin
Date: Tue, 13 Oct 2026 13:32:51 +0200
Message-ID: <20261013112925.039207659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 35b866670840e..5372b7ec1871a 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -130,7 +130,7 @@ int mshv_region_pin(struct mshv_mem_region *region)
 		ret = pin_user_pages_fast(userspace_addr, nr_pages,
 					  FOLL_WRITE | FOLL_LONGTERM,
 					  pages);
-		if (ret < 0)
+		if (ret != nr_pages)
 			goto release_pages;
 	}
 
@@ -140,8 +140,10 @@ int mshv_region_pin(struct mshv_mem_region *region)
 	return 0;
 
 release_pages:
+	if (ret > 0)
+		done_count += ret;
 	mshv_region_invalidate_pages(region, 0, done_count);
-	return ret;
+	return ret < 0 ? ret : -ENOMEM;
 }
 
 void mshv_region_destroy(struct mshv_mem_region *region)
-- 
2.53.0



