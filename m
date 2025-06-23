Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA225FDA7;
	Mon, 23 Jun 2025 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713354; cv=none; b=SHx1DmkFH2gyslj3E1aUIiuHDaG5+gAczhSNDrya3iLyY0C29QFYdVFTRI+fV0XLxjseIycGGShWBYhu4SS423+4YSait2pEO4K0aBB+AAd0v30WVxHi3S1aUgwNjzzC8mTMeNuGwhPLAQgQ97Hav1F3NkMerK95fbBNNUEIohU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713354; c=relaxed/simple;
	bh=DwGeZT6ZxatV3bHr4v6YAtJvDdap+hsEsml4grEFIig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvHNQkztbXE68GTAvveDj2TgLemfoVpY/R3/gawXH376QB0fBfwpa6G18gnILGv/q1hcPeLuJRByi4h09tSuIX13GLvNcUV5zJQ5alfv+m0dwdfiybP0kbA2p6z2kGCQae5bjViu1RFmscs+BL4SLaqsbf3P7KPbSegkOh7YEx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdDMNnRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdDMNnRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B309C4CEEA;
	Mon, 23 Jun 2025 21:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713353;
	bh=DwGeZT6ZxatV3bHr4v6YAtJvDdap+hsEsml4grEFIig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdDMNnRhlpT4g/wzsvwGIKmvmtnk+x+sAz1sHZDrQKtlG+6xDeEN6NRQsLeLPMBU/
	 tLJYHbEFTC/9pZ8Jf+/f0lF5w4XFy9MXgrE3XaiJOjFeCgl6Ds5QmYYIpeUclFX8Tx
	 gVOyblQ+KiXb7E54/ox6B0OOO01ctSzlr8Eh15e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 322/592] Bluetooth: btmrvl_sdio: Fix wakeup source leaks on device unbind
Date: Mon, 23 Jun 2025 15:04:40 +0200
Message-ID: <20250623130708.103038953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ba6535e8b494931471df9666addf0f1e5e6efa27 ]

Device can be unbound or probe can fail, so driver must also release
memory for the wakeup source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 07cd308f7abf6..93932a0d8625a 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -100,7 +100,9 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 			}
 
 			/* Configure wakeup (enabled by default) */
-			device_init_wakeup(dev, true);
+			ret = devm_device_init_wakeup(dev);
+			if (ret)
+				return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 		}
 	}
 
-- 
2.39.5



