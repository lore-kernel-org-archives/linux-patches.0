Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3DC47F53;
	Fri,  6 Dec 2024 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497157; cv=none; b=WSNk0+OS+V6rZgL0K9CuChMBrfsq5n9iUO5xxaKkFuTKJ+8N+bY21jv+VUDRuxXW4ec/u7a1E0Pgvw/avvkJ5Yc0V/w9pZ/uoEyZc5wR4bY7TYVWtOuTk2H2Zn1zwNUdfgmqCx2eUk9L3SLg2pN2v3QzO3v1A9GHLfZSw1lIme8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497157; c=relaxed/simple;
	bh=8bP8L0sfrf7TGPkE1+1X9Qd4oX0DcAGx+yRyvd4sWGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7+z8A0r36wbGjPwJ0BIvGuCh+2MFh58050YXDz+8hJ66rihQD+Nsk9THUvA02zBWr6f19Uf0dsic9QqjsOEFDdFbLE+RnMuBF1yyI/re/iyHhmDhuuPgI5F5m95fcez2KyxWfktRS9TzUaxD0RaJy2E2mIfpuFlKSPhQ4jRp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kVJvQOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kVJvQOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF0FC4CED1;
	Fri,  6 Dec 2024 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497157;
	bh=8bP8L0sfrf7TGPkE1+1X9Qd4oX0DcAGx+yRyvd4sWGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kVJvQOLmLXLLh2L6P2DdOEzw5ZY+z+2RDsbkQZrhUDPkqPZUA6psERK1Lr7bEYYD
	 mrZM5V3er6R0tGcCAsnrFRbJkj1ra+GGSHPBN/utZdqrD95uxuzTizFPMDGCFXMbTR
	 orDzlgKNxhf8P8jRkHYA1mDnDtIFmJMcGLYjjg5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/676] octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c
Date: Fri,  6 Dec 2024 15:30:28 +0100
Message-ID: <20241206143701.505698466@linuxfoundation.org>
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



