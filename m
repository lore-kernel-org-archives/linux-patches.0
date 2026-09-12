Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3B433F59A;
	Sat, 12 Sep 2026 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215145; cv=none; b=E/VQd5YlC5ynzdkve8SU+lbUV9c2mZDNcsIJBSQHJUfU7aQDxsjbFpE4eppdljtOOUu13Z1bQk4hCVrL8N8zt/jDLIGJThGQAvB9KH8Q7spo4SmwnXs30sSvuiRggJFKzqUDFHw3ndjyIvuw+5dt885VrgmKmPW26hgwOj91vqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215145; c=relaxed/simple;
	bh=ipp9Dv2mthpB6djgkRBAOBrOVP7Bzr2NqUEXyRHhrfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK84X11OYhDBLPmxuFBTU7xFw/+loWJ/fMyniCe64cpkcz9Abf4vJ8qAg0QJSqdwAF9ZjL/1ld9ZhzRFonoGxp0YBOW6FslkvyrxaxDu6y79/XNho9vqRKCOG2FLr+jgo6SfQJHhsuBlsoySQ5vH2xIRzPsywGiBl7C7NDefBr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzmhpZ5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzmhpZ5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2346F1F000FF;
	Sat, 12 Sep 2026 12:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215144;
	bh=fIOLzDni1N905RIpwNFZ4TLFl9a7Hh5wJga2Vn3Vamw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzmhpZ5zvJMRRiWrNmtwRuOeIIgj0w4WAOSp7n9qtmpd0Zgujy8iUT+B2+irjXfLd
	 8vuqp9Sv8VVkBci7akDG/HXHVO1rdqWI0msX4euiHUFswtTDCgal2W5fX+zCi0o2T7
	 I28mNd8y7gD2OKVCjrO3hyFitsIOZTagqW96HRn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0429/1376] staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:47:35 +0200
Message-ID: <20260912065617.096479264@linuxfoundation.org>
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



