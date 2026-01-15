Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766D33C198C;
	Thu, 15 Jan 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498138; cv=none; b=hOUnNTPT86g6QtEe2IiOZ5H5BSJS+7+t/UIfzU3b5jMWSK4Y6x2IrlkgdOL0oz28Y5O13a0ypqbw1xjjhkDNzMTY7BharukLtFIDwYCgkZOdbUh0DTyIRa3xCXMqhBO2NAUIM/hiS0wx/H2mudMQpKsHpC6YJZpTD2LFm58s0sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498138; c=relaxed/simple;
	bh=xtFcWs5TIUFT02clnv3qq9Bx8v27PEix7DYXUf/yD9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfkCSL+Q6kyemLq2HY+NC5IZMf4a/ImAz1ZLW5HRi1VB7MESEP1LPudyGuzJD56v/ArUGCV1hUFlgOvwv089QK65dGASHLBvRcR2iCGCHVNPhTCE2IbRSgx1fMOG8ofbOZ9JrNe6bxQMwxOSMzT1Es0FukJBNRDgicri4klfyW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3RCk/Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3RCk/Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EB8C116D0;
	Thu, 15 Jan 2026 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498138;
	bh=xtFcWs5TIUFT02clnv3qq9Bx8v27PEix7DYXUf/yD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3RCk/TkMAo1UgDZ1RZxPOC67UldTJ1fqtX/L1GCgt0KU5AD8CPrz3QGnZZXXzPBM
	 9E4nTJ5ezZoeaJhg+BqUsWB301NJUkpgRrFoP4UHEUqhKKLTjkLph6eoLQboXCjarq
	 4q6s0BPxHUnIDsbUooO+q+N78NqDZatONCv/QQGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 327/554] amba: tegra-ahb: Fix device leak on SMMU enable
Date: Thu, 15 Jan 2026 17:46:33 +0100
Message-ID: <20260115164258.065285421@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


