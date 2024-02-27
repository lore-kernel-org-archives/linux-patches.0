Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C4B78B61;
	Tue, 27 Feb 2024 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041986; cv=none; b=d3Tp+8wkBmdB94XJoagBrzGACAGdvKMds/WQltH2l13x4p44qs63Pt8oOrwyhsrhN/zzHSn/w5tplmgImorEX1v/Kzu8o+1Nkew5o2yyt8l7WQswpmmrLRBKImhNZUC6ITaE2FSWEnjNtKKESY8I39ifNrzlt34YQdoqYcwq5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041986; c=relaxed/simple;
	bh=CP4O3SR7g26tSZZ2ZCohLjOkCqPz/SmR7XK1e5g34kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+nqLzW6HEgS3woYOj8eCLqunzj6R7SLaNKjDnJtT8UBh1nWY4/gCBSX4Tn2UDYwb8Czy6Z2AUYNwiNHaohHe6uH7g8tSocStw7g9crQ0cY9n061Ds8933HQ01gDAjARX1G6he6Rc5akhu+YjN1UjxcVghbFUfgW4wsX+C37Ijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOfwVg4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOfwVg4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2395FC433F1;
	Tue, 27 Feb 2024 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041986;
	bh=CP4O3SR7g26tSZZ2ZCohLjOkCqPz/SmR7XK1e5g34kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOfwVg4DtZxj9kr5XnzrsF5LaEdJoHDvFScIJzM2jsLcjn1V0QvTjX8rvq0UpjooR
	 Ymyy1ciOCKcu99obvfNirYCO0A9HNMoyr7vZ6PzWXJ4HjaghW4KQgNb54ORK01Icsv
	 7u4x1+Zkhvij8oICJZY3ikGr5Pb9J55WKOB0FlA0=
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
Subject: [PATCH 6.6 140/299] drm/ttm: Fix an invalid freeing on already freed page in error path
Date: Tue, 27 Feb 2024 14:24:11 +0100
Message-ID: <20240227131630.361371422@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,7 +384,7 @@ static void ttm_pool_free_range(struct t
 				enum ttm_caching caching,
 				pgoff_t start_page, pgoff_t end_page)
 {
-	struct page **pages = tt->pages;
+	struct page **pages = &tt->pages[start_page];
 	unsigned int order;
 	pgoff_t i, nr;
 


