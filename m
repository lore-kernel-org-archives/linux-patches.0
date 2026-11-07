Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062086;
	b=CwwaUiNAKpldsh5HbITgya6mK8DwQQuYeYNo+L+FPKDteulXZjGSnN8d5ABdqY/8PCfb
	 X+w4MO8OMwoLtBXCbyYqqq61xQae5++RY9PX6zStI8+dERjbUUROZ6+OO+CenobYMz08P
	 eBflA3UXGhiqMPRrS+yAkd5JpuJ4vqCAa0QVo7HQpTnQoy0yuU4e1iOBRj6ph3yOD7dqt
	 2Ma6LWEmRduW46w+a3wAfw2St24sas9o+j4pwDsFwlihrQafaEzVPGdwbk5XDF8xajgHP
	 MGgTj1si1Ik5+k5uBW7oFQdtxYyAswkIAAoms3ov+fD4bI62Moz/E9p6j1O0vjMU+xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CmkGILkJ2CPiZU0i8Jwj8A9sQjWTKjTRAvbussBLako=;
	b=s+Yjk4uK4LhzmkNQ1TRLXQrLWru7b+wsVVEG5Q2rmD1WxlkuU8Bz9oieXKPI5r9T/zpf
	 f051D0RaO984DdstpN+h1CHJto4fsQ8ofXqol5lI2aMVAPQuQ5h4XcTJaq4k9SceZS0QE
	 cDGNnCD9WSuGmdxDpY/nNXXkCnLpHOSoNTbbCDNPms+DUXVV/GLc5hA6HvoNRD1NYTq9F
	 c1INuZY2PJyzrGiF/TfCtos9a3hWBsgF5ng3sAHDNuyC1sq+MJIfDgCtDPiRRwMHZ15r8
	 zp710+JpHPPkhsHjWZwVZ62L+sue8CCmG/rAJibw0RDBnQdmuawpfDP/RACrcQ+1pSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pR/XQfvJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45696082BEA;
	Sat,  7 Nov 2026 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR/XQfvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627781F008A1;
	Sat,  7 Nov 2026 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062085;
	bh=CmkGILkJ2CPiZU0i8Jwj8A9sQjWTKjTRAvbussBLako=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pR/XQfvJoYqFTw+Kf4GZcXNcnFArw7AmasEm/YPP3G4My7/tWZL12NLeJuvGDGyD3
	 GLfx2SuFEYsYaxkoLL8g7h3HpYFu3+tY+BDcWtPdclrhrrS+mzlw4WF3fWBYEm9F62
	 YhuhRPLj1hUXJWpCyPVv7zIWfn7jm9FGdJldM67c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1060/1536] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Sat,  7 Nov 2026 08:51:16 -0500
Message-ID: <20261107135027.455215409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit dcc36d766dc82bc57cd730915d484119befcfca8 ]

sst_acpi_probe() registers platform devices for the SST platform and
machine board using platform_device_register_data(), but does not
unregister them when later probe steps fail.

Fixes: caf94ed8629a ("ASoC: Intel: bytcr_rt5640: fixup DAI codec_name with HID")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924134932.1590967-1-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst/sst_acpi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst/sst_acpi.c b/sound/soc/intel/atom/sst/sst_acpi.c
index 2571806304755..92a68dbd841ed 100644
--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -253,6 +253,11 @@ static int sst_platform_get_resources(struct intel_sst_drv *ctx)
 	return 0;
 }
 
+static void sst_unregister_platform_device(void *data)
+{
+	platform_device_unregister(data);
+}
+
 static int sst_acpi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -341,7 +346,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
 			pdata->platform);
 		return PTR_ERR(plat_dev);
 	}
-
+	ret = devm_add_action_or_reset(dev, sst_unregister_platform_device,
+				       plat_dev);
+	if (ret)
+		return ret;
 	/*
 	 * Create platform device for sst machine driver,
 	 * pass machine info as pdata
@@ -354,6 +362,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
 		return PTR_ERR(mdev);
 	}
 
+	ret = devm_add_action_or_reset(dev, sst_unregister_platform_device,
+				       mdev);
+	if (ret)
+		return ret;
 	/* Fill sst platform data */
 	ctx->pdata = pdata;
 	strcpy(ctx->firmware_name, mach->fw_filename);
-- 
2.53.0



