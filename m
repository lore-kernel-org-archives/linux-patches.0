Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D33E1F8937;
	Tue,  3 Dec 2024 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240880; cv=none; b=cSGXuLpHsgSb3oA2wXBHZqnz8Ezm4dUUtXkhMEcKXSHTZblIVmBbGKh2UHQMwQYkN8qhPMPoZa/VzQuCuWh/ILUqIDHlKyHoV4L6FIQMxHNxoIJfqp4mtPidN1kZElIte/1RxaIOnyuNlz6O7T+9egW6oaRuq1p6Sf+gz92Y73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240880; c=relaxed/simple;
	bh=d4IIgR4M+fwWiq2oXDsQ7yAbVkoA42/D+qKmtDx5wAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNU0k43hjFoREhkMJbUNlp/Hy3/55UhUHYauHzxln2p9fI1TDMTb7ft8/3oozWghS5tpXwoPRPHCKUQy7kULQKqnuJzCPeUcOJL0xzqz0N3ywVCIjIFdTSuMtDvuAHVn9U10etS1SrgTTGBJBeF+RTNuBQ4XBe5HQjCEVDeunq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSbAsPfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSbAsPfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E8DC4CECF;
	Tue,  3 Dec 2024 15:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240880;
	bh=d4IIgR4M+fwWiq2oXDsQ7yAbVkoA42/D+qKmtDx5wAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSbAsPfuUoz+HvIwmBl86JN0ILdEZp5BlbjyDxr+u+S9DzIc4ruLjOLygJ3aB0QI9
	 iKZd9YTznoWu8L7a7Q4JJBzHRybn3V8Kib28Bpvs45UqZWtQ3hDmM4k4au+2utwywN
	 OuX6TX451I7Ay5r9eeq9/shO7OOYB9d6lgHmZzgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/826] octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c
Date: Tue,  3 Dec 2024 15:39:49 +0100
Message-ID: <20241203144753.984175881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit ac9183023b6a9c09467516abd8aab04f9a2f9564 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 2ca89a2c3752 ("octeontx2-pf: TC_MATCHALL ingress ratelimiting offload")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index c1c99d7054f87..7417087b6db59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -203,6 +203,11 @@ int cn10k_alloc_leaf_profile(struct otx2_nic *pfvf, u16 *leaf)
 
 	rsp = (struct  nix_bandprof_alloc_rsp *)
 	       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		rc = PTR_ERR(rsp);
+		goto out;
+	}
+
 	if (!rsp->prof_count[BAND_PROF_LEAF_LAYER]) {
 		rc = -EIO;
 		goto out;
-- 
2.43.0



