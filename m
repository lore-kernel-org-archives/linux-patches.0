Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51F110E0;
	Fri,  6 Dec 2024 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497184; cv=none; b=Hon75QcIpA/3BRJnVN1qhTP6FqD1mvFz+Miw91qVfxy8o2lMf8gfmeFFvccKNW/LlCiPf0BC+nWIvyhavIHpGZfoUXBsup2xpbK5tZmt0oyAIG1Vae+Xqo2KiggPC5Of+b5rZRPXpUnlYAv6WFyIZIIJUivmT+tJkiQL7w4TKjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497184; c=relaxed/simple;
	bh=DOcRT9SP3Gej1J1u8xZjuDHmgKbp73pY2l+YNCc3sM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7AJEEMF+suUWpvQBmzsWE51p80b66BoV6EZPkYvb5Ad0yIfqKHhhjlkyvI8VwDC17l7SuAVh4N0Y2JS32I4tSu/ZtLux+Jgd/8xAkXujbOlHFnI+vAADnphjyS8guHU1e+M/OpW1cv+ZqFxUQ1G1jj5s+SwXe7zRCnVcjTWlco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQBWwikW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQBWwikW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48ABAC4CED1;
	Fri,  6 Dec 2024 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497184;
	bh=DOcRT9SP3Gej1J1u8xZjuDHmgKbp73pY2l+YNCc3sM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQBWwikW5WYIJ/IKXaWlDC3k+ylQE0l7ISdqY9Qw0rP/9yLvGyn9+m2AwWLnY0798
	 RGNO6wk7dEUZ1tTd6/MTlbU8UmE522JwCiw5X9WPsytTqnCbgbUt0c4MXNZTfboqTr
	 mo0I3YApjqx4+8ubokgRCa1BPEckmLUer2h3ugP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/676] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dcbnl.c
Date: Fri,  6 Dec 2024 15:30:30 +0100
Message-ID: <20241206143701.584458730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit 69297b0d3369488af259e3a7cf53d69157938ea1 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 8e67558177f8 ("octeontx2-pf: PFC config support with DCBx")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index aa01110f04a33..294fba58b6709 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -315,6 +315,11 @@ int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf)
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pfc_rsp *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			err = PTR_ERR(rsp);
+			goto unlock;
+		}
+
 		if (req->rx_pause != rsp->rx_pause || req->tx_pause != rsp->tx_pause) {
 			dev_warn(pfvf->dev,
 				 "Failed to config PFC\n");
-- 
2.43.0



