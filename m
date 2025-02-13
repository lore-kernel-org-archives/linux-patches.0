Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289CE26B0B5;
	Thu, 13 Feb 2025 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458954; cv=none; b=K04ph2+1G5vvbhnzbeCnQeej6b1j6loXM9mWbmYayfEM7V1ouNXZgNVOgUhlwh3mrbjAfbmJFQ1wJm63FziYY/2d0mNVtAsDzTldrIA38PM5UtBEANGGIEgPeb6siEbTeAflw7ym1MSxy8gc6cW/tGIIl4iUA5xLhbBIdqjPy1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458954; c=relaxed/simple;
	bh=/uMDcHs+04fZPbzuK53bOyHK7Pe1dMfkl0I/PqyaWZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrYkEkflwJGcp2LA+2t3So5AzfA/SPGtyTBKvgDz/zwNOoazUSnxqeAsyVdmC7kJ6b9HqN8tVfFyPKMtMpTeaC4uX/9X8I9s2VLnA8ESJ5b4bMuJNvCYRUUWPGDuY4h8l5cfmVqFcHdIGpwBfrS8Oi6OS3J/Zui3cTBQaL7mgBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRMfva7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRMfva7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A69FC4CED1;
	Thu, 13 Feb 2025 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458954;
	bh=/uMDcHs+04fZPbzuK53bOyHK7Pe1dMfkl0I/PqyaWZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRMfva7qylNSnoDo70V566lJMyW3Bcbo1bxmAPBGEIDkAb5eBSzLjF9ZXxh1ooXSe
	 umjzC7Zg/X7vXhtsnNj9qRtK7uIMlFB479B4qApZtMNLV94zS02dAYUbPUgRxQIrxZ
	 n8BAxCtGKbJdnHiEvhDUiYeZhggpZJFyDTlO9UGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 125/443] ethtool: ntuple: fix rss + ring_cookie check
Date: Thu, 13 Feb 2025 15:24:50 +0100
Message-ID: <20250213142445.434020541@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2b91cc1214b165c25ac9b0885db89a0d3224028a ]

The info.flow_type is for RXFH commands, ntuple flow_type is inside
the flow spec. The check currently does nothing, as info.flow_type
is 0 (or even uninitialized by user space) for ETHTOOL_SRXCLSRLINS.

Fixes: 9e43ad7a1ede ("net: ethtool: only allow set_rxnfc with rss + ring_cookie if driver opts in")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250201013040.725123-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 34bee42e12470..7609ce2b2c5e2 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -993,7 +993,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		return rc;
 
 	/* Nonzero ring with RSS only makes sense if NIC adds them together */
-	if (cmd == ETHTOOL_SRXCLSRLINS && info.flow_type & FLOW_RSS &&
+	if (cmd == ETHTOOL_SRXCLSRLINS && info.fs.flow_type & FLOW_RSS &&
 	    !ops->cap_rss_rxnfc_adds &&
 	    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
 		return -EINVAL;
-- 
2.39.5



