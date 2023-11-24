Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ED139FF8;
	Fri, 24 Nov 2023 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFugCLXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC8C433C9;
	Fri, 24 Nov 2023 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849693;
	bh=gFEd5XuvREQdXVHXglWNwYZQ8PIOBRaCmOrDbFoiKdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFugCLXlDsSHOY1MTaMz0hBZxJSnYNFa9hOX2vL/ryCRGWZ3IJVFauWE3hO79grMs
	 vghXDPBBkOBSYAB5c7AfyWhHUnH4moAmH2TCixjSAAaHKACkfkLaMt2/+h5oTSK/m/
	 XLOgthWewOztwdnf7DXe8eu/POeusLwCPctA/mFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 283/530] mm/damon/sysfs-schemes: handle tried region directory allocation failure
Date: Fri, 24 Nov 2023 17:47:29 +0000
Message-ID: <20231124172036.654127347@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: SeongJae Park <sj@kernel.org>

commit ae636ae2bbfd9279f5681dbf320d1da817e52b68 upstream.

DAMON sysfs interface's before_damos_apply callback
(damon_sysfs_before_damos_apply()), which creates the DAMOS tried regions
for each DAMOS action applied region, is not handling the allocation
failure for the sysfs directory data.  As a result, NULL pointer
derefeence is possible.  Fix it by handling the case.

Link: https://lkml.kernel.org/r/20231106233408.51159-4-sj@kernel.org
Fixes: f1d13cacabe1 ("mm/damon/sysfs: implement DAMOS tried regions update command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1752,6 +1752,8 @@ static int damon_sysfs_before_damos_appl
 		return 0;
 
 	region = damon_sysfs_scheme_region_alloc(r);
+	if (!region)
+		return 0;
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,


