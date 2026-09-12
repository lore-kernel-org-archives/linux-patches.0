Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF523F104F;
	Sat, 12 Sep 2026 07:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197936; cv=none; b=j8Pwk7BXHqXl2zNWsBxATxjadwR4xeNb1O7lYKQHl0zcM5BwexX6m73T2BVOnBfKJcDjBxrGtapw5zZa7icXRBZPq0iVi3tfJ6g4voPjI8zsDTZdw5c+v2Cpu8P4WFCmijLBKahrix51ucY/3HP0JVlX54S1OJxXvNl5oznlCBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197936; c=relaxed/simple;
	bh=rKEXJ091L39usXwevV+EO4XYalftCpW+8FjIh7xpzqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwQwhhjfH92SD7hhirF1H530Icx++3Bre2tKW6MK4rz4Ybj3SpH4HufVl0JA+EQ+P/4xK66dxNMFAW5zLvM6DGTzpHnYSyOjKtZITHycJaNUlYS2ay2jwIfxsXXQaabKyjqlEGnobTQzhQlV5YpvgYnEASBAIIgbcfqr+w3embo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQA9P5Pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQA9P5Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18BE1F000FF;
	Sat, 12 Sep 2026 07:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197934;
	bh=WaylYxCYp4HrKos0Ishtkwzh7dYSHdGNyk84FKINPIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQA9P5Pval0OTrIOT3C67XAMGsAtjvmhPPquZtJad153aPrgUB5hCbEb1932Q+1tS
	 u8DY5GbG16rS0qhPucVnzIrdC6i4HcMTLKDZ24lGMJvADh1tRRCHUwQbeP7xhG2aLM
	 8aRV/xQE3y+DTA8b2RWFeqKCQkZDI8Y+/bMlKIT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0234/1815] staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:33:04 +0200
Message-ID: <20260912065654.485722534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Mukkanwar <ayushmukkanwar@gmail.com>

[ Upstream commit c0a9a8586a63fda49e61a6b83360feac2a60d898 ]

cvm_oct_rx_shutdown calls free_irq and netif_napi_del without
disabling the napi instance first. As the free_irq only waits
for completion of hard interrupt handlers, the napi poll
function could still be active. If cvm_oct_remove proceeds to
free the plat structure (which holds the NAPI instances), the
active poll function will access freed memory, resulting in a
use-after-free crash.

Fixes: 3368c784bcf7 ("Staging: Octeon Ethernet: Convert to NAPI.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260511150931.93382-1-ayushmukkanwar%40gmail.com
Signed-off-by: Ayush Mukkanwar <ayushmukkanwar@gmail.com>
Link: https://patch.msgid.link/20260615172734.42038-2-ayushmukkanwar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index cd36b5ba6f6c2..3e9d58d321560 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,6 +535,8 @@ void cvm_oct_rx_shutdown(struct platform_device *pdev)
 		else
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
+		napi_disable(&plat->rx_group[i].napi);
+
 		/* Free the interrupt handler */
 		free_irq(plat->rx_group[i].irq, &plat->rx_group[i].napi);
 
-- 
2.53.0



