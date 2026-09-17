Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F053386568;
	Thu, 17 Sep 2026 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670695; cv=none; b=rIoL4HpmdXBWSiZ63hH+KEagMt7BSVM85HUSYQgbp7jNBdgcvG1ymwxstNhSVdD0Ct2U/S+dmcHjVv9SYIC50MkyfAgERUWUBWGflO1V35lazYUuF+wfKHUIbbSLcCthVlXv9S/Qj1YFi8oVyxX6qQiLZ/IJzTZoWc1PZZHbQb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670695; c=relaxed/simple;
	bh=ZDsslsXUOGbj2WH8ADFqWzRfWdOHTIQjC/pjwqWsZL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo/n3/b9lq6Wp3z3k1ddMA2u70F12w0itUMJFFDVhGDWD5OQ7rlaaGugS6RujQlwjOApg5+sWamMRom7M1SnAABJjq85kstfJbiikIq6B++3qqDQaxXPPyIoYrH5PKwX3AJaW3HOmtJxdq8l4YRt/D6xZWtlFLtS6kRfOMoWkaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOGjGkta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOGjGkta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAB61F000FF;
	Thu, 17 Sep 2026 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670694;
	bh=1PcPbPwuk1oRu2c5cTfFU2geRBQX/KMutYwcV2I7t2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOGjGktaaCpycLqVGXbvDQcqyUjnxJHt2o3f80xQn2x1hagGd/gFsqg2VSniiNHzE
	 4wLsDNvu4A+MLMvQv2jnkaaMGxuCPqN7JA/maeaefWQ66wkNLZPqA4EbG7u6MuE3Za
	 djLnqbCfYb4T7Eyi+Ot7Riav7mP//LD8cDZgALgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0741/1102] Bluetooth: btintel_pcie: fix tx_handle bounds off-by-one
Date: Thu, 17 Sep 2026 16:11:24 +0100
Message-ID: <20260917151559.005922432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 3dd1b41f96aad08444be1b7626c89de2b9f2abd4 ]

Valid indices into txq->urbd0s/tfds/bufs are 0..txq->count-1, so
tfd_index == txq->count is already out of range. Change the guard in
btintel_pcie_msix_tx_handle() from '> txq->count' to '>= txq->count'.

This issue was reported by Claude Mythos.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 3be64a209e04b..8ebdfd9744ca0 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -519,7 +519,7 @@ static void btintel_pcie_msix_tx_handle(struct btintel_pcie_data *data)
 
 		urbd0 = &txq->urbd0s[cr_tia];
 
-		if (urbd0->tfd_index > txq->count)
+		if (urbd0->tfd_index >= txq->count)
 			return;
 
 		cr_tia = (cr_tia + 1) % txq->count;
-- 
2.53.0



