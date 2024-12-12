Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6267B223C62;
	Thu, 12 Dec 2024 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023180; cv=none; b=i5k3Gt0FcfuhbIdkweuM4wAaiNiAwROSZVw1ASvd+4FFdjqXodE9VEI3DuCtQr0fjRefur7k7GNTGvFbutFM3tvn5+ELrKiqBGPodb5SxIAHz2BagdBOTctaFhGQdUVckW827VOgHYjWL52EUTqmoK7/Wd6oYvrL051bNTevvgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023180; c=relaxed/simple;
	bh=uy1CCFBL+GY7cjPf11mfORWKXTT4FArCWusrItKk3qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADZLxKvIBpYXjp/7B/mIuXbrFag33DjisrmZbiBS1v3dLG78MWmSSiUsuqM8QuJ0e5Ayj4uHYN9lAaGa5jxzzalW+2TLVbyAm3nd8jx7S+Umy4v05I9POEWpgtPdE4aftcGjWdsxpkhasA3HEJIbuSl8xCeSmfBS0VoRJx1nVBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVLF3JJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVLF3JJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A587C4CED3;
	Thu, 12 Dec 2024 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023180;
	bh=uy1CCFBL+GY7cjPf11mfORWKXTT4FArCWusrItKk3qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVLF3JJAf74ZEXSJr7WYb+JslG0+WzEXXSMfdt4zUuOTO4Tb5ScLrnVAuG9VFIW9V
	 o6UAspp12q7xaw4BFSE+HtLjNgJQlbxCf9ImJr/jA9IXqRFuVKVatlVrHkyN6eBvCJ
	 yTd3aX86+W5WSiKGlaQhErgvZNghxSfBc+rip6ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Forestier <florian@forestier.re>,
	Louis Leseur <louis.leseur@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/565] net/qed: allow old cards not supporting "num_images" to work
Date: Thu, 12 Dec 2024 16:00:14 +0100
Message-ID: <20241212144328.228045903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Louis Leseur <louis.leseur@gmail.com>

[ Upstream commit 7a0ea70da56ee8c2716d0b79e9959d3c47efab62 ]

Commit 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
added support for populating flash image attributes, notably
"num_images". However, some cards were not able to return this
information. In such cases, the driver would return EINVAL, causing the
driver to exit.

Add check to return EOPNOTSUPP instead of EINVAL when the card is not
able to return these information. The caller function already handles
EOPNOTSUPP without error.

Fixes: 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
Co-developed-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Louis Leseur <louis.leseur@gmail.com>
Link: https://patch.msgid.link/20241128083633.26431-1-louis.leseur@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index b734c120d508f..1f3834c6c5878 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3253,7 +3253,9 @@ int qed_mcp_bist_nvm_get_num_images(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
+	if (((rsp & FW_MSG_CODE_MASK) == FW_MSG_CODE_UNSUPPORTED))
+		rc = -EOPNOTSUPP;
+	else if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
 		rc = -EINVAL;
 
 	return rc;
-- 
2.43.0



