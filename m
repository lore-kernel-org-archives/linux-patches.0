Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008A817E90E;
	Mon, 27 May 2024 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837115; cv=none; b=DkNSQRUWvqLWp9drTf7FQLRFhNNh+EEgsAGBRPa7wTvMam3JCmIkjdwO8kGqu3kjg8kUyD9nCMO/aRHnQIxhELW9pnm32y5tTpjFe5gw1nhGA6Oq6V9viByDeNkFQcWAEMQVNHRXDiXC9Bfz7hvlRqhY/bz3duw5mRGIZnnpYNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837115; c=relaxed/simple;
	bh=9V6PJjLriYp3NOT+kJyr4bGDLJcw+N9D/k1LloZuJqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+3HfLytObhHd4mRUXa4R8VloakyN0W7f+7lfYWVvB99X41J539btixKOBjeBXtSWdSu0N/apeUgtJlla+uM/8dgmWqXHFfcBuijreerpZK3gfyleoUXbA6bj3oKoDNWhEI4cgW4jqwZsrjD0wPAEDp2r4zGfz9BWNMFa4yvFxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EURbC8ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EURbC8ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8728FC2BBFC;
	Mon, 27 May 2024 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837114;
	bh=9V6PJjLriYp3NOT+kJyr4bGDLJcw+N9D/k1LloZuJqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EURbC8eaXZRpnuISrqkSTluI455wL2zv18woXZgZguCStpYVt7TYmcrrZMf4AEetF
	 JAAEXyn3THGjGXey1ouG8ZsqeHgs6MWUtejW1+bG18BEv0t0fA5tG3wxNb1MLjHyI1
	 rtaeoabDMEFiW+uIP5yDsZMocHPJds1P2aMfHJjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 314/427] media: rcar-vin: work around -Wenum-compare-conditional warning
Date: Mon, 27 May 2024 20:56:01 +0200
Message-ID: <20240527185631.141614629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



