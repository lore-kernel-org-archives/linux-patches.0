Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08E81E534;
	Tue, 27 Feb 2024 13:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040922; cv=none; b=OHO/2Sqq1XXaLOgLdzy7ZJoqyf1zD0JI3x+ICRwVkHwCizEh6Tr9I+w0oEW1XhBdX1vQxRty9LkcuDoJzmLfn4OTbLmmkspPCPyBMm2zVaI3h+rwCbfYP4my47tq0wDvIvFfKr16q+3u/qHSDlNA7eZxEtLYxg8QPhD2xLJlh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040922; c=relaxed/simple;
	bh=AGKNVRvHuSC01turs7w63LGWQTUOaj7vqNBmFf9NS3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gkwga84EQxck4FSGUe9PqQ67zrHWhRMiJM5OlEigFPRx5s2eDH0LOEQ9H3nEQU17AYFOX8i2pZ2JoYI217by85oe5v6cKeeK1WcZP6N+2Y3ol6F2+ASAOcI+57CP/3PMae3N67E7drwzpCRiH0/9oaG6uCKxWFEMLoLjiKgzjTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcHnRFxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcHnRFxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F56EC433C7;
	Tue, 27 Feb 2024 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040922;
	bh=AGKNVRvHuSC01turs7w63LGWQTUOaj7vqNBmFf9NS3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcHnRFxYyk0OHbmwdXSdBm9QvldLgV/2X+6KIUziZw2BazgZemqo1aRqvmuvVe73/
	 mIY4PSmRg1XJU/aylcC+uQ8awumOEmGlnpiVdZ0prp8sNxZ0zYMFulE3/QQ81WkTnT
	 i+COi3tuNLbhe0Db5Tbct3rwPU1MVLw/U7qqRRgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Huang Rui <ray.huang@amd.com>,
	dri-devel@lists.freedesktop.org,
	Matthew Auld <matthew.auld@intel.com>
Subject: [PATCH 6.7 148/334] drm/ttm: Fix an invalid freeing on already freed page in error path
Date: Tue, 27 Feb 2024 14:20:06 +0100
Message-ID: <20240227131635.229615976@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 40510a941d27d405a82dc3320823d875f94625df upstream.

If caching mode change fails due to, for example, OOM we
free the allocated pages in a two-step process. First the pages
for which the caching change has already succeeded. Secondly
the pages for which a caching change did not succeed.

However the second step was incorrectly freeing the pages already
freed in the first step.

Fix.

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 379989e7cbdc ("drm/ttm/pool: Fix ttm_pool_alloc error path")
Cc: Christian König <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.4+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240221073324.3303-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -387,7 +387,7 @@ static void ttm_pool_free_range(struct t
 				enum ttm_caching caching,
 				pgoff_t start_page, pgoff_t end_page)
 {
-	struct page **pages = tt->pages;
+	struct page **pages = &tt->pages[start_page];
 	unsigned int order;
 	pgoff_t i, nr;
 


