Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48930175D48;
	Mon, 24 Feb 2025 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408060; cv=none; b=KWeMWjlLVdvJFmUOfPx9xeqlJmQ5nuPq95Ect4m6zu8+FL6E9BEk77g9L9TuH6M8A1Jw+07oZMYXzqROXJHcpV1xQgcHlQlQ79xxep7fEd0T67wYeUOPU1wabNg9mhMlLh0SPUiV6MKkVHM7hxlVuF41BgSh/zkglbOsPFN4Tmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408060; c=relaxed/simple;
	bh=gL0ETcfzFzWiIuJ563cJ/uN5NQ9nFNvwC5Fq6/Lbhlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LF4OUf2ggWgkAZGVfiDkkMy78iJNZQ/V1F/Lf9aa4Dv6/+gaH8xuodnAf1JzOX/KYGSSVu01zz90gRc9lClxbNFNkDU4mlqPC6Dv3RSfnnrXAqTX+BNhuAkfybIfJuV7a/TixNlDnWPdgboDV9DRxrLT6jRg4djSvMdU9v2wX1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT+jUK1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT+jUK1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDF5C4CEEA;
	Mon, 24 Feb 2025 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408059;
	bh=gL0ETcfzFzWiIuJ563cJ/uN5NQ9nFNvwC5Fq6/Lbhlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wT+jUK1FpMh4aW9pvTl4R48wLnZQwqS00qKe7mr2CsrJwIbdrDNYrIUjAU/CxCZVv
	 IZyQ1Hrap7u3BE5Q8fjGETB2bzL5F1MH9SdueOO/MAYr+Tu+9kGQAiTNFZStpu1n8x
	 b2eRsllojYzB2T2l8j7Y/zW5AOHxJ3+wCqN1MZMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/140] net: axienet: Set mac_managed_pm
Date: Mon, 24 Feb 2025 15:34:47 +0100
Message-ID: <20250224142606.471457696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit a370295367b55662a32a4be92565fe72a5aa79bb ]

The external PHY will undergo a soft reset twice during the resume process
when it wake up from suspend. The first reset occurs when the axienet
driver calls phylink_of_phy_connect(), and the second occurs when
mdio_bus_phy_resume() invokes phy_init_hw(). The second soft reset of the
external PHY does not reinitialize the internal PHY, which causes issues
with the internal PHY, resulting in the PHY link being down. To prevent
this, setting the mac_managed_pm flag skips the mdio_bus_phy_resume()
function.

Fixes: a129b41fe0a8 ("Revert "net: phy: dp83867: perform soft reset and retain established link"")
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250217055843.19799-1-nick.hu@sifive.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 02e11827440b5..3517a2275821f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2161,6 +2161,7 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
+	lp->phylink_config.mac_managed_pm = true;
 	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD;
 
-- 
2.39.5



