Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68EA3AC0C6;
	Wed, 23 Sep 2026 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172868; cv=none; b=BMZ/PST1wGdOsPY9vds4SM1QLvA5WdvUsxHQ2x0iMj0RtAeZK8r5MY7eE0kc0D0LmPG+z08gY4+Lc5gH4bAqp3+zrzgqjMMGLruezqOpU4tSe2txXL9wlf96K9D4vAsKsrZ3oEfDa61jnkR9lO1N/FBCXQjnhc++bQ5SC75z4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172868; c=relaxed/simple;
	bh=T6vKDyh+oqNJRN3VbNNvsBEEVRkjmjQr2FjxZeeswo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+btq5w7rk8Sj90nLUVdqKnzyVwlI4f9esZ7r4XY4IhoWBxgT9+Fi5KnugsPsBmPLNFRjyBe9tlEbj5jcz9xo7Il0Oq2CNTLTW9FyS0xmsU6lzoiWfnJPWM9b00yNxDk4+IrajS/wFbEx48rjMkQo+zNXXgX6NaVE9bqIFuygYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoRxNrmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoRxNrmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0820B1F000FF;
	Wed, 23 Sep 2026 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172867;
	bh=+hgupBGx7/Y8s7am5NM+TDtayerCAJ84Y8fEIuFRz+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XoRxNrmJKf0L+DgG5TAgeblo9qzOrnTVnacMQqldiUS8crvF7jVe8gzPiLlMxuuix
	 EVpMbN7OlRubDGmlqbdVEWxI1/DH1AhgcKG4tkVYjoTc8SNz3U71eX2mU1hOeUq9b/
	 2lQEn74etiP7GniPCB3Yqc+nXJFw7xKn6mPcE7fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 049/438] wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path
Date: Wed, 23 Sep 2026 16:01:10 +0200
Message-ID: <20260923140646.057846616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index a760de191fce7..a9425e9a94f45 100644
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



