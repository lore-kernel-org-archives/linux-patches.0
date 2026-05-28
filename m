Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2F0339866;
	Thu, 28 May 2026 20:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999230; cv=none; b=HWoJHHXFjuWCGk6hPiCKnsc/jS6zXXl3PAiVYLpzd6nfrNWmyeO4S2K4s4e4lI516kDhC2VFv2YKre7PDQ3wNXaTb9Qh7WjPso0nDjQWcslwxRntkFMhxvTbqfGmBFk+YfP/sk+YxQLEOnLhErsKNgxKPcc7gCHlF8eHjbTvsJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999230; c=relaxed/simple;
	bh=cKY0Y10qbdltheZsr4rygYrv0kC7IYPD94xxca5+J10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyTLhhcefFPhrP6F97Ahp8ztrjkMal7W+2/gYSFbDA3rHxfAZTL3VFMK3WgPIo4FA2qSq4MRS31IdlowL/R3SRo+RuQJN14KQ0JvE4nbYLGkqBa2Gh2yqV04UMu+yfQdj8f2FPFrqdmzvkRT7A79s1xZw8IG+7o9H1qviAR+waA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XahS/+V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XahS/+V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136FD1F000E9;
	Thu, 28 May 2026 20:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999229;
	bh=Izo4Hj4C5TJmMs3ZqDIuU2lIDEMotRXawrqj5SgfMps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XahS/+V+amo0EJRdpk2VxZN/psl+CU/TIPs1DJ2hdsuPqKwkmObZ8RIahdCOw0Byi
	 F0f3SBiIsTL8WcxpQnozidf4FR+AV3qPHBsKNE/71ZGyZZO1IEsHUEUYow6IVAJcK4
	 bbmba3MoYn86lxJIPBEwTESlzn/sllw4rOfH9CZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 454/461] net: enetc: fix missing error code when pf->vf_state allocation fails
Date: Thu, 28 May 2026 21:49:43 +0200
Message-ID: <20260528194700.681960302@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 5027266dea471e140f93dd534845c9c4f43219a3 ]

In enetc_pf_probe(), when the memory allocation for pf->vf_state fails,
the code jumps to the error handling label but the variable 'err' is not
assigned an appropriate error code beforehand. This causes the function
to return 0 (success) on an allocation failure path, misleading the
caller into thinking the probe succeeded. So set err to -ENOMEM before
jumping to the error handling label when the allocation for pf->vf_state
returns NULL.

Fixes: e15c5506dd39 ("net: enetc: allocate vf_state during PF probes")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260520064421.91569-3-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index a12fd54a475f6..ed8f7b3dc5260 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -960,8 +960,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	if (pf->total_vfs) {
 		pf->vf_state = kzalloc_objs(struct enetc_vf_state,
 					    pf->total_vfs);
-		if (!pf->vf_state)
+		if (!pf->vf_state) {
+			err = -ENOMEM;
 			goto err_alloc_vf_state;
+		}
 	}
 
 	err = enetc_setup_mac_addresses(node, pf);
-- 
2.53.0



