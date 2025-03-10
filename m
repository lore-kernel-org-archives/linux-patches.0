Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39917CA12;
	Mon, 10 Mar 2025 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629089; cv=none; b=oB/S3yeYJW0o7fY7GqbLnpHQxE3MAd+kY6V1P8u8B3Bj4amty9N376Clq4jBta4UwzV+2+wzk/eCR1X2iQh069UJcnVnwfDPTt6Mu+Mg1oplAl4r2krsgQ9xtkzqgwx3E6/G/8feKhFL2ebAobQ2OSiaJgo5DGGaZpF1LjhNtO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629089; c=relaxed/simple;
	bh=cNInkUvTUkOCUECC5ot7cN5b4bT7fk462I01YAtmpTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuwSh2bcVZalKEYJ+KGWL7CeiHvvu+ZdosaMvYkoYrnEPkZDSuqmhKBkCUVAZCVhk3YIuEw6rNBcDLF6ouRJG/K39XihltuUE2Piss+tS7bXeT4+CN7c6pN5zHOzkzJvTkE5+0N6EcB162ybC3xUTw9+64BMIKoz9h93YdU/sBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phxEml2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phxEml2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB79CC4CEE5;
	Mon, 10 Mar 2025 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629089;
	bh=cNInkUvTUkOCUECC5ot7cN5b4bT7fk462I01YAtmpTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phxEml2IiwFjYtt0Y4ryy9l3TDIAu6v6y3J8hUemIq/tSsDdFdquSjko0soI0c28/
	 WCzlCs1gny8ONrKvpM/45+VA1mRQyHqquTRvCsFK31nkTwsxxFPpHfIqNtONoBA+T4
	 zhayD9lRiNgZdiTfYkwGYX3c5XtnsYc8/jH/B+/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/620] net: sh_eth: Fix missing rtnl lock in suspend/resume path
Date: Mon, 10 Mar 2025 18:00:19 +0100
Message-ID: <20250310170552.450956884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b6e426d8014d1..183db093815cb 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3476,10 +3476,12 @@ static int sh_eth_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (mdp->wol_enabled)
 		ret = sh_eth_wol_setup(ndev);
 	else
 		ret = sh_eth_close(ndev);
+	rtnl_unlock();
 
 	return ret;
 }
@@ -3493,10 +3495,12 @@ static int sh_eth_resume(struct device *dev)
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



