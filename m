Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E88131328E;
	Wed,  3 Dec 2025 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776167; cv=none; b=PBzEoWa/TGmRfEii5qgRD78ArR28DWqdcd7m2GWzwQ7J+kFQDYyjKslDUHToyWmQYibEb7zCp6qzxfBUpaJ6sFVFHUkrJWzZVyld+xO7aQLabR4kxgiHZqr9e8n5AFX+aBGysk2QUOCGd/f+9kdf3s5nmaYYJEHL50StSqMlAKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776167; c=relaxed/simple;
	bh=IVhGL2lEFGvXAHh7BWJJGXseA+QGtr9PyWqP0sIFHgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISlpjohzaqreUh40qJD+KfZ3S/HOvC/zd5sUNm5+dCCyqWxPcqQ0W+/AtO9yCJQxJP+rWZUz0EsrDGPtCejl3lIv7y1Kdn4oNWLcdUjftGnQ13wM+3xTfA64H5Li5pMNumB2oETnmIQbrR4X93yTzo7Iop/9sU9TFGe3X1ITs+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRRtyMaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRRtyMaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563EDC4CEF5;
	Wed,  3 Dec 2025 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776166;
	bh=IVhGL2lEFGvXAHh7BWJJGXseA+QGtr9PyWqP0sIFHgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRRtyMaRhGd/3hqQW4d84iPs29grKIDmnYf9hIUPHriPpcww0u65nhx0GBl/ZhrDd
	 tdZW00OfTND9QtyQlSeD6mOVAlRSxcxu/d2MdGtJFjoj3lreoDVGn36ZYJp+t3bBav
	 GcYQwb/lwa31rCv0hOfDgmecs4+EthytctzNmlwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/300] drm/amd/pm: Use cached metrics data on arcturus
Date: Wed,  3 Dec 2025 16:24:32 +0100
Message-ID: <20251203152403.141591941@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 2f3b1ccf83be83a3330e38194ddfd1a91fec69be ]

Cached metrics data validity is 1ms on arcturus. It's not reasonable for
any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 3a31058b029e3..729f6d60fac0a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2276,7 +2276,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



