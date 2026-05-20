Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABC13D75D3;
	Wed, 20 May 2026 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298603; cv=none; b=g+noGNOIJUnEUqn93RUci1bypIJvqm55NhrB8iEB8hg0Vry1I2hWYFOrA23Pz37HfwJLUsz0AYl6jtITxx3ngyfiD6pJfdKUxvqeKEYbDSGqvAePrzdJjpjf6PW/5uxWPbBBy8O3Eq8o74N+vNRES9oeYUt8lR8XIDgJSprScpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298603; c=relaxed/simple;
	bh=jd5TmXz5twlb4vH+nd15yStkFzebxatyRDkoujRNxDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TImEzlaDQajP6STwjmHKHnqfUzvFXii9Izb/SBwcgQiGGB6d1TYQZdmsOLKExwKXwHtfMLe7jRMzz67WngW6Yic/benG7SRulqz3P6hogRkKkqhAfxfcz9STXpAPmEsEAVYurqXj8/vTsBuq7+lttXFed9zHHyxwouz/xnqR0Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O09Geuuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O09Geuuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF3C1F000E9;
	Wed, 20 May 2026 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298601;
	bh=WCNapPG+bJoKfbXNg5P7gYsE6L6ySBZV4fCtiJc3bbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O09GeuuhWptteEpPZgjGU/ZQd6RXHR7hrr+JZVx5/REQNx5JFVE/Dc7V2wdhQfICW
	 UpJPfJ49seUoqBeDfxZYjwjfjwJhT/BYg/WHV8KneFFORYudLujqFPcHmsLww+LOVq
	 rZlRfzURUXFiqGm8hjBtet4w0skS6tkTtrpoyx2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 472/957] cxl/pci: Check memdev driver binding status in cxl_reset_done()
Date: Wed, 20 May 2026 18:15:55 +0200
Message-ID: <20260520162144.762136121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit e8069c66d09309579e53567be8ddfa6ccb2f452a ]

cxl_reset_done() accesses the endpoint of the corresponding CXL memdev
without endpoint validity checking. By default, cxlmd->endpoint is
initialized to -ENXIO, if cxl_reset_done() is triggered after the
corresponding CXL memdev probing failed, this results in access to an
invalid endpoint.

CXL subsystem can always check CXL memdev driver binding status to
confirm its endpoint validity. So adding the CXL memdev driver checking
inside cxl_reset_done() to avoid accessing an invalid endpoint.

Fixes: 934edcd436dc ("cxl: Add post-reset warning if reset results in loss of previously committed HDM decoders")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/20260314-fix_access_endpoint_without_drv_check-v2-4-4c09edf2e1db@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index bd100ac31672d..c78d7d88744bf 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1104,6 +1104,9 @@ static void cxl_reset_done(struct pci_dev *pdev)
 	 * that no longer exists.
 	 */
 	guard(device)(&cxlmd->dev);
+	if (!cxlmd->dev.driver)
+		return;
+
 	if (cxlmd->endpoint &&
 	    cxl_endpoint_decoder_reset_detected(cxlmd->endpoint)) {
 		dev_crit(dev, "SBR happened without memory regions removal.\n");
-- 
2.53.0



