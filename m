Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE71E368D66;
	Sat, 12 Sep 2026 11:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213128; cv=none; b=VNstDh6UO/OI+3GarXG6ihdYIW/rylXDvw+JvG623L1nT4ZiOB8zoFEfByQIqzHOTMA7RAaDqPB1ZEB2YFyZxFfcJRRTcLpAZRhh0OujpXF24LVrwy2U9orosalOOub5K/Jz98WOGaOlJ45obQ6+ohFZ0V0YMG9f46JU0VHFMVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213128; c=relaxed/simple;
	bh=moSKXiU+D4TB1OEOPsFtVLunRmawa7P+i5NJ5U9c6Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJaEd0U2X/w/q5+ulUPYhUCcaiZnBhDIdc6t96vf+b7A35V5tQSwHzOscah/ACR5Usfgz93jS/IcoZkp3zRbSbGnYmz2q8CdewTGjjZB4MZmVxMRdzewmcSPAai8ZTRi3JNbT7K9OZGR5nauE01oZaGFDeInlUbvILC8YDexGmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL0FwPSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL0FwPSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26191F000FF;
	Sat, 12 Sep 2026 11:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213126;
	bh=EDQ7CJoIbVKFXZd6of0Dx3yAuQO2jPVmNitGzI9+xx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AL0FwPSrdXqin5koblcVnNr0SRzZzd4jb3OnIC6pG5szBjHHHk9fWoaxn6cyWCgkb
	 ++ij8m3aleaKfifs8zLmFk0H2qRVIl7sYVh4GIcYJV/En4ya4+tp181nTzgcYYCGrZ
	 f9UaSOf34jxQsEWnolKaNKbWhOdQcp58z+Hgey7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 0059/1376] dmaengine: dw-edma: Fix HDMA channel status register access
Date: Sat, 12 Sep 2026 08:41:25 +0200
Message-ID: <20260912065608.874170129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit ef1b080e03acc83d5bde841da67036985acd50dc upstream.

GET_CH_32() takes the direction before the channel ID, but
dw_hdma_v0_core_ch_status() passed them in the opposite order. This can
make the status callback read another HDMA channel status register.

Use the same argument order as the other HDMA register accesses.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-2-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -79,7 +79,7 @@ static enum dma_status dw_hdma_v0_core_c
 	u32 tmp;
 
 	tmp = FIELD_GET(HDMA_V0_CH_STATUS_MASK,
-			GET_CH_32(dw, chan->id, chan->dir, ch_stat));
+			GET_CH_32(dw, chan->dir, chan->id, ch_stat));
 
 	if (tmp == 1)
 		return DMA_IN_PROGRESS;


