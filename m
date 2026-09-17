Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183AC4DDB5D;
	Thu, 17 Sep 2026 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659811; cv=none; b=UiKi5yQMzdzS/BJf3e/tB2a2HjS63QBcyFow12G3xfHzHRCpwNhC/ffSQmKup3E19Vw9HUkKPaS1bb9tsO6ubnBkyn4bClPf1SHMKhbLt3tkyxuLdWIpQ/dedDHwcWYkhdW8OrPp9NbC5D5I68F+kbGZn1fWgTi8ULpihn7VDPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659811; c=relaxed/simple;
	bh=NQciJp6HmZvsZmFUMg9T8TsuzHe+mfayDDIIKZyN+h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxBUAWMX4j27/MA2Fc3wLEwoDdKYyG6ayeTgTHgsP06k4KK8rP2iU/Janf3UAIEHIzXI0Yzl/k8z4xK5poqxCwF12rWq2ekbDAITqscURahLExNrCE3nmT+U9krkuDLbWkUaqonHWCYWVXoHCwBgm11QYJCusFxM/MHMZoGoMKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w67osurv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w67osurv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865F71F00899;
	Thu, 17 Sep 2026 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659797;
	bh=b5B2CKfdgt2KtTmld0bG5Sm18cRBsna5HA540FTp5kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w67osurvCCgfxT7ZZgiAUkq+X0T6ODiVi2AJG3rNGne9b2+kTI6pTBoL0euCtDO9s
	 i4GBBhGzcLht5Rj3rZ8q/+EICFxxCesImElOUqE8SzR3tE7OdPlXZ5+ljIt8p9TRm8
	 0qA9t/rn6RudVH7ccqV33opph47uWwx2UGU6C/Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 378/733] Bluetooth: btintel_pcie: fix tx_handle bounds off-by-one
Date: Thu, 17 Sep 2026 16:11:26 +0100
Message-ID: <20260917151401.085711717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index da46fb39d53ea..c64e96fe88976 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1099,7 +1099,7 @@ static void btintel_pcie_msix_tx_handle(struct btintel_pcie_data *data)
 
 		urbd0 = &txq->urbd0s[cr_tia];
 
-		if (urbd0->tfd_index > txq->count)
+		if (urbd0->tfd_index >= txq->count)
 			return;
 
 		cr_tia = (cr_tia + 1) % txq->count;
-- 
2.53.0



