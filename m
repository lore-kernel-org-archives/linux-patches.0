Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF910237180;
	Tue, 21 Jul 2026 20:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665825; cv=none; b=m1vyxbZS8GOu8e41yzfTvKCuI8vdN5rIfOAY9dTas0pDjYx6Peif8hDOyb7DuiAUG9AiwIu8Le+XA79P/50G42LglngyP8YWWzT+VisPqQZj2Q+6dX46BWkNiykMRDxsaFzhINaFmmtMh5W4u7b4LN9gkLgEsXUbaJIMQYYDZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665825; c=relaxed/simple;
	bh=d/7pnUohAuzoaRQr9t4jCyKcHnCHs2YraJ06jVD/W/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEJNK/qDTtxgpZz0mMMRXqQxGTCtA7NEaLwrAHN9MlQMWlPDgWTGoDyct6K0L3FtASmm7A5eOeIcmQM+DLt06hEUIFW96ltreSZDOxhfr0XGEjXrORSCjtJj99ujvz8YhXQ/QrWApk3sDn+8KA45erqGk7ykoEcwDLblQb6Mjvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYK9FEGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYK9FEGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412A41F000E9;
	Tue, 21 Jul 2026 20:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665824;
	bh=WPb1zFp2bEMWIHYhDmYtEtfDGDe+6p8tTgnbTmk3JWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYK9FEGKbYcczZ9jEuGk+S62uH5+rmV3EO15eo9iO2vbQBwVWLIGgQx9SR4Qo9cTk
	 v2pXnzQgetC8Y/oRbwJyCvow37+v1S84DIyrAl/0ipA6BLZj2fL0TJFFVdunu+aJD0
	 eo6X53oKnxUKh3Hq7/ShcSd45FWm7zKGlRqiK9Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0449/1266] gpu: host1x: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:14:46 +0200
Message-ID: <20260721152451.884027117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 18f74762013a4b6aa6f905c4459e0f506f9c5c7b ]

Commit "iommu: return full error code from iommu_map_sg[_atomic]()"
changed iommu_map_sgtable() to return an ssize_t and negative values
in error cases, rather than a size_t and a zero.

pin_job() also was incorrectly assigning to 'int', which could cause
overflows into negative values.

Update pin_job() to correctly check for errors from iommu_map_sgtable.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421-iommu_map_sgtable-return-v1-1-fb484c07d2a1@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/job.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 3ed49e1fd93322..70bda32f1ff488 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -235,6 +235,8 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 		}
 
 		if (host->domain) {
+			ssize_t map_err;
+
 			for_each_sgtable_sg(map->sgt, sg, j)
 				gather_size += sg->length;
 
@@ -248,11 +250,11 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 				goto put;
 			}
 
-			err = iommu_map_sgtable(host->domain, iova_dma_addr(&host->iova, alloc),
-						map->sgt, IOMMU_READ);
-			if (err == 0) {
+			map_err = iommu_map_sgtable(host->domain, iova_dma_addr(&host->iova, alloc),
+						    map->sgt, IOMMU_READ);
+			if (map_err < 0) {
 				__free_iova(&host->iova, alloc);
-				err = -EINVAL;
+				err = map_err;
 				goto put;
 			}
 
-- 
2.53.0



