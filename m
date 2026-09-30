Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E02522F0A;
	Wed, 30 Sep 2026 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790393; cv=none; b=HJtKAFcpcVj3FJ+f0c9h6EJTid841yJqy/oF9IL4lyGy4bbeAWSv41ZvdcqlSTiL5C/+IFD9QRl1ecrXKndVWN7TorCFtEcFDgh45kk1AHDO6cQNxnyNXyNkE6pV3cyDXOIN3gVdTvrmHZT5Av8+6/mBH7LzSoHxVH6auLlp9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790393; c=relaxed/simple;
	bh=/kpk+AOzBKYW9qebbucjcIfNSOX+MIibPy/1OjFzl3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRBinbulNtPlup7LAdbUdvSBvJS+ZZFR7g+jIh12qcVaq4zI7pjc2Xvx4nGQUwulYruKDEkcTE1CwlVKL2ltSF9sCphN9wTRwS0XeNZwk2CKReBnF85xeah2ReZsdsFmKT1v83KaBrNdUuc9BIBHUxds+pTAnNGM3XnKEqTlfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdgR2qt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdgR2qt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5431F000FF;
	Wed, 30 Sep 2026 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790392;
	bh=hRByjDrC7iX94x2E4omgiAEqodyt9BkuNu43DS7J0PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdgR2qt9wVha0/FmFnZY8a9Z/1XPVSnjj/adkHP5b4auY+A5gA0cuXhEtX/h2cVCS
	 0FlLVXxcD6PaaXoCaOsjfbyhBn5nzFJ33OnGjkvJyNNq3neMQCItUzCTMjiIUdZ5az
	 NNOSPXG5vY7iVclyNBeKpq3tdQr58RTAjggl73Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 812/877] drm: add drm_memory_stats_is_zero
Date: Wed, 30 Sep 2026 17:28:43 +0200
Message-ID: <20260930152432.241789315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit fd265d9e0c3358e6b9fe244d8f5d2824fda1c0dc ]

Add a helper to check if the memory stats is zero, this will be used to
check for memory accounting errors.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241219151411.1150-2-Yunxiang.Li@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Stable-dep-of: 636139603b99 ("drm/amdgpu: hold a runtime PM reference for P2P dma-buf attachments")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_file.c |   10 ++++++++++
 include/drm/drm_file.h     |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -840,6 +840,16 @@ static void print_size(struct drm_printe
 	drm_printf(p, "drm-%s-%s:\t%llu%s\n", stat, region, sz, units[u]);
 }
 
+int drm_memory_stats_is_zero(const struct drm_memory_stats *stats)
+{
+	return (stats->shared == 0 &&
+		stats->private == 0 &&
+		stats->resident == 0 &&
+		stats->purgeable == 0 &&
+		stats->active == 0);
+}
+EXPORT_SYMBOL(drm_memory_stats_is_zero);
+
 /**
  * drm_print_memory_stats - A helper to print memory stats
  * @p: The printer to print output to
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -485,6 +485,7 @@ struct drm_memory_stats {
 
 enum drm_gem_object_status;
 
+int drm_memory_stats_is_zero(const struct drm_memory_stats *stats);
 void drm_print_memory_stats(struct drm_printer *p,
 			    const struct drm_memory_stats *stats,
 			    enum drm_gem_object_status supported_status,


