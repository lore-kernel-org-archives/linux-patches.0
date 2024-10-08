Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220071DDC24;
	Tue,  8 Oct 2024 12:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391385; cv=none; b=c3rAkYHdzwiDo6EGIchb07xLwtHDv+z2kmkgrdOgjN9KCK2kvhEYo02KapbCewRWd1fvzHMV8XjJD1LNkIsnLnR50/lKjbiwmA8jqk4DHyceCXmSgvBtiGixWh1a6xl+24ntq27t+CR8kMYW7KGGSTztCz69YSJhRC9yJRpCoBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391385; c=relaxed/simple;
	bh=cCp5BrCQIZgjxWkp45YzvnRk/Uwh19/4gcoPpPlToqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJv6vAUlrp1w/fkrIbh6ywcmahrwxZ0sPYVnDzgfaAmJQD8nLoXYTeRtk++Jl/zRrNRxumhbFnsxWMjpNptfMGRIEmV6qgeamvJ7GMMfhe8q2BjLJRMdhbgYXObfrQpZVIFSWzYeNZLmi1DQQOtQgynpP/tEGo0Zg1Amfu8Iue4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yDEoFBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yDEoFBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46619C4CECD;
	Tue,  8 Oct 2024 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391384;
	bh=cCp5BrCQIZgjxWkp45YzvnRk/Uwh19/4gcoPpPlToqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yDEoFBio59+PsVge1kHnBumBhJe4i60j7TZg7KnWziT8vos6Xbxr3TaeN08qFCSY
	 wMw8voQqVUA94GFWkX3FjtDVJ+g/gGsrwxTbK44rTVvgqFXBo23Z7KTyO0iNoVjEEE
	 zSEE183ZY1U65H/aDHRKuG42Ma31wA7ehXsR5fk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 097/558] net: hisilicon: hip04: fix OF node leak in probe()
Date: Tue,  8 Oct 2024 14:02:07 +0200
Message-ID: <20241008115706.186938676@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 17555297dbd5bccc93a01516117547e26a61caf1 ]

Driver is leaking OF node reference from
of_parse_phandle_with_fixed_args() in probe().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240827144421.52852-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index b91e7a06b97f7..beb815e5289b1 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -947,6 +947,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	priv->tx_coalesce_timer.function = tx_done;
 
 	priv->map = syscon_node_to_regmap(arg.np);
+	of_node_put(arg.np);
 	if (IS_ERR(priv->map)) {
 		dev_warn(d, "no syscon hisilicon,hip04-ppe\n");
 		ret = PTR_ERR(priv->map);
-- 
2.43.0



