Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5532AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301238; cv=none; b=aYsD9bwcNTsDqcGc+DwuN9m0vRT05EI+Dl68QIZ9y3gKHWu661pkgRGZeXfZau65PbfNUhsAW49LVl+WMSy8j1g9ypW5Hzg8PQtajG80MkBYRYZmDkY81s8VY0hi5kT/LF8+vI0wvyYZu+nALYUP2qM4xq4R2Y27MvaNa09A1wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301238; c=relaxed/simple;
	bh=V5zwxPQQmhoylxmdGBbyD7S0kz+77ermZOUg3JESav4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzStPkG79Tx+xl28vtvbD5filjgNGx3TUjAuYoCw3ZmYwTto6iY41IMS6arR/vJVJxpGkgKKyLptpWbxmJ+NMgLDCHS/05NxuyhPZlecNxX69dIQYyyonpgoFUIFk5FbJxwBoI8pWT01N/oZt+Y6CM9ZezSNsM3KgAyat6x8vqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSylXh9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSylXh9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70483C116D0;
	Sat, 28 Feb 2026 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301238;
	bh=V5zwxPQQmhoylxmdGBbyD7S0kz+77ermZOUg3JESav4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSylXh9q9O8Z2csu4jjhnX953Bmh4woJrCl6OXYipvI1h4A2NciEX11saQ12dSaT6
	 /yAQetT8a+06+PCTU60zA6tvUH5DeaEITLYPLqq3QhxXRfHp9PT8eb3sLK9apS3cd5
	 jqcUlifs4z0VIvXDh20i8AzSkyFZFPzkXXnRzQ9sKuCPA4fIiVt8JuyGoBVfwk/oxV
	 n7yHwC5qAUEewx4d9/2icW6y9ugSUqsXrq3w8rtiKlsK64Uuiu1GAFnj6qFkH+mjl1
	 +0kzgoqS7ICGgmTKGB2KrA5C/spzet4I6aa7G7k/nbOfL2nYr/2TfcXrHPtrALy7Sy
	 f1pov18sJ8E1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 417/752] wifi: brcmfmac: Fix potential kernel oops when probe fails
Date: Sat, 28 Feb 2026 12:42:08 -0500
Message-ID: <20260228174750.1542406-417-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 243307a0d1b0d01538e202c00454c28b21d4432e ]

When probe of the sdio brcmfmac device fails for some reasons (i.e.
missing firmware), the sdiodev->bus is set to error instead of NULL, thus
the cleanup later in brcmf_sdio_remove() tries to free resources via
invalid bus pointer. This happens because sdiodev->bus is set 2 times:
first in brcmf_sdio_probe() and second time in brcmf_sdiod_probe(). Fix
this by chaning the brcmf_sdio_probe() function to return the error code
and set sdio->bus only there.

Fixes: 0ff0843310b7 ("wifi: brcmfmac: Add optional lpo clock enable support")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arend van Spriel<arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260203102133.1478331-1-m.szyprowski@samsung.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 7 +++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 7 ++++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 6a3f187320fc4..13952dfeb3e30 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -951,11 +951,10 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		goto out;
 
 	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdio_probe(sdiodev);
-	if (IS_ERR(sdiodev->bus)) {
-		ret = PTR_ERR(sdiodev->bus);
+	ret = brcmf_sdio_probe(sdiodev);
+	if (ret)
 		goto out;
-	}
+
 	brcmf_sdiod_host_fixup(sdiodev->func2->card->host);
 out:
 	if (ret)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8cf9d7e7c3f70..4e6ed02c15913 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4445,7 +4445,7 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 	return fwreq;
 }
 
-struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
+int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
@@ -4551,11 +4551,12 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
-	return bus;
+	return 0;
 
 fail:
 	brcmf_sdio_remove(bus);
-	return ERR_PTR(ret);
+	sdiodev->bus = NULL;
+	return ret;
 }
 
 /* Detach and free everything */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 0d18ed15b4032..80180d5c6c879 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -358,7 +358,7 @@ void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev);
 int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev);
 int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev);
 
-struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
+int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdio_remove(struct brcmf_sdio *bus);
 void brcmf_sdio_isr(struct brcmf_sdio *bus, bool in_isr);
 
-- 
2.51.0

