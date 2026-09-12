Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49C2472091;
	Sat, 12 Sep 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229211; cv=none; b=JAdE12XcTQ5sSgDeOfPyjxqGChUzAtu//+Q7jAnMHhaW5NxyO4zCgjXX/hMXqyM4NT8BigTemIpm1bMU2uHRyKhZFPi5tKcd2lXOkhuvj1mVIcT+0kbTwzWbnbl9luUWiFM3dHbVUslPyNSTeJOfhvfMFO/ISDR8R8WhkRyynkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229211; c=relaxed/simple;
	bh=JRTn7LW3Y2CuuerCMgo8fmVFORpFCfs2Z8M2EOdy4wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asUZt4NkhcxK0ghZNRrrkystyie7Xq1ig9vCo4UGz7SGAJHC/N9CvZgwZ00etes1a9tUYXiSgoVQpybm9taqwBwWC7G9S00lAVaWdgGDlmcrftMiAevnFthcJvaNASRTctrPJFBGogtJFw7M3+QseZo5aZklXqAdI95sIvVXcng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Icq4OYGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Icq4OYGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E071F000FF;
	Sat, 12 Sep 2026 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229206;
	bh=5nNaK5Iiso9YUUDFks2XvVLe2o86SHx+NZoF+79KVYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Icq4OYGUpi920ok+ED0gDoaE2FzMQmSLENvu4prx9MECx9HPqtdXrQ6QzwdXsul8J
	 nm0SfH1bSiUVVNAAI7keSqTYGFf7fFABNuT+wDlWg5QL4fh9VJreadk75Grx8U2v3x
	 2gQilHd7mZ54H7D7XONkzLY2lUO+FI7nz862fkwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0542/1191] staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:54:30 +0200
Message-ID: <20260912065600.420449882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



