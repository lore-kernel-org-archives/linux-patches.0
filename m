Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2772750EBF3;
	Wed, 30 Sep 2026 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783355; cv=none; b=m3gQ5C6KbpVHsFp5Y3xgny+igx96P5adyRRudBvt/rfKN2f3aAyfa9JXYgMc2+GfY+PNdYGJU9CXVGOtiSDIO8RvTSa8WOF8cBQC0Fwt0K0sCb44CWIJhSS6uRa3mlk7Grcg57xyly8lyTWYNaUaTFaHnm20RTic8Gm2onEWFZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783355; c=relaxed/simple;
	bh=SKfHDZAF1DC+urs7xUcPsS0/YYD8HdjZgFiDjWLVtUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWP8nIh8wratQmhjXtx0yJU9sSkctChmoQWuVy00By2qRJRZNn5KXLz081PzvfBpCCrYegsAv3tUJpMgGdQBO1QCXz6qOBTQ3MYOIkTJOfFr2FYnJGyJ44g9biYZHS7GHJoqPAJ+GEr9AAGu2h6XU6AEJFZHGVBWBxBmnYcE+Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM+5TYMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM+5TYMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474321F000FF;
	Wed, 30 Sep 2026 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783350;
	bh=EE4Zrm4Ign5syfcX2BmUYk9n+W9Ky3j8Q4malb9qu6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM+5TYMwo1hcSsO5PeE10yv5XUzmGWyqM/t4P6tIXf+hCKW8iUy9W42ThNedtEIun
	 40/n0Mj0STtbbSmgy8pPsCGO9L+Tz35sLtHuYsHy61QSYCYlp+zEJXaeZ+1o0w/AqE
	 2VUf5cA+rBZIH9dx3Y1fFb3QSQPewVeNeiVoo0b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 369/595] wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path
Date: Wed, 30 Sep 2026 17:24:22 +0200
Message-ID: <20260930152355.613420190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Hao <flyingpenghao@gmail.com>

[ Upstream commit a3d722190cdef18da4878b5efc27c3c386dda248 ]

mwifiex_pcie_request_irq() registers each MSI-X vector with a per-index
dev_id (&card->msix_ctx[i]). On a request_irq() failure the cleanup loop
"for (j = 0; j < i; j++)" frees msix_entries[j].vector but passes the
failed index's &card->msix_ctx[i] as the dev_id. free_irq() matches on
(irq, dev_id), so it fails to find the action registered with
&card->msix_ctx[j]: the already-requested IRQ j is not freed (leaked) and
free_irq() warns about freeing a non-existent IRQ. Use &card->msix_ctx[j].

Fixes: 99074fc1e67b ("mwifiex: enable pcie MSIx interrupt mode support")
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Link: https://patch.msgid.link/20260828111531.56723-1-flyingpeng@tencent.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 7cec6398da71c..9ee932e66a251 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3244,7 +3244,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 					    ret);
 				for (j = 0; j < i; j++)
 					free_irq(card->msix_entries[j].vector,
-						 &card->msix_ctx[i]);
+						 &card->msix_ctx[j]);
 				pci_disable_msix(pdev);
 			} else {
 				mwifiex_dbg(adapter, MSG, "MSIx enabled!");
-- 
2.53.0



