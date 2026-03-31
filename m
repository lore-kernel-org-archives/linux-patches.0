Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475AF1C861A;
	Tue, 31 Mar 2026 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974716; cv=none; b=PeF7FI/E+p0uxHkDQZpFwfl/xvi54SaIvJGRraLdFL2GyULKr64joG3KOuiWXoUd8M5qiZF55gqKC6L4S7sMR4XentLNub12DyGjOOSmFeVN5CQRScr13ok3e+LdmYhnt3IJkoo7ea1V8/f3eeGHMwYKA+DSLL963o2wMZHtdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974716; c=relaxed/simple;
	bh=u6hxHSX6DgnsHt6BSru8T3Ll/EmdURINw3/xUTfoVpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuTH3Y8MuKygX5SA38Vj8IAtKPOb5XHg2qL9Kx365iVsN2ZTB4WXEQOLH38Z5uTKaPqE+mWz7h12gKsagFd/iGqw9VV+2FdUe6S2fCVGEFQK63c/LuAj5CqoFNCgxOq/bd+lqvUMugTvPVIfpHuAU9boAwaTNBMOmcP4sxFSmsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Szmc1Zk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Szmc1Zk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1413C19423;
	Tue, 31 Mar 2026 16:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974716;
	bh=u6hxHSX6DgnsHt6BSru8T3Ll/EmdURINw3/xUTfoVpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Szmc1Zk+aGbs/egVJ6rPs9s3x2SWwgvZVOgp6B7KyGc8xwac87ZNwksTWtkV5UjnU
	 3Speb27i/h2DowfkIGOiWPEapt1oMkFrNcawh4Q8NB4anVp+VfZz13qJbkNnOQgdrT
	 qKhE7eaYguQkCBXFYYujU9oGXVlKMLRZe/tkGkAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 002/342] cxl/region: Fix leakage in __construct_region()
Date: Tue, 31 Mar 2026 18:17:15 +0200
Message-ID: <20260331161759.003186609@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 77b310bb7b5ff8c017524df83292e0242ba89791 ]

Failing the first sysfs_update_group() needs to explicitly
kfree the resource as it is too early for cxl_region_iomem_release()
to do so.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Fixes: d6602e25819d (cxl/region: Add support to indicate region has extended linear cache)
Link: https://patch.msgid.link/20260202191330.245608-1-dave@stgolabs.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 5bd1213737fa2..a3d06b852d05e 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3616,8 +3616,10 @@ static int __construct_region(struct cxl_region *cxlr,
 	}
 
 	rc = sysfs_update_group(&cxlr->dev.kobj, &cxl_region_group);
-	if (rc)
+	if (rc) {
+		kfree(res);
 		return rc;
+	}
 
 	rc = insert_resource(cxlrd->res, res);
 	if (rc) {
-- 
2.51.0



