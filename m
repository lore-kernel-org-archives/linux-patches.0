Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0323D5645;
	Mon,  4 May 2026 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903719; cv=none; b=lXGC0Ri+KeyViVfYEvLqtpHLUIBAPOoaqe1Ds7l3KdLDk2gacffTTNSPlpMemqLyEoDvPttia5IgiZqiJPKMZVtK+cAqH4oBf7fV6B0OEa8fjHHZsRp5d4C324+3TeLoBBsWDANF74xWjd/wgGSiGXWJ7Hv7MSkvUIEuwc6wrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903719; c=relaxed/simple;
	bh=Ciz0nCafi9Hv/c+hTYQVdIwEtQQjL696qR4a4hUgmr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB+zYsr+fX13n1ywfAh/pb+CmUNT6nJ0ybYLCcfG0YQyyg+x7eKdxeI2+iiNaWKIp32dEClLsJQONAhrDvniNMG3h18xkEBjjWuHw3RLWFvKfIBRl1o2HAff+i2d7vCTx31QFYxxX9UOBkQj+eKT+puEVfEGQlhoV0IogXMgSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqxSo5pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqxSo5pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A4C2BCB8;
	Mon,  4 May 2026 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903719;
	bh=Ciz0nCafi9Hv/c+hTYQVdIwEtQQjL696qR4a4hUgmr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqxSo5pdmuvOi1AyIHB/10zmub++2ry6YaTJjl0gSOZMb2TXtHKsSXZxwnou+AT++
	 IlUMVpDNFZSkeOrnXs1iV+DE3B6aiUQgbT97pFwe0U5P4QLiSIC7eB5oL3EGWWxh8v
	 OxERpxQuRrx0vFP1O+u9/JiZ1drOYXsY9Rnn6bxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 018/275] drm/nouveau: fix nvkm_device leak on aperture removal failure
Date: Mon,  4 May 2026 15:49:18 +0200
Message-ID: <20260504135143.615997025@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 6597ff1d8de3f583be169587efeafd8af134e138 upstream.

When aperture_remove_conflicting_pci_devices() fails during probe, the
error path returns directly without unwinding the nvkm_device that was
just allocated by nvkm_device_pci_new(). This leaks both the device
wrapper and the pci_enable_device() reference taken inside it.

Jump to the existing fail_nvkm label so nvkm_device_del() runs and
balances both. The leak was introduced when the intermediate
nvkm_device_del() between detection and aperture removal was dropped
in favor of creating the pci device once.

Fixes: c0bfe34330b5 ("drm/nouveau: create pci device once")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260411062938.22925-1-devnexen@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -874,7 +874,7 @@ static int nouveau_drm_probe(struct pci_
 	/* Remove conflicting drivers (vesafb, efifb etc). */
 	ret = aperture_remove_conflicting_pci_devices(pdev, driver_pci.name);
 	if (ret)
-		return ret;
+		goto fail_nvkm;
 
 	pci_set_master(pdev);
 


