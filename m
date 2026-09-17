Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2652CCD5;
	Thu, 17 Sep 2026 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665971; cv=none; b=VgB/1uT1iix2iU+LaiXINTf4FbHFaQlgZgQ1eb+Hq8+6Uv5cFlT2RUWOG6UbkQzMz9gTq+Ux971uuFXd+v+Qf2g7kICcjO1mKyAOsi34/Rbv3l40+QlxNu2qlTSNtj53J+k1nOKAvQNHql7fVs2Vf9+tRB55op/WXsTsUayLGeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665971; c=relaxed/simple;
	bh=uJilR6o+EDfRfPG0VbnHj2FatG3yVTwRW6J14IBZT1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTHik2RWTru4saC/JwTPWk0PHEkTHLpv07goYMI/acz3vNkjmHPSUu1Q6q8Kl3q1dxfF47j9D6rpWZ6d04AIVLn4jKllNyG4vLfwvtmVNpDNGkcGFhdbPthCW8iTfIHSYgxMnkVBVzCG9uuPmpiYNU/CUpUejjPU2mTkdR0EuKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLLOO4c0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLLOO4c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A931F000FF;
	Thu, 17 Sep 2026 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665970;
	bh=ReTs2Kj+2ted3cmgpGbXi+WF+ms7iQznKhR50CyMe0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLLOO4c0Oq0OUQPqwf1T8CZdsBov9QxGDwzG0TmaTwxrPINrF5w0MDXiLR3vuJDyV
	 U6qShBmne9PAzATF2Q8MQcOlWh16540LsP+vL1Ox/BSVEaCxQ7B9J/aotnjysPoCaM
	 PODIT8kYcV5JLeU9CILVxRVUFexLz8wjikOgbWoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0881/1250] Bluetooth: btintel_pcie: fix tx_handle bounds off-by-one
Date: Thu, 17 Sep 2026 16:11:16 +0100
Message-ID: <20260917151615.863558326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index e599e89725cd5..56ba643d5ff7e 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1018,7 +1018,7 @@ static void btintel_pcie_msix_tx_handle(struct btintel_pcie_data *data)
 
 		urbd0 = &txq->urbd0s[cr_tia];
 
-		if (urbd0->tfd_index > txq->count)
+		if (urbd0->tfd_index >= txq->count)
 			return;
 
 		cr_tia = (cr_tia + 1) % txq->count;
-- 
2.53.0



