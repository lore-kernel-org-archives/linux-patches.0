Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA33252907;
	Wed,  5 Mar 2025 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198710; cv=none; b=Ai5L7B73RP9Mk1dWRSNaMzmHQijcTqxWvg1/iHZpGXqrtimm8ltM7dlKL6xfmRN8mGkhCGmA4IqPk9Oo94gTY8LcCJrJiEJeSLdi26yYFKAWnQGX/O/Myeb3dYervLpOupzxnip30VfPvwazZKGv4Dz10w81drXMlESBTbx+l/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198710; c=relaxed/simple;
	bh=4asMzD7VlV6K4/eGc9L8ZVoX4Z2W/YLw1XHybbA6L7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szhG963qnVG0WqtFDOjkFb7xKObSQG5RUHRycbfuAwffmW1X2xCIh8l6XyMPcQalkFhFEQSvql0uyVGuVzNEVKrYDAP6Rh2DahSqgDUK/zOBdhgVnWqEgeZZgR0fkz7DBkxNjb3ikCm/o/f5K7laiisCs/C80p/f1iN1XeVBeFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gp1Y9vTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gp1Y9vTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2483BC4CED1;
	Wed,  5 Mar 2025 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198710;
	bh=4asMzD7VlV6K4/eGc9L8ZVoX4Z2W/YLw1XHybbA6L7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gp1Y9vTTcUdM8ovHSMR47A0Xhaa+Et9vUsHGA8sSwrJ0hp6NoMUaiOncvEJwfkEtG
	 l3Zv3qqAAwag24Vc+9l71UvVypR9LbwM1hGzpYAFsSH0aCa+q/wvhw72fsnAiY00Yh
	 zVUV8akcIyaHnENoFD7ZhwGtHTZ3IlsQn8sM7IG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 120/157] net: enetc: add missing enetc4_link_deinit()
Date: Wed,  5 Mar 2025 18:49:16 +0100
Message-ID: <20250305174510.131394219@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 8e43decdfbb477dd7800e3902d2d2f105d22ef5f upstream.

The enetc4_link_init() is called when the PF driver probes to create
phylink and MDIO bus, but we forgot to call enetc4_link_deinit() to
free the phylink and MDIO bus when the driver was unbound. so add
missing enetc4_link_deinit() to enetc4_pf_netdev_destroy().

Fixes: 99100d0d9922 ("net: enetc: add preliminary support for i.MX95 ENETC PF")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-7-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -683,6 +683,7 @@ static void enetc4_pf_netdev_destroy(str
 	struct net_device *ndev = si->ndev;
 
 	unregister_netdev(ndev);
+	enetc4_link_deinit(priv);
 	enetc_free_msix(priv);
 	free_netdev(ndev);
 }


