Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A11017727;
	Mon, 27 May 2024 19:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838432; cv=none; b=Ana0pSGhbaqNij9k7TDpp5nwXr/06zJLpYls+SAxFL21JRqKHbg0T91wh1LjdEFZLO4N1WdV/H3vpPpJJua6NJ5Sp5XzHmTH/v6nAoDyKOMtYzvJXp6txNyssb8gyMC3bJXovtM0gWlvBFB4RClgyq6RXLytQTVSzTxuuIFRK5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838432; c=relaxed/simple;
	bh=wjETf1DgnwTtXK4ekzCTb7RdGLCkQyRMH4fhHcN67ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JrMBqAoPXTidhmedxk/+xbYVDtB682u8nIpN66RBcjuTQy3iqlSh/iay5fdqsKFywXzdYGMhJdoS0+2tPvGNJnTS0ESua3OZmdBM1z+6i76dMYkmNTQL0LkojQgMB9VbyMw4I6jnWSbHeSE4B2RogQfT3rwYEbekX7DfiRDfPBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rA+vOgJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rA+vOgJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117E4C2BBFC;
	Mon, 27 May 2024 19:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838432;
	bh=wjETf1DgnwTtXK4ekzCTb7RdGLCkQyRMH4fhHcN67ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rA+vOgJNKo6+lAyV+ICMnPdL6UDTe19/ahVI4Fr3Bfmw8ysXFF91w0ePbXagQO+5H
	 oRgcskv3If90wr2tXyrSdCVMJrdFh0KABWrGrp/aCn/iOQCNPEMmNH5+mnXAz2sSl3
	 V2svFzfoeK2UZuW16OiTdqsa1fSBuvq+/aP0N5Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 389/493] media: rcar-vin: work around -Wenum-compare-conditional warning
Date: Mon, 27 May 2024 20:56:31 +0200
Message-ID: <20240527185642.984611892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



