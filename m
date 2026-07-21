Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142635C68C;
	Tue, 21 Jul 2026 21:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668880; cv=none; b=mqj/k+eXgk9TzBpCuE0cyfnvOAkRza9VniLaWUahNwP3InIc+2JrGViLQJw/En5lEGHBEPJZI9hRBRjCbYRVEWMFDIEINOAmxgOeMxJ0gabWoYrCYUDaOEMMj4gVlahexV/6/1Aw5rXxMkdvpbRbIuz0FBNIdcu0Z0U4BXPmYf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668880; c=relaxed/simple;
	bh=M/ZaDOmAKwZPbdpcCPrkHblzXsdWH7ePKBe+y7g1reM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6BSXLSyUbIIHbWaDKML5kSz56nudz+kviihpZoaroPsU9gJAIy3+b/C2Jg4fdO6Pdp86CmveiMXFSJedbu3C5COTo+DYoXIBDPEv7Zi5sdQuDyX9GcQodFf8en/su1ICFM087rzaEi2gfWp93LtV+5WeRxsoRbDHnEf1pSvdEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mf6dd5BJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mf6dd5BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7DE1F000E9;
	Tue, 21 Jul 2026 21:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668879;
	bh=MvCvh60SGgqSUdHFN/W63ki1cmyhCPu3gZ6eurI/oU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mf6dd5BJRv2j/jEZoYa065V04FLESjnn5yaE6FcO1mpiPySG9dvBAab75DfqgYt1i
	 XZRIUNIDQGpsCjcMxE2wULPIglH8kdOUgKhFBohRmoZUIJMQdcNlVnwk1OT/jUXS8K
	 /dImqwHPRfn3LqtK+ZDLSYsQQCqUxbln558feLUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0344/1067] gpu: host1x: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:15:45 +0200
Message-ID: <20260721152432.289527057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2761aa03b95cc..1ac3f56c5464a5 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -229,6 +229,8 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 		}
 
 		if (host->domain) {
+			ssize_t map_err;
+
 			for_each_sgtable_sg(map->sgt, sg, j)
 				gather_size += sg->length;
 
@@ -242,11 +244,11 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
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



