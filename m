Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D603D3D34A2;
	Thu, 15 Jan 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499960; cv=none; b=ND5CmxvDuoCOUWJQXLRITgUdlV/6RMvNQg9RkCLD9TcqTxBz14UHUFHTqXSNdw0nyZLfpD/l/1QmCOJV6Idtx5veoPZFazCrU1zaQiq+Ch6gP/Ky+n3eBIHxoqDgforFTxfJgtw3zkta5IVlO6uvtFXnjGCi/FCfYLvPP4qUmN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499960; c=relaxed/simple;
	bh=MV8E4s/Ju6fKezwFctB4Z5pftQ3x3m6//SDBEEleXR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6d3WGCdOx3beYUVnBaygTqTJ/oXosOLID5Rhb3Ku6xrVrNEac/9chWrutvGBn8qC/gzw0ZAITozxGGzd4PznoxAAtqiPjwPeZIr239lCiP276g0xTI00bE9qv/T4CqSHEIq1i/kKzaOkA7hE07c6TdK71dvbxPwaiVALa1K8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMZaNGnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMZaNGnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E8EC116D0;
	Thu, 15 Jan 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499960;
	bh=MV8E4s/Ju6fKezwFctB4Z5pftQ3x3m6//SDBEEleXR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMZaNGnuyJgTEQWOMKPd4ofwjs6StLe40tWnPE+Rc+85apHL0G97GDn5zXs8229bn
	 3wb5uXHEUWGXIAzhUIsO1VOPmijHZbvF5gH3CGo3AwN7Qre0/bHsZaAzBFgSaDXbeC
	 Qq0VnrRstpNN2LahjxJD6ZtyrX/rYAzbu/lJeXwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 408/451] net: ethtool: fix the error condition in ethtool_get_phy_stats_ethtool()
Date: Thu, 15 Jan 2026 17:50:09 +0100
Message-ID: <20260115164245.700588159@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit 0dcc53abf58d572d34c5313de85f607cd33fc691 upstream.

Clang static checker (scan-build) warning:
net/ethtool/ioctl.c:line 2233, column 2
Called function pointer is null (null dereference).

Return '-EOPNOTSUPP' when 'ops->get_ethtool_phy_stats' is NULL to fix
this typo error.

Fixes: 201ed315f967 ("net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://lore.kernel.org/r/20240605034742.921751-1-suhui@nfschina.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2089,7 +2089,7 @@ static int ethtool_get_phy_stats_ethtool
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int n_stats, ret;
 
-	if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
+	if (!ops || !ops->get_sset_count || !ops->get_ethtool_phy_stats)
 		return -EOPNOTSUPP;
 
 	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);


