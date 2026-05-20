Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A9E33B97A;
	Wed, 20 May 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300804; cv=none; b=eN12TpwYqaBxvy0F0jtpp3muoMtrKDwJK1KHgP/TReywJHMmiAUvs9eUAAYLvgE/lSUAZhXo0QwNlvdnv8/IlI5vo1n74Zm34y5zL4fMo0KLzRi3IDqGhinFX3Y/cAMWjCojIYdT6hLKls1Zwc7ILGgdMaIN4RgF27u2XkdV98A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300804; c=relaxed/simple;
	bh=U+dTYVGob6CHMG3tDGycCCsuaxFpJqtXEWgilZyOX7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRAnNGdfRFtxtCj8GnwZralJkel82cW/R94hEYYCA0vHw9llx4iv/uib1zlxauv1z4R4xbUcIPsth9MIojCGZLPj1MD+by68rMqDFlNMFkC9Rytg963w/24hjinAV+W4n/k1QefAH3WFi64VFP68KY83KZBdQScFqq9sVZ1DwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DG/PP6FW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DG/PP6FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7DD1F000E9;
	Wed, 20 May 2026 18:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300803;
	bh=MyDsAzyZkhN9tKo6KI+1M2DKJfyhgXxGK477lkVHBlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DG/PP6FWh9PuPVijpyYeW/vSUp+xMaMnLXmTI6p6OmVplTQNNBRcLoB5KCzkxf6/9
	 2RVrlJ71vXnl2zdKuEHhsEi27WdYu3bCHXsUcMgomCYMOxLZHC0L3djt4DZJWfuhXW
	 2llEf+/xsDQrhORziZNzsVPjRxvqDZDDfb3KbDDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/666] firmware: arm_ffa: Use the correct buffer size during RXTX_MAP
Date: Wed, 20 May 2026 18:18:46 +0200
Message-ID: <20260520162118.048293992@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Sebastian Ene <sebastianene@google.com>

[ Upstream commit 83210251fd70d5f96bcdc8911e15f7411a6b2463 ]

Don't use the discovered buffer size from an FFA_FEATURES call directly
since we can run on a system that has the PAGE_SIZE larger than the
returned size which makes the alloc_pages_exact for the buffer to be
rounded up.

Fixes: 61824feae5c0 ("firmware: arm_ffa: Fetch the Rx/Tx buffer size using ffa_features()")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Link: https://patch.msgid.link/20260402113939.930221-1-sebastianene@google.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index bec1fbaff7f34..15e71a53956e2 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1804,7 +1804,7 @@ static int __init ffa_init(void)
 
 	ret = ffa_rxtx_map(virt_to_phys(drv_info->tx_buffer),
 			   virt_to_phys(drv_info->rx_buffer),
-			   rxtx_bufsz / FFA_PAGE_SIZE);
+			   PAGE_ALIGN(rxtx_bufsz) / FFA_PAGE_SIZE);
 	if (ret) {
 		pr_err("failed to register FFA RxTx buffers\n");
 		goto free_pages;
-- 
2.53.0



