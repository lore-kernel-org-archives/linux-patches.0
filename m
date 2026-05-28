Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DC12E7379;
	Thu, 28 May 2026 20:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999756; cv=none; b=By5QvOeOp7nntxI6jlmxC35gwIwTd9ig5tI4tosVtsFBbz9IpMajbzbN/uSt9E+plOr2TQkAGDKI9qQeeQ2GAkV0vU81PGb7JwujpYSb3eeB+ottJlL0zgim6k5sPpAelhxoTvzS403IGUuZnx+CH9QQOs0VZ/d29jHnKPdau/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999756; c=relaxed/simple;
	bh=VoWWErAtPnW7valjic0diW1D9r6nhvr8cuiQyfWiPjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhsWneHwLpTTi/Krjc+9LHWpJEjTZUS79Wf4mXFBoa35TZLdj9d9REqoEPbiZQ4senPyFdulnK6ArJRcVe0MUUc5/RWrGfOvzVNr653wZTjQlGTMc/xBiyADsO1tdOcJke4Zwgub/duXyYUECul/DlINNRND41EaSIfJjJeMAl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB8Bkvmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB8Bkvmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703FF1F000E9;
	Thu, 28 May 2026 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999756;
	bh=+ujj80sQ/TCYIdT/slIX9UqqPjI69Pq13Bf6YP+XQ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZB8BkvmhJmbSEkmcXeAbJIdFScGX1GfhCx4qb/jJ9aLZyI77prZM3zSpfpyS+57WO
	 /kQXHXhGtsaIFttZN2Ml9qSidUSz72hgEoqVsq1J9pkx89/ACv+5tui+TUua5bACsQ
	 TNQuaVMP/rApFKCj1wP4lhnIweJXwg9cZtjPwEPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/377] firmware: arm_ffa: Skip free_pages on RX buffer alloc failure
Date: Thu, 28 May 2026 21:46:58 +0200
Message-ID: <20260528194643.635329699@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 09527e2c534911619d7e098729711100290bc3e1 ]

If the RX buffer allocation fails in ffa_init(), the error path jumps to
free_pages even though no buffer has been allocated yet. Route that case
directly to free_drv_info so the cleanup path is only used after at
least one RX/TX buffer allocation has succeeded.

Fixes: 3bbfe9871005 ("firmware: arm_ffa: Add initial Arm FFA driver support")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-2-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index d71a2ef335d1c..cf7f913a55b6e 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2063,7 +2063,7 @@ static int __init ffa_init(void)
 	drv_info->rx_buffer = alloc_pages_exact(rxtx_bufsz, GFP_KERNEL);
 	if (!drv_info->rx_buffer) {
 		ret = -ENOMEM;
-		goto free_pages;
+		goto free_drv_info;
 	}
 
 	drv_info->tx_buffer = alloc_pages_exact(rxtx_bufsz, GFP_KERNEL);
-- 
2.53.0



