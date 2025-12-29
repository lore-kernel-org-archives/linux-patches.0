Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E5334C0B;
	Mon, 29 Dec 2025 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025968; cv=none; b=T+bVV4sa8wVULCxbIshAMQ2YtsdSIiGPxhKGZXM4DCXmDsoN9K1Cdrp228EN57LOUgNvFP8r+nAzkvY1HSGRGMSqb2N9LM0xr53PwdKnkB2655eJ4yOn2h5qAoykAZy+dmPQSovtVnk69Gt+EQ0Gb/fQZjr/sZ656qhV799jvrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025968; c=relaxed/simple;
	bh=WwEJzVmn1BD8SOGt1pktGJXwsQFhPKc/9iRGrauNZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIo+T7SKbkThkNxFvxvuuMpRGCNhWNLVBrZyjU1zI08FhOBQ5sX05FcNiyYENF24tAtF0GMGavQ4teGz4ThhyV/1SaLrxzZFHaWxOfREsnVrxPhxSXn58eXpNj2ux4JydsUFcZE0IcoHvfeRQRB80rZ6mP54Oi9AmiS5FT0N0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fbea4Ewn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fbea4Ewn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF5C4CEF7;
	Mon, 29 Dec 2025 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025967;
	bh=WwEJzVmn1BD8SOGt1pktGJXwsQFhPKc/9iRGrauNZcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fbea4EwniQrQDWMP7ynvc2wJwKWh+tcpEf93O6A66dsEfdULgRypmMQk4Hvqvw3V/
	 ySHC1UsKAP8yVOwBB/Iml6J53p3WiI/hjj6gIkpyE6Cw+Lajxc1W872nOGVO1lSE67
	 qMv7Rs7vXGM2/VkiKubhi9+0zu8nCGJJmYmWwteE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.18 400/430] amba: tegra-ahb: Fix device leak on SMMU enable
Date: Mon, 29 Dec 2025 17:13:22 +0100
Message-ID: <20251229160739.034907911@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 500e1368e46928f4b2259612dcabb6999afae2a6 upstream.

Make sure to drop the reference taken to the AHB platform device when
looking up its driver data while enabling the SMMU.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 89c788bab1f0 ("ARM: tegra: Add SMMU enabler in AHB")
Cc: stable@vger.kernel.org	# 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/tegra-ahb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -144,6 +144,7 @@ int tegra_ahb_enable_smmu(struct device_
 	if (!dev)
 		return -EPROBE_DEFER;
 	ahb = dev_get_drvdata(dev);
+	put_device(dev);
 	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
 	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
 	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);


