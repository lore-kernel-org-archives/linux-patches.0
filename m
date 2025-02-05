Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A02D1DB128;
	Wed,  5 Feb 2025 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768507; cv=none; b=F3u/ITXMOmfsAK6EFv1H37AEYUU8QjeEHnIdoNweJxmyCjbQX3KbCtQmWywM7RGOUERnRkXZXmunA4W1YiPeT0SNTCEXIc9KChixDxvCuSq14wWsZ61ZQ096vcLn/c4f57W8LKZ+N5u4uzOBPU0AownxPF9B/aTKaS8w/bachLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768507; c=relaxed/simple;
	bh=cdcKcjkK8Fr2jh0vDl0J1zFM+vhR9vlb/uMX23xE3cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzv95kBofuZ+rrHcV0+tvz4jUd7JEOEWiKQWGq+Q2OSKWMKY7v3x3N2UFVU81svAo9z7jKC+6SWEGtOqZtGZV8C7SaEI2iTnD4RJkWiCHfZYpaGNCP3aVlSapk31o7f6eUtPO+bgG1y4O5oTwevrON9UINPatNrh+FY1nS2aRj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRWMW30j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRWMW30j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09293C4CED1;
	Wed,  5 Feb 2025 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768507;
	bh=cdcKcjkK8Fr2jh0vDl0J1zFM+vhR9vlb/uMX23xE3cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRWMW30jF4qsz0vGzRVHhfqA5QvxOx+t7ouFOyViYdsZqbGJn3oU2jgLJYBk8F0Ct
	 xfY/VBMdBIi6a9lmOAjMSIb4KgssKywWKc6uX/RqDUe/pKjwM6d6sR3YxgwNArLxnJ
	 W5aI+oCTeXVa6w5VF5ovz85kvmm25HLxkuTif9UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 550/623] net: sh_eth: Fix missing rtnl lock in suspend/resume path
Date: Wed,  5 Feb 2025 14:44:52 +0100
Message-ID: <20250205134517.261646486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit b95102215a8d0987789715ce11c0d4ec031cbfbe ]

Fix the suspend/resume path by ensuring the rtnl lock is held where
required. Calls to sh_eth_close, sh_eth_open and wol operations must be
performed under the rtnl lock to prevent conflicts with ongoing ndo
operations.

Fixes: b71af04676e9 ("sh_eth: add more PM methods")
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 8887b89210093..5fc8027c92c7c 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3494,10 +3494,12 @@ static int sh_eth_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (mdp->wol_enabled)
 		ret = sh_eth_wol_setup(ndev);
 	else
 		ret = sh_eth_close(ndev);
+	rtnl_unlock();
 
 	return ret;
 }
@@ -3511,10 +3513,12 @@ static int sh_eth_resume(struct device *dev)
 	if (!netif_running(ndev))
 		return 0;
 
+	rtnl_lock();
 	if (mdp->wol_enabled)
 		ret = sh_eth_wol_restore(ndev);
 	else
 		ret = sh_eth_open(ndev);
+	rtnl_unlock();
 
 	if (ret < 0)
 		return ret;
-- 
2.39.5



