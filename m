Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC1150C2A4;
	Wed, 30 Sep 2026 17:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788205; cv=none; b=gAbUa4mt75IqBa9Epatl3uhw0XIFJM7jDdNLb0ioJySJjQnofy/Gu1gefsW+GC1GKkeq6RSPWebHOVB1u50axBKP5uNuXVjEx/OlX29v6lYdc3MpjmWgq6H6qvFfvh++IwF2SFRGCW/QzfowNdhcQrtEztkR/xbC3W7DoTpp8l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788205; c=relaxed/simple;
	bh=kQDYnRXV+8Q1KqJGQnWXWetmW6HSqdwPdL0E58uxsuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8fIqqd847mmxLnJbNMa6AkRskQeYPe/m3EbffTQYhHIqyX6vpf5hfyzN6aE4vJj2+xkzUDjxoBVNfXgaD/w0xYf2m1Cy9up+IylO1m9klVUg3e77IAtfmhdK3SWevLEvkn9cY3S4avogQrg34tLx5pQLcgF9vibW8Bnu3GIjtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORG6XxXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORG6XxXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACFA1F000FF;
	Wed, 30 Sep 2026 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788203;
	bh=n+L9HGGPGtZAJKQHMl4H/EGvCmveiGHr3FrzZZUOmSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORG6XxXVAoBDs47DWXAOaQ+Ys1b6+PhaXkTesOgdcemcNLZVi86TrlkQQ5otTqW2q
	 2jK89BMVmuo5ENsXNlBBuYJBBMBMfO8ICl6PXX82MfHLk2Kh/MERGo02Z2uGxc4Sxy
	 Bsk/M56UKWB5oz42KiO6egwJGLBq92L97lE0Z/1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/877] wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path
Date: Wed, 30 Sep 2026 17:15:53 +0200
Message-ID: <20260930152415.654212470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 5f997becdbaa2..d36d431f53679 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3068,7 +3068,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
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



