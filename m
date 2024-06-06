Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730019ADB1;
	Thu,  6 Jun 2024 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683362; cv=none; b=oxzMDmn2VmeFQb7Pdl2p/F/csMZAEE8KmsuTyCLhxqleFGAm9cMks7PzyXmk2e03DRs0gjL9Cr0buO+/LpyjucpWyjsfnEi+VevPVLmFkjp6xB03dQtPs3/l1dswLtSiOW7n3oHIU+o8N0K3UkssPRY1gvj+haMjRe8uQvRm22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683362; c=relaxed/simple;
	bh=kAGdeGsvbcPcO7F0YlYMzao/fGI3guByJPMuCT5gfd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DY9cjV29v3qeorF352eODYA2rJofBVhmZw8aXWGR/81ie0i8gQQ7xg6d/4l1g0bN8ptbVVCo3H46mWdO6oEcfVRDMEfF+tNpECAWKRIv/ZlsUYYmUZE4bXyb6xr5Yz0JjG8kDuob3QjLJTRvnoh5lM/dcVr+beEMZR1HxUObRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWSCYa7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWSCYa7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D352C2BD10;
	Thu,  6 Jun 2024 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683362;
	bh=kAGdeGsvbcPcO7F0YlYMzao/fGI3guByJPMuCT5gfd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWSCYa7edDfoM9u9Osv8734/uFdyUdCSEmtGhC143Ede13MAdZjaxxepLlWV9StrG
	 Ru6ZM179hwS9teNLNaYKIYoSSzPU7GYNYaUmavg/kZq19SHsGR38IpmRq23aj5bt57
	 1BZUyJ+XEY7leeoHo6GhEH6lDgqmsFifa5kKdx1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/744] media: rcar-vin: work around -Wenum-compare-conditional warning
Date: Thu,  6 Jun 2024 15:59:36 +0200
Message-ID: <20240606131742.131683057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1a742c6010d136cb6c441a0f1dd2bfbfae3c4df2 ]

clang-19 warns about mixing two enum types here:

drivers/media/platform/renesas/rcar-vin/rcar-vin.h:296:12: error: conditional expression between different enumeration types ('enum rvin_csi_id' and 'enum rvin_isp_id') [-Werror,-Wenum-compare-conditional]
drivers/media/platform/renesas/rcar-vin/rcar-core.c:216:18: error: conditional expression between different enumeration types ('enum rvin_csi_id' and 'enum rvin_isp_id') [-Werror,-Wenum-compare-conditional]
drivers/media/platform/renesas/rcar-vin/rcar-vin.h:296:12: error: conditional expression between different enumeration types ('enum rvin_csi_id' and 'enum rvin_isp_id') [-Werror,-Wenum-compare-conditional]
drivers/media/platform/renesas/rcar-vin/rcar-vin.h:296:12: error: conditional expression between different enumeration types ('enum rvin_csi_id' and 'enum rvin_isp_id') [-Werror,-Wenum-compare-conditional]

This one is intentional, and there is already a cast to work around another
warning, so address this by adding another cast.

Fixes: 406bb586dec0 ("media: rcar-vin: Add r8a779a0 support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar-vin/rcar-vin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/renesas/rcar-vin/rcar-vin.h b/drivers/media/platform/renesas/rcar-vin/rcar-vin.h
index 792336dada447..997a66318a293 100644
--- a/drivers/media/platform/renesas/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-vin.h
@@ -59,7 +59,7 @@ enum rvin_isp_id {
 
 #define RVIN_REMOTES_MAX \
 	(((unsigned int)RVIN_CSI_MAX) > ((unsigned int)RVIN_ISP_MAX) ? \
-	 RVIN_CSI_MAX : RVIN_ISP_MAX)
+	 (unsigned int)RVIN_CSI_MAX : (unsigned int)RVIN_ISP_MAX)
 
 /**
  * enum rvin_dma_state - DMA states
-- 
2.43.0



